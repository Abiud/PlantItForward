import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';

class AddFarm extends StatefulWidget {
  AddFarm({Key? key}) : super(key: key);

  @override
  _AddFarmState createState() => _AddFarmState();
}

class _AddFarmState extends State<AddFarm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "";
  String? location = "";
  List<UserData>? farmers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding Farm"),
      ),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
