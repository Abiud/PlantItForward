import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/authenticate/register.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void _toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: _toggleView);
    } else {
      return Register(toggleView: _toggleView);
    }
  }
}
