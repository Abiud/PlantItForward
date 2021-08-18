import 'package:flutter/material.dart';
import 'package:plant_it_forward/main.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/utils/routing_constants.dart';

Widget generateScreen(String route) {
  switch (route) {
    case HomeViewRoute:
      return Wrapper();
    case LoginViewRoute:
      return SignIn();
    case WeeklyReportsRoute:
      return Produce();
    case ChatRoute:
      return Chat();
    default:
      return Wrapper();
  }
}
