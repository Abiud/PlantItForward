import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/Prices/new_product_view.dart';
import 'package:plant_it_forward/screens/home/Produce/Prices/product_view.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/produce_search.dart';
import 'package:plant_it_forward/widgets/product_card.dart';

class Price extends StatefulWidget {
  Price({Key? key}) : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  ScrollController _scrollController = ScrollController();
  final StreamController<List<DocumentSnapshot>> _produceController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int produceLimit = 9;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  int totalFetched = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _getProduce(scroll: true);
      }
    });
  }

  @override
  void dispose() {
    _produceController.close();
    _scrollController.dispose();
    super.dispose();
  }

  Stream<List<DocumentSnapshot>> listenToProduceRealTime() {
    _getProduce();
    return _produceController.stream;
  }

  void _getProduce({bool scroll = false}) {
    if (!_hasMoreData) {
      return;
    }
    if (!scroll && totalFetched > 0) {
      return;
    }
    print("fetching.....");
    final CollectionReference _produceCollectionReference =
        FirebaseFirestore.instance.collection("products");
    var pagechatQuery = _produceCollectionReference.orderBy('name').limit(9);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    var currentRequestIndex = _allPagedResults.length;
    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var moreProduce = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = moreProduce;
          } else {
            _allPagedResults.add(moreProduce);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          totalFetched = allChats.length;

          if (!_produceController.isClosed) _produceController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }
          _hasMoreData = moreProduce.length == produceLimit;
        } else {
          if (mounted)
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
                      onPressed: () => showSearch(
                          context: context,
                          delegate: ItemSearch(
                              indexName: "AppProduce",
                              navFunction: (String id) => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          ProductView(produceId: id))))),
                      label: Text("Search"),
                      icon: Icon(Icons.search)),
                  horizontalSpaceSmall,
                  TextButton.icon(
                      style: TextButton.styleFrom(
                          primary: secondaryBlue,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          onSurface: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8)),
                      onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => NewProductView())),
                      label: Text("Add"),
                      icon: Icon(Icons.add)),
                ],
              ),
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: listenToProduceRealTime(),
              builder: (BuildContext context, produceSnapshot) {
                if (produceSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    produceSnapshot.connectionState == ConnectionState.none) {
                  return produceSnapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("No produce found."),
                        );
                } else {
                  if (produceSnapshot.hasData) {
                    final produceDocs = produceSnapshot.data!;
                    return Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: produceDocs.length,
                            itemBuilder: (BuildContext context, int index) =>
                                productCardDefault(context,
                                    Product.fromSnapshot(produceDocs[index]))),
                        if (produceDocs.length >= produceLimit && _hasMoreData)
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
