import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plant_it_forward/Models/ProduceAvailability.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/utils.dart';
import 'package:provider/provider.dart';

class EditAvailability extends StatefulWidget {
  final ProduceAvailability availability;
  final DateTime date;
  EditAvailability({Key? key, required this.availability, required this.date})
      : super(key: key);

  @override
  _EditAvailabilityState createState() => _EditAvailabilityState();
}

class _EditAvailabilityState extends State<EditAvailability> {
  final ScrollController _scrollControllerOne = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  List<TextEditingController> _controllers = [];
  final TextEditingController searchField = TextEditingController();
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  List<Product> results = [];
  Timer? _debounce;
  bool loading = false;
  bool loadingResults = false;

  @override
  void initState() {
    for (Product prod in widget.availability.produce) {
      _controllers
          .add(new TextEditingController(text: prod.quantity.toString()));
    }
    super.initState();
  }

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Availability Week ${weekNumber(widget.date)}"),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                loading = true;
              });
              editAvailability().then((value) {
                setState(() {
                  loading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Successfully updated!"),
                    duration: Duration(
                      seconds: 2,
                    )));
              });
            },
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
        body: Padding(
          padding: const EdgeInsets.only(top: 24),
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
              verticalSpaceSmall,
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                height: results.isEmpty ? 0 : 60,
                width: double.infinity,
                child: Scrollbar(
                  controller: _scrollControllerOne,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    controller: _scrollControllerOne,
                    scrollDirection: Axis.horizontal,
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, index) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            shape: isSelected(results[index].documentId)
                                ? new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: primaryGreen, width: 2.0),
                                    borderRadius: BorderRadius.circular(4.0))
                                : new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(4.0)),
                            child: InkWell(
                              onTap: () {
                                if (isSelected(results[index].documentId)) {
                                  toRemove(results[index]);
                                } else
                                  toAdd(results[index]);
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
                        ],
                      );
                    },
                  ),
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: Scrollbar(
                  controller: _scrollControllerTwo,
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollControllerTwo,
                          itemCount: widget.availability.produce.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (BuildContext context, index) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => toRemove(
                                      widget.availability.produce[index]),
                                ),
                                IconSlideAction(
                                  caption: 'Close',
                                  color: Colors.grey.shade600,
                                  icon: Icons.close,
                                  onTap: () {},
                                ),
                              ],
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.availability.produce[index].name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    horizontalSpaceTiny,
                                    Container(
                                      width: 28,
                                      child: TextField(
                                        onTap: () =>
                                            _controllers[index].selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        _controllers[index]
                                                            .value
                                                            .text
                                                            .length),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        controller: _controllers[index],
                                        onChanged: (String val) {
                                          setState(() {
                                            widget.availability.produce[index]
                                                .quantity = int.parse(val);
                                          });
                                        },
                                      ),
                                    ),
                                    horizontalSpaceTiny,
                                    Container(
                                      width: 64,
                                      child: Text(
                                          "${widget.availability.produce[index].getMeasureUnits()}"),
                                    ),
                                  ],
                                ),
                              )),
                            );
                          }),
                      Container(
                        height: 70,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isSelected(String id) {
    for (Product e in widget.availability.produce) {
      if (e.documentId == id) return true;
    }
    return false;
  }

  void toAdd(Product prod) {
    _controllers.add(new TextEditingController(text: prod.quantity.toString()));
    setState(() {
      widget.availability.produce.add(prod);
    });
  }

  void toRemove(Product prod) {
    int idx = widget.availability.produce
        .indexWhere((Product item) => item.documentId == prod.documentId);
    _controllers.removeAt(idx);
    setState(() {
      widget.availability.produce.removeAt(idx);
    });
  }

  Future editAvailability() async {
    final db = FirebaseFirestore.instance;
    String farmId = Provider.of<UserData>(context, listen: false).farmId!;
    final reportDoc = db
        .collection("weeklyReports")
        .doc("${widget.date.millisecondsSinceEpoch.toString()}$farmId");
    WriteBatch batch = db.batch();
    List<Map<String, dynamic>> prods = [];
    for (Product prod in widget.availability.produce) {
      prods.add(prod.toMap());
    }

    batch.update(reportDoc,
        {"availability.produce": prods, "updatedAt": DateTime.now()});

    return await batch.commit();
  }
}
