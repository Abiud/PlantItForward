import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddChat extends StatelessWidget {
  const AddChat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // leading: CupertinoNavigationBarBackButton(),
        heroTag: 'addChat', // a different string for each navigationBar
        transitionBetweenRoutes: false,
        middle: Text(
          "Add Chat",
        ),
      ),
      child: Center(child: Text('Add chat')),
    );
  }
}
