import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/screens/home/Admin/Users/editUser.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget buildUserCard(BuildContext context, UserData user) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return confirmationDialog(context, user);
            }),
      ),
      IconSlideAction(
        caption: 'Close',
        color: Colors.grey.shade600,
        icon: Icons.close,
        onTap: () {},
      ),
    ],
    child: Container(
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => EditUser(user: user)));
          },
          child: Stack(children: [
            Container(
              height: 88,
              width: 5,
              color: secondaryBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (user.photoUrl != null)
                    CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(user.photoUrl!))
                  else
                    Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("assets/PIF-Logo_3_5.webp"),
                                fit: BoxFit.cover))),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpaceTiny,
                        if (user.role != null)
                          Text(user.role!,
                              style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  horizontalSpaceSmall,
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}

Widget confirmationDialog(BuildContext context, UserData user) {
  return AlertDialog(
    title: Text("Do you want to delete the selected user?"),
    content: Text("The selected user will be permanently deleted."),
    actions: [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
      TextButton(
          onPressed: () {
            deleteTrip(user).whenComplete(() => Navigator.of(context).pop());
          },
          child: Text(
            "Continue",
            style: TextStyle(color: Colors.redAccent),
          ))
    ],
  );
}

Future deleteTrip(UserData user) async {
  return await FirebaseFirestore.instance
      .collection("users")
      .doc(user.id)
      .delete();
}
