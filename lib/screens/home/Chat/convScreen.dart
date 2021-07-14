import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class ConvScreen extends StatelessWidget {
  const ConvScreen(
      {required this.userID, required this.contact, required this.convoID});
  final String userID, convoID;
  final UserData contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryBlue,
        leadingWidth: 90,
        centerTitle: false,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back),
              horizontalSpaceSmall,
              contact.photoUrl != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(contact.photoUrl!))
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/PIF-Logo_3_5.webp"),
                              fit: BoxFit.cover)),
                    ),
            ],
          ),
        ),
        title: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Text(
              contact.name!,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.more_vert))],
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
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Bubble(
            color: Colors.blueGrey,
            elevation: 1,
            padding: const BubbleEdges.all(10.0),
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            child: SelectableText(document['content'],
                style: TextStyle(color: Colors.white))),
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Bubble(
            color: secondaryBlue,
            elevation: 1,
            padding: const BubbleEdges.all(10.0),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftTop,
            child: SelectableText(document['content'],
                style: TextStyle(color: Colors.white))),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: screenHeightFraction(context, dividedBy: 3)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    autofocus: false,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: textEditingController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type your message...',
                    ),
                  )),
            ),
          ),
          horizontalSpaceSmall,
          ClipOval(
            child: Material(
              color: secondaryBlue, // Button color
              child: InkWell(
                splashColor: primaryGreen, // Splash color
                onTap: () => onSendMessage(textEditingController.text),
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
              ),
            ),
          )
          // Ink(
          //   decoration:
          //       ShapeDecoration(color: secondaryBlue, shape: CircleBorder()),
          //   child: IconButton(
          //     icon: Icon(Icons.send, size: 40),
          //     color: Colors.white,
          //     onPressed: () => onSendMessage(textEditingController.text),
          //   ),
          // ),
        ],
      ),
      width: double.infinity,
    );
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
