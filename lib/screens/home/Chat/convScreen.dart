import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/Message.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Profile/viewProfile.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConvScreen extends StatefulWidget {
  const ConvScreen(
      {required this.userID, required this.contact, required this.convoID});
  final String userID, convoID;
  final UserData contact;

  @override
  _ConvScreenState createState() => _ConvScreenState();
}

class _ConvScreenState extends State<ConvScreen> {
  late String userID, convoID;
  late UserData contact;
  bool selectMode = false;
  bool editMode = false;
  List<Message> selectedDocs = [];
  Message? msgToEdit;
  String? tappedMessage;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    convoID = widget.convoID;
    contact = widget.contact;
  }

  final TextEditingController textEditingController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

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
              widget.contact.photoUrl != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.contact.photoUrl!))
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
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ViewProfile(
                    profile: contact,
                  ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Text(
              widget.contact.name!,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        actions: selectMode
            ? [
                selectedDocs.length == 1
                    ? IconButton(
                        onPressed: () => switchToEdit(), icon: Icon(Icons.edit))
                    : Container(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            if (selectedDocs.length > 0)
                              return confirmationDialog();
                            return AlertDialog(
                              title: Text("No messages are selected"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Ok")),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () => cancelSelection(), icon: Icon(Icons.close))
              ]
            : [IconButton(onPressed: () => {}, icon: Icon(Icons.more_vert))],
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [buildMessages(), buildInput()],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index, Message msg) {
    if (!msg.read && msg.idTo == userID) {
      updateMessageRead(msg, convoID);
    }

    if (msg.idFrom == userID) {
      // Right (my message)
      return GestureDetector(
        onLongPress: () {
          if (!selectMode)
            setState(() {
              selectMode = true;
              selectedDocs.add(msg);
            });
        },
        onTap: () {
          if (selectMode)
            addMsgToRemove(msg);
          else
            setState(() {
              if (tappedMessage != msg.id)
                tappedMessage = msg.id;
              else
                tappedMessage = null;
            });
        },
        child: Container(
          color:
              isSelectedDoc(msg.id) ? Colors.teal.shade100 : Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 60,
                      height: 40,
                      child: selectMode
                          ? Checkbox(
                              value: isSelectedDoc(msg.id),
                              onChanged: (val) => addMsgToRemove(msg),
                              shape: CircleBorder(),
                            )
                          : null),
                  Expanded(
                    child: Bubble(
                        color: Colors.blueGrey,
                        elevation: 1,
                        padding: const BubbleEdges.all(10.0),
                        alignment: Alignment.topRight,
                        nip: BubbleNip.rightTop,
                        child: selectMode
                            ? SelectableText(msg.content,
                                style: TextStyle(color: Colors.white))
                            : Text(msg.content,
                                style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
              if (tappedMessage == msg.id) ...[
                verticalSpaceTiny,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('EEE h:mm a').format(msg.timestamp),
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                      if (msg.edited != null)
                        if (msg.edited == true) ...[
                          horizontalSpaceTiny,
                          Text(
                            "Edited",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      );
    } else {
      // Left (peer message)
      return GestureDetector(
        onLongPress: () {
          if (!selectMode)
            setState(() {
              selectMode = true;
              selectedDocs.add(msg);
            });
        },
        onTap: () {
          if (canEliminateAllMessages())
            addMsgToRemove(msg);
          else
            setState(() {
              if (tappedMessage != msg.id)
                tappedMessage = msg.id;
              else
                tappedMessage = null;
            });
        },
        child: Container(
          color:
              isSelectedDoc(msg.id) ? Colors.teal.shade100 : Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Bubble(
                        color: secondaryBlue,
                        elevation: 1,
                        padding: const BubbleEdges.all(10.0),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        child: selectMode
                            ? SelectableText(msg.content,
                                style: TextStyle(color: Colors.white))
                            : Text(msg.content,
                                style: TextStyle(color: Colors.white))),
                  ),
                  Container(
                      width: 60,
                      height: 40,
                      child: canEliminateAllMessages()
                          ? Checkbox(
                              value: isSelectedDoc(msg.id),
                              onChanged: (val) => addMsgToRemove(msg),
                              shape: CircleBorder(),
                            )
                          : null),
                ],
              ),
              if (tappedMessage == msg.id) ...[
                verticalSpaceTiny,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE h:mm a').format(msg.timestamp),
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                      if (msg.edited != null)
                        if (msg.edited == true) ...[
                          horizontalSpaceTiny,
                          Text(
                            "Edited",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                    ],
                  ),
                )
              ]
            ],
          ),
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
            return ScrollablePositionedList.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemBuilder: (BuildContext context, int index) {
                int idx = index >= 0 ? index : 0;
                Message msg = Message.fromMap(
                    snapshot.data!.docs[idx].data() as Map<String, dynamic>,
                    snapshot.data!.docs[idx].id,
                    snapshot.data!.docs[idx].reference,
                    idx);
                return buildItem(idx, msg);
              },
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
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
      margin: EdgeInsets.fromLTRB(8, 4, 8, 16),
      padding: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (editMode == true) ...[
            GestureDetector(
              onTap: () => itemScrollController.scrollTo(
                  index: msgToEdit!.listIndex!,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      horizontalSpaceSmall,
                      Expanded(
                          child: Text(
                              "Editing: ${cutString(msgToEdit!.content, 30)}")),
                      IconButton(
                          onPressed: () => leaveEditMode(),
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
              ),
            ),
            verticalSpaceTiny,
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // Edit text
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: screenHeightFraction(context, dividedBy: 3)),
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
                    onTap: () {
                      if (editMode)
                        onEditMessage().then((value) => leaveEditMode());
                      onSendMessage(textEditingController.text);
                    },
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: editMode
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget confirmationDialog() {
    return AlertDialog(
      title: Text("Do you want to delete the selected messages?"),
      content: Text(
          "The selected messages will be permanently deleted for everyone in the conversation."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () => batchDelete().then((value) {
                  selectedDocs = [];
                }).whenComplete(() => Navigator.of(context).pop()),
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      sendMessage(convoID, userID, contact.id, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      itemScrollController.scrollTo(
          index: 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  Future onEditMessage() {
    String txt = textEditingController.text;
    if (txt != '') {
      textEditingController.clear();
      msgToEdit!.content = txt.trim();
      return FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(getConversationID(userID, contact.id))
          .doc(msgToEdit!.id)
          .update({"content": msgToEdit!.content, "edited": true});
    }
    return Future.error("Message is empty");
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

  void updateMessageRead(Message msg, String convoID) {
    // batch update the read to true
    // check
    print("updating");
    FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .update({'lastMessage.read': true});
    FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(getConversationID(userID, contact.id))
        .doc(msg.id)
        .update({"read": true});
  }

  bool isSelectedDoc(String docId) {
    for (Message item in selectedDocs) {
      if (item.id == docId) return true;
    }
    return false;
  }

  Future batchDelete() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    selectedDocs.forEach((element) {
      batch.delete(element.reference!);
    });
    return batch.commit();
  }

  void addMsgToRemove(Message msg) {
    if (selectMode == true && !isSelectedDoc(msg.id))
      setState(() {
        selectedDocs.add(msg);
      });
    else if (selectMode == true)
      setState(() {
        selectedDocs.removeWhere((element) => element.id == msg.id);
      });
  }

  void cancelSelection() {
    setState(() {
      selectMode = false;
      selectedDocs = [];
    });
  }

  void switchToEdit() {
    textEditingController.text = selectedDocs[0].content;
    setState(() {
      msgToEdit = selectedDocs[0];
      editMode = true;
      cancelSelection();
    });
  }

  void leaveEditMode() {
    setState(() {
      editMode = false;
      msgToEdit = null;
    });
  }

  bool canEliminateAllMessages() {
    return selectMode && Provider.of(context)!.auth.currentUser.isAdmin();
  }
}
