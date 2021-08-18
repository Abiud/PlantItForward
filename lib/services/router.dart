import 'package:flutter/material.dart';
import 'package:plant_it_forward/main.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';
import 'package:plant_it_forward/screens/home/Produce/WeeklyReport/weekly_report_view.dart';
import 'package:plant_it_forward/utils/routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => Wrapper());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => SignIn());
    case WeeklyReports:
      return MaterialPageRoute(builder: (context) => WeeklyReportView());
    default:
      return MaterialPageRoute(builder: (context) => Wrapper());
  }
}
