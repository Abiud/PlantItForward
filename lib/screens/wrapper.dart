import 'package:flutter/material.dart';
import 'package:plant_it_forward/models/UserData.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
