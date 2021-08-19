import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/main.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Chat/convScreen.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/utils/routing_constants.dart';

Widget generateScreen(Map<String, dynamic> data) {
  print(data['route']);
  switch (data['route']) {
    case HomeViewRoute:
      return Wrapper();
    case LoginViewRoute:
      return SignIn();
    case WeeklyReportsRoute:
      return Produce();
    case ChatRoute:
      return Chat();
    case ConversationRoute:
      return ConvScreen(
          userID: data['idTo'],
          contactId: data['idFrom'],
          convoID: data['convId']);
    default:
      return Wrapper();
  }
}
