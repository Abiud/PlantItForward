import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/Convo.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
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
    final UserData user = ProviderWidget.Provider.of(context)!.auth.currentUser;
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
    groupId = getGroupChatId();

    return Container(
        margin:
            const EdgeInsets.only(left: 4.0, right: 4.0, top: 5.0, bottom: 5.0),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              buildContent(context),
            ])));
  }

  Widget buildContent(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ConvScreen(
                userID: user.id, contact: peer, convoID: getGroupChatId())));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: buildConvoDetails(peer.name!, context)),
              ],
            ),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
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
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                verticalSpaceSmall,
                Text(formatMessage(lastMessage['content']),
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
    // return Column(
    //   children: <Widget>[
    //     Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.only(left: 16.0),
    //             child: Text(
    //               title,
    //               textAlign: TextAlign.left,
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //           read
    //               ? Container()
    //               : Icon(Icons.brightness_1,
    //                   color: Theme.of(context).accentColor, size: 15)
    //         ]),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 16.0, top: 8.0),
    //             child: Text(lastMessage['content'],
    //                 textAlign: TextAlign.left,
    //                 maxLines: 1,
    //                 overflow: TextOverflow.clip),
    //           ),
    //         ),
    //       ],
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Text(
    //             getTime(lastMessage['timestamp']),
    //             textAlign: TextAlign.right,
    //           ),
    //         )
    //       ],
    //     )
    //   ],
    // );
  }

  String formatMessage(String message) {
    int len = message.length;
    return len > 15 ? message.substring(0, 20) + "..." : message;
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

  String getGroupChatId() {
    if (user.id.hashCode <= peer.id.hashCode) {
      return user.id + '_' + peer.id;
    } else {
      return peer.id + '_' + user.id;
    }
  }
}
