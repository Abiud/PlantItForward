import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Farm.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Admin/Farms/addFarm.dart';
import 'package:plant_it_forward/widgets/farm_card.dart';

class FarmsView extends StatefulWidget {
  FarmsView({Key? key}) : super(key: key);

  @override
  _FarmsViewState createState() => _FarmsViewState();
}

class _FarmsViewState extends State<FarmsView> {
  ScrollController _scrollController = ScrollController();
  final StreamController<List<DocumentSnapshot>> _farmsController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int farmLimit = 9;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _getFarms();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _farmsController.close();
    super.dispose();
  }

  Stream<List<DocumentSnapshot>> listenToFarmsRealTime() {
    _getFarms();
    return _farmsController.stream;
  }

  void _getFarms() {
    if (!_hasMoreData) {
      return;
    }

    final CollectionReference _farmCollectionReference =
        FirebaseFirestore.instance.collection("farms");
    var pagechatQuery = _farmCollectionReference.orderBy('name').limit(9);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    var currentRequestIndex = _allPagedResults.length;
    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var moreFarms = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = moreFarms;
          } else {
            _allPagedResults.add(moreFarms);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _farmsController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }
          _hasMoreData = moreFarms.length == farmLimit;
          if (!_hasMoreData) setState(() {});
        } else {
          setState(() {
            _hasMoreData = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      style: TextButton.styleFrom(
                          primary: secondaryBlue,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          onSurface: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8)),
                      onPressed: () => Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => AddFarm())),
                      label: Text("Add"),
                      icon: Icon(Icons.add)),
                ],
              ),
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: listenToFarmsRealTime(),
              builder: (BuildContext context, farmSnapshot) {
                if (farmSnapshot.connectionState == ConnectionState.waiting ||
                    farmSnapshot.connectionState == ConnectionState.none) {
                  return farmSnapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("No farms registered."),
                        );
                } else {
                  if (farmSnapshot.hasData) {
                    final farmDocs = farmSnapshot.data!;
                    return Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: farmDocs.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildFarmCard(
                                    context,
                                    Farm.fromMap(farmDocs[index].data()
                                        as Map<String, dynamic>))),
                        if (farmDocs.length >= farmLimit && _hasMoreData)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (!_hasMoreData)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "End of list.",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          )
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              },
            ),
          ]),
    );
  }
}
