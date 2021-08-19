import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/Message.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/utils/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Profile/viewProfile.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConvScreen extends StatefulWidget {
  final String userID, convoID;
  final String? contactId;
  final UserData? contact;
  const ConvScreen(
      {required this.userID,
      this.contact,
      this.contactId,
      required this.convoID});

  @override
  _ConvScreenState createState() => _ConvScreenState();
}

class _ConvScreenState extends State<ConvScreen> {
  late String userID, convoID;
  late Future<UserData> contact;
  bool selectMode = false;
  bool editMode = false;
  List<Message> selectedDocs = [];
  Message? msgToEdit;
  String? tappedMessage;

  final StreamController<List<DocumentSnapshot>> _messagesController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];
  static const int messageLimit = 20;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  int totalFetched = 0;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    convoID = widget.convoID;
    contact = getContact();
    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index ==
          totalFetched - 1) _getMessages(scroll: true);
    });
  }

  final TextEditingController textEditingController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void dispose() {
    textEditingController.dispose();
    _messagesController.close();
    itemPositionsListener.itemPositions.removeListener(() {});
    super.dispose();
  }

  Future<UserData> getContact() async {
    if (widget.contact != null) return Future.value(widget.contact);
    if (widget.contactId != null) {
      late UserData data;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.contactId)
          .get()
          .then((value) => data = UserData.fromSnapshot(value))
          .onError((e, stackTrace) => Future.error(e.toString()));
      return data;
    }
    return Future.error("No user or Id provided");
  }

  Stream<List<DocumentSnapshot>> listenToMessagesRealTime() {
    _getMessages();
    return _messagesController.stream;
  }

  void _getMessages({bool scroll = false}) {
    if (!_hasMoreData) {
      return;
    }
    if (!scroll && totalFetched > 0) {
      return;
    }
    print("fetching.....");
    final CollectionReference _produceCollectionReference = FirebaseFirestore
        .instance
        .collection("messages")
        .doc(convoID)
        .collection(convoID);
    var pagechatQuery = _produceCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(20);
    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    var currentRequestIndex = _allPagedResults.length;
    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var moreProduce = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = moreProduce;
          } else {
            _allPagedResults.add(moreProduce);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          totalFetched = allChats.length;

          if (!_messagesController.isClosed) _messagesController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }
          _hasMoreData = moreProduce.length == messageLimit;
        } else {
          if (mounted)
            setState(() {
              _hasMoreData = false;
            });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: contact,
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(child: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            return Material(
              child: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          } else {
            UserData contactData = snapshot.data!;
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
                      contactData.photoUrl != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(contactData.photoUrl!))
                          : Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/PIF-Logo_3_5.webp"),
                                      fit: BoxFit.cover)),
                            ),
                    ],
                  ),
                ),
                title: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ViewProfile(
                            profile: contactData,
                          ))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Text(
                      contactData.name,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                actions: selectMode
                    ? [
                        selectedDocs.length == 1
                            ? IconButton(
                                onPressed: () => switchToEdit(),
                                icon: Icon(Icons.edit))
                            : Container(),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    if (selectedDocs.length > 0)
                                      return confirmationDialog(context);
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
                            onPressed: () => cancelSelection(),
                            icon: Icon(Icons.close))
                      ]
                    : [
                        IconButton(
                            onPressed: () => {}, icon: Icon(Icons.more_vert))
                      ],
              ),
              body: Container(
                child: Column(
                  children: [
                    buildMessages(contactData.id),
                    buildInput(contactData.id)
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget buildItem(int index, Message msg, String contactId) {
    if (!msg.read && msg.idTo == userID) {
      updateMessageRead(msg, convoID, contactId);
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

  Widget buildMessages(String contactId) {
    return Expanded(
      child: StreamBuilder<List<DocumentSnapshot>>(
        stream: listenToMessagesRealTime(),
        builder: (BuildContext context, messageSnapshot) {
          if (messageSnapshot.connectionState == ConnectionState.waiting ||
              messageSnapshot.connectionState == ConnectionState.none) {
            return messageSnapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Text("No Messages found."),
                  );
          } else {
            if (messageSnapshot.hasData) {
              final messageDocs = messageSnapshot.data!;
              return ScrollablePositionedList.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  int idx = index >= 0 ? index : 0;
                  Message msg = Message.fromMap(
                      messageDocs[idx].data() as Map<String, dynamic>,
                      messageDocs[idx].id,
                      messageDocs[idx].reference,
                      idx);
                  return buildItem(idx, msg, contactId);
                },
                itemCount: messageSnapshot.data!.length,
                reverse: true,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildInput(String contactId) {
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
                        onEditMessage(contactId)
                            .then((value) => leaveEditMode());
                      onSendMessage(textEditingController.text, contactId);
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

  Widget confirmationDialog(BuildContext context) {
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

  void onSendMessage(String content, String contactId) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      sendMessage(convoID, userID, contactId, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      itemScrollController.scrollTo(
          index: 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  Future onEditMessage(String contactId) {
    String txt = textEditingController.text;
    if (txt != '') {
      textEditingController.clear();
      msgToEdit!.content = txt.trim();
      return FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(getGroupChatId(userID, contactId))
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

  void updateMessageRead(Message msg, String convoID, String contactId) {
    // check
    FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .update({'lastMessage.read': true});
    FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(getGroupChatId(userID, contactId))
        .doc(msg.id)
        .update({"read": true});
  }

  bool isSelectedDoc(String docId) {
    for (Message item in selectedDocs) {
      if (item.id == docId) return true;
    }
    return false;
  }

  Future batchDelete() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    selectedDocs.forEach((element) {
      batch.delete(element.reference!);
    });
    return await batch.commit();
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
    return selectMode &&
        Provider.of<UserData>(context, listen: false).isAdmin();
  }
}
