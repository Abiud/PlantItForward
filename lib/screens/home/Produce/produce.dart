import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Produce/available.dart';
import 'package:plant_it_forward/screens/home/Produce/price.dart';

class Produce extends StatefulWidget {
  const Produce({Key? key}) : super(key: key);

  @override
  _ProduceState createState() => _ProduceState();
}

class _ProduceState extends State<Produce> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: "Orders",
                    ),
                    Tab(
                      text: "Available",
                    ),
                    Tab(
                      text: "Prices",
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("orders"),
              ),
              Available(),
              Price()
            ],
          ),
        ));
  }
}
