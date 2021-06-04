import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Chat/convScreen.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget buildContactCard(BuildContext context, UserData contact, String userID) {
  void createConversation(BuildContext context) {
    String convoID = getConversationID(userID, contact.id);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ConvScreen(
              userID: userID,
              contact: contact,
              convoID: convoID,
            )));
  }

  return Material(
    child: GestureDetector(
      onTap: () => createConversation(context),
      child: Container(
        height: screenHeight(context) > 1200 ? 100 : 85,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(contact.name!),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: secondaryBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: 18,
                    height: 18,
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Text("11:30")
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
