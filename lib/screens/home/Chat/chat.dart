import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Chat/addChat.dart';

class Chat extends StatelessWidget {
  const Chat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddChat()));
        },
        child: const Icon(Icons.add),
        backgroundColor: secondaryBlue,
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Chat",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 25, 12, 25),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
