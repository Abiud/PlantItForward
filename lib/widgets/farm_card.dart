import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:plant_it_forward/Models/Farm.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Admin/Farms/editFarm.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget buildFarmCard(BuildContext context, Farm farm) {
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
              return confirmationDialog(context, farm);
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
                CupertinoPageRoute(builder: (context) => EditFarm(farm: farm)));
          },
          child: Stack(children: [
            Container(
              height: 70,
              width: 5,
              color: secondaryBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm.name,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpaceTiny,
                        if (farm.location != null)
                          Text(farm.location!,
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

Widget confirmationDialog(BuildContext context, Farm item) {
  return AlertDialog(
    title: Text("Do you want to delete the selected farm?"),
    content: Text("The selected farm will be permanently deleted."),
    actions: [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
      TextButton(
          onPressed: () {
            deleteTrip(item).whenComplete(() => Navigator.of(context).pop());
          },
          child: Text(
            "Continue",
            style: TextStyle(color: Colors.redAccent),
          ))
    ],
  );
}

Future deleteTrip(Farm item) async {
  return await FirebaseFirestore.instance
      .collection("farms")
      .doc(item.id)
      .delete();
}
