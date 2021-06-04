import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'settings', // a different string for each navigationBar
        transitionBetweenRoutes: false,
        leading: CupertinoNavigationBarBackButton(),
        middle: Text("Settings"),
      ),
      child: Center(child: Text("settings")),
    );
  }
}
