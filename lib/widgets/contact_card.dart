import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Chat/convScreen.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget buildContactCard(BuildContext context, UserData contact, String userID) {
  void createConversation(BuildContext context) {
    String convoID = getConversationID(userID, contact.id);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (contact.photoUrl != null)
                CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(contact.photoUrl!))
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
              Text(
                contact.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
