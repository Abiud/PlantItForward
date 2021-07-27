import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class AddAvailability extends StatefulWidget {
  AddAvailability({Key? key}) : super(key: key);

  @override
  _AddAvailabilityState createState() => _AddAvailabilityState();
}

class _AddAvailabilityState extends State<AddAvailability> {
  final ScrollController _scrollControllerOne = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  final TextEditingController searchField = TextEditingController();
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  List<Product> selectedProduce = [];
  List<Product> results = [];
  Timer? _debounce;
  bool loading = false;
  bool loadingResults = false;

  @override
  void dispose() {
    _debounce?.cancel();
    searchField.dispose();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length > 0) {
        setState(() {
          loadingResults = true;
        });
        AlgoliaQuerySnapshot algoliaResults = await _algoliaApp.instance
            .index("AppProduce")
            .query(query)
            .getObjects();
        setState(() {
          results = algoliaResults.hits
              .map((e) => Product(
                  name: e.data['name'],
                  documentId: e.data['objectID'],
                  measure: e.data['measure']))
              .toList();
          loadingResults = false;
        });
      } else {
        setState(() {
          results = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: primaryGreen,
          elevation: 2,
          label: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          icon: !loading
              ? Icon(
                  Icons.save,
                  color: Colors.white,
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
        ),
      ),
      appBar: AppBar(
        title: Text("Add Produce Availability"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  TextField(
                    controller: searchField,
                    onChanged: (val) {
                      _onSearchChanged(val);
                    },
                    decoration: InputDecoration(
                        contentPadding: fieldContentPadding,
                        enabledBorder: fieldEnabledBorder,
                        focusedBorder: fieldFocusedBorder,
                        errorBorder: fieldErrorBorder,
                        labelText: 'Search Produce',
                        hintText: "Type name of produce"),
                  ),
                  Positioned(
                      right: 5,
                      child: loadingResults
                          ? SpinKitCircle(
                              color: primaryGreen,
                            )
                          : IconButton(
                              onPressed: () {
                                _onSearchChanged("");
                                searchField.text = "";
                              },
                              icon: Icon(Icons.clear,
                                  color: Colors.grey.shade500)))
                ],
              ),
            ),
            verticalSpaceMedium,
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: results.isEmpty ? 0 : 50,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Scrollbar(
                  controller: _scrollControllerOne,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _scrollControllerOne,
                    scrollDirection: Axis.horizontal,
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, index) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            child: InkWell(
                              onTap: () {
                                if (isSelected(results[index].documentId)) {
                                  setState(() {
                                    selectedProduce.removeWhere((Product e) =>
                                        e.documentId ==
                                        results[index].documentId);
                                  });
                                } else
                                  setState(() {
                                    selectedProduce.add(results[index]);
                                  });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Text(
                                  results[index].name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          if (isSelected(results[index].documentId))
                            Positioned(
                                top: -5,
                                right: -5,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: primaryGreen,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            verticalSpaceSmall,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Scrollbar(
                  controller: _scrollControllerTwo,
                  isAlwaysShown: true,
                  child: ListView.builder(
                      controller: _scrollControllerTwo,
                      itemCount: selectedProduce.length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedProduce[index].name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  if (selectedProduce[index].quantity! > 0)
                                    setState(() {
                                      selectedProduce[index].quantity =
                                          selectedProduce[index].quantity! - 1;
                                    });
                                },
                              ),
                              horizontalSpaceTiny,
                              Text("${selectedProduce[index].quantity} ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "${selectedProduce[index].getMeasureUnits()}"),
                              horizontalSpaceTiny,
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedProduce[index].quantity =
                                        selectedProduce[index].quantity! + 1;
                                  });
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedProduce.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ))
                            ],
                          ),
                        ));
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isSelected(String id) {
    for (Product e in selectedProduce) {
      if (e.documentId == id) return true;
    }
    return false;
  }

  Future createAvailability() async {
    final collection = FirebaseFirestore.instance.collection("availability");

    // return await collection.add({
    //   ""
    // });
  }
}
