import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';

class ConvScreen extends StatelessWidget {
  const ConvScreen(
      {required this.userID, required this.contact, required this.convoID});
  final String userID, convoID;
  final UserData contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name!),
      ),
      body: ChatScreen(
        userID: userID,
        contact: contact,
        convoID: convoID,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {Key? key,
      required this.userID,
      required this.contact,
      required this.convoID})
      : super(key: key);
  final String userID, convoID;
  final UserData contact;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String userID, convoID;
  late UserData contact;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    convoID = widget.convoID;
    contact = widget.contact;
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    listScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [buildMessages(), buildInput()],
          )
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (!document['read'] && document['idTo'] == userID) {
      updateMessageRead(document, convoID);
    }

    if (document['idFrom'] == userID) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Bubble(
              color: Colors.blueGrey,
              elevation: 1,
              padding: const BubbleEdges.all(10.0),
              nip: BubbleNip.rightTop,
              child: Text(document['content'],
                  style: TextStyle(color: Colors.white)))
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Bubble(
                  color: Colors.blue,
                  elevation: 1,
                  padding: const BubbleEdges.all(10.0),
                  nip: BubbleNip.leftTop,
                  child: Text(document['content'],
                      style: TextStyle(color: Colors.white)))
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(convoID)
            .collection(convoID)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data!.docs[index]),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildInput() {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: Colors.grey.shade300))),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      autofocus: false,
                      maxLines: 3,
                      controller: textEditingController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type your message...',
                      ),
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send, size: 25),
                onPressed: () => onSendMessage(textEditingController.text),
              ),
            ),
          ],
        ),
        width: double.infinity,
        height: 70.0);
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      sendMessage(convoID, userID, contact.id, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  static void sendMessage(
    String convoID,
    String id,
    String pid,
    String content,
    String timestamp,
  ) {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, pid]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(convoID)
          .doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        await transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': pid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  void updateMessageRead(DocumentSnapshot doc, String convoID) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .update({'lastMessage.read': true});
  }
}
