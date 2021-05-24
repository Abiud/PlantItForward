import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'profile', // a different string for each navigationBar
        transitionBetweenRoutes: false,
        leading: CupertinoNavigationBarBackButton(),
        middle: Text("Profile"),
      ),
      child: Center(child: Text("profile")),
    );
  }
}
