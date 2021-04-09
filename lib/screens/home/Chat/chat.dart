import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Chat/addChat.dart';

class Chat extends StatelessWidget {
  const Chat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'chat', // a different string for each navigationBar
          transitionBetweenRoutes: false,
          trailing: CupertinoButton(
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddChat()));
              }),
          backgroundColor: Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.transparent)),
        ),
        child: Center(child: Text("chat")));

    // return Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => AddChat()));
    //     },
    //     child: const Icon(Icons.add),
    //     backgroundColor: secondaryBlue,
    //   ),
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text(
    //       "Chat",
    //       style: TextStyle(
    //           fontWeight: FontWeight.normal, fontSize: 18, color: Colors.black),
    //     ),
    //     backgroundColor: Colors.white,
    //     elevation: 0,
    //   ),
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.fromLTRB(12, 25, 12, 25),
    //       child: Column(
    //         children: [],
    //       ),
    //     ),
    //   ),
    // );
  }
}
