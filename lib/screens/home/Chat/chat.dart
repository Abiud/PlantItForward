import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/AppUser.dart';
import 'package:plant_it_forward/Models/Convo.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Chat/addChat.dart';
import 'package:plant_it_forward/screens/home/Chat/allConvos.dart';
import 'package:plant_it_forward/services/chat.dart';
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryBlue,
          title: Text('Chat'),
          actions: [
            if (Provider.of<UserData>(context).isAdmin())
              IconButton(
                onPressed: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddChat())),
                icon: Icon(Icons.add),
              )
          ],
        ),
        body: StreamProvider<List<Convo>>.value(
            initialData: [],
            value: chatService
                .streamConversations(Provider.of<AppUser?>(context)!.uid),
            child: ConversationDetailsProvider()));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  ConversationDetailsProvider({
    Key? key,
  }) : super(key: key);

  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
        value: ChatService.getUsersByList(
            getUserIds(Provider.of<List<Convo>>(context), context)),
        initialData: [],
        catchError: (_, err) {
          print(err.toString());
          return [];
        },
        child: AllConvos());
  }

  List<String> getUserIds(List<Convo> _convos, BuildContext context) {
    final List<String> users = <String>[];
    if (_convos.length > 0) {
      for (Convo c in _convos) {
        c.userIds[0] != Provider.of<AppUser?>(context)!.uid
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}
