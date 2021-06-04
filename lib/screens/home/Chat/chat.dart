import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Convo.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/screens/home/Chat/addChat.dart';
import 'package:plant_it_forward/screens/home/Chat/allConvos.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/services/chat.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart'
    as ProviderWidget;
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final AuthService auth = ProviderWidget.Provider.of(context)!.auth;
    // final DatabaseService db = ProviderWidget.Provider.of(context)!.db;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'chat', // a different string for each navigationBar
          transitionBetweenRoutes: false,
          middle: Text("Chat"),
          trailing: CupertinoButton(
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddChat()));
              }),
          backgroundColor: Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.transparent)),
        ),
        child: SafeArea(
          child: StreamProvider<List<Convo>>.value(
              initialData: [],
              value: chatService.streamConversations(auth.currentUser.id),
              child: ConversationDetailsProvider()),
        ));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  ConversationDetailsProvider({
    Key? key,
  }) : super(key: key);

  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final AuthService auth = ProviderWidget.Provider.of(context)!.auth;

    return StreamProvider<List<UserData>>.value(
        value: ChatService.getUsersByList(
            getUserIds(Provider.of<List<Convo>>(context), auth)),
        initialData: [],
        child: AllConvos());
  }

  List<String> getUserIds(List<Convo> _convos, AuthService auth) {
    final List<String> users = <String>[];
    if (_convos != null) {
      for (Convo c in _convos) {
        c.userIds[0] != auth.currentUser.id
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}
