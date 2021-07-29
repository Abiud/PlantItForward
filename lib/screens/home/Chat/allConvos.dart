import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/Convo.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Chat/addChat.dart';
import 'package:plant_it_forward/screens/home/Chat/convScreen.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart'
    as ProviderWidget;
import 'package:provider/provider.dart';

class AllConvos extends StatelessWidget {
  const AllConvos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserData user =
        ProviderWidget.Provider.of(context)!.auth.currentUser!;
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<UserData> _users = Provider.of<List<UserData>>(context);

    return _convos.length > 0 && _users.length > 0
        ? Scaffold(
            body: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: getWidgets(context, user, _convos, _users),
            ),
          )
        : Center(
            child: Text(
            "You don't have any conversation.",
            style: TextStyle(color: Colors.grey.shade700),
          ));
  }

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => AddChat()));
  }

  Map<String, UserData> getUserMap(List<UserData> users) {
    final Map<String, UserData> userMap = Map();
    for (UserData u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(BuildContext context, UserData user,
      List<Convo> _convos, List<UserData> _users) {
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && user != null) {
      final Map<String, UserData> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.id) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]]!,
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]]!,
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }
}

class ConvoListItem extends StatelessWidget {
  ConvoListItem(
      {Key? key,
      required this.user,
      required this.peer,
      required this.lastMessage})
      : super(key: key);

  final UserData user;
  final UserData peer;
  Map<dynamic, dynamic> lastMessage;

  late BuildContext context;
  late String groupId;
  bool read = false;

  @override
  Widget build(BuildContext context) {
    if (lastMessage['idFrom'] == user.id) {
      read = true;
    } else {
      read = lastMessage['read'] == null ? true : lastMessage['read'];
    }
    this.context = context;
    groupId = getGroupChatId(user.id, peer.id);

    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      buildContent(context),
    ]));
  }

  Widget buildContent(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ConvScreen(
                userID: user.id,
                contact: peer,
                convoID: getGroupChatId(user.id, peer.id))));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Container(
              width: double.infinity,
              child: buildConvoDetails(peer.name, context)),
        ),
      ),
    );
  }

  Widget buildConvoDetails(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (peer.photoUrl != null)
              CircleAvatar(
                  radius: 32, backgroundImage: NetworkImage(peer.photoUrl!))
            else
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/PIF-Logo_3_5.webp"),
                        fit: BoxFit.cover)),
              ),
            horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                verticalSpaceSmall,
                Text(cutString(lastMessage['content'], 20),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.clip),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            read
                ? Container(
                    width: 18,
                    height: 18,
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: secondaryBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: 18,
                    height: 18,
                  ),
            verticalSpaceSmall,
            Text(
              getTime(lastMessage['timestamp']),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        )
      ],
    );
  }

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }
}
