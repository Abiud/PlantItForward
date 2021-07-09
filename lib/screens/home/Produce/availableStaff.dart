import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/ProduceAvailable.dart';
import 'package:plant_it_forward/screens/home/Produce/new_product_view.dart';

class AvailableStaff extends StatefulWidget {
  const AvailableStaff({Key? key}) : super(key: key);

  @override
  _AvailableStaffState createState() => _AvailableStaffState();
}

class _AvailableStaffState extends State<AvailableStaff> {
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  bool loading = true;

  Future<void> getFarmerAvailableProduce() async {
    setState(() {
      loading = true;
    });
    // final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _allResults = data.docs;
      _resultsList =
          _allResults.map((e) => ProduceAvailable.fromMap(e)).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => NewProductView()));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
            child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) => Card(
                      elevation: 2,
                      child: Column(
                        children: [],
                      ),
                    )),
          )
        ]),
        onRefresh: getFarmerAvailableProduce,
      ),
    );
  }
}
