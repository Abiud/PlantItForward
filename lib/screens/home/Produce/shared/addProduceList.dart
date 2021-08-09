import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:provider/provider.dart';

class AddProduceList extends StatefulWidget {
  final WeeklyReport? report;
  final DateTime date;
  final String type;
  AddProduceList(
      {Key? key, this.report, required this.date, required this.type})
      : super(key: key);

  @override
  _AddProduceListState createState() => _AddProduceListState();
}

class _AddProduceListState extends State<AddProduceList> {
  final ScrollController _scrollControllerOne = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  List<TextEditingController> _controllers = [];
  final TextEditingController searchField = TextEditingController();
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  List<Product> selectedProduce = [];
  List<Product> results = [];
  Timer? _debounce;
  bool loading = false;
  bool loadingResults = false;
  bool hiddeButton = false;

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
              .map((e) => Product.fromAlgolia(e.data))
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                loading = true;
              });
              createRecord().then((value) {
                setState(() {
                  loading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Successfully created!"),
                    duration: Duration(
                      seconds: 2,
                    )));
                Navigator.pop(context);
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
        appBar: AppBar(
          title: getTitle(),
        ),
        body: Column(
          children: [
            verticalSpaceMedium,
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
                  if (searchField.text.isNotEmpty)
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
                                setState(() {
                                  int idx = selectedProduce.indexWhere(
                                      (Product e) =>
                                          e.documentId ==
                                          results[index].documentId);
                                  selectedProduce.removeAt(idx);
                                  _controllers.removeAt(idx);
                                });
                              } else
                                setState(() {
                                  _controllers.add(
                                      new TextEditingController(text: "0"));
                                  selectedProduce.add(results[index]);
                                });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                results[index].name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
            if (widget.type == "order") ...[
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: hiddeButton
                    ? Container()
                    : TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: secondaryBlue,
                            elevation: 1,
                            backgroundColor: Colors.white,
                            onSurface: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12)),
                        onPressed: () {
                          setState(() {
                            selectedProduce =
                                widget.report!.availability!.produce;
                            for (Product item in selectedProduce) {
                              _controllers.add(new TextEditingController(
                                  text: item.quantity.toString()));
                            }
                            hiddeButton = true;
                          });
                        },
                        icon: Icon(Icons.paste),
                        label: Text(
                            "Paste produce list from availability report")),
              ),
              verticalSpaceSmall
            ] else if (widget.type == "harvest" &&
                widget.report!.order != null) ...[
              AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: hiddeButton
                      ? Container()
                      : TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: secondaryBlue,
                              elevation: 1,
                              backgroundColor: Colors.white,
                              onSurface: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12)),
                          onPressed: () {
                            setState(() {
                              selectedProduce = widget.report!.order!.produce;
                              for (Product item in selectedProduce) {
                                _controllers.add(new TextEditingController(
                                    text: item.quantity.toString()));
                              }
                              hiddeButton = true;
                            });
                          },
                          icon: Icon(Icons.paste),
                          label: Text("Paste produce list from order"),
                        )),
              verticalSpaceSmall
            ],
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
                        itemCount: selectedProduce.length,
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
                                onTap: () => setState(() {
                                  _controllers.removeAt(index);
                                  selectedProduce.removeAt(index);
                                }),
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
                                      selectedProduce[index].name,
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
                                      onTap: () => _controllers[index]
                                              .selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset: _controllers[index]
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
                                          selectedProduce[index].quantity =
                                              int.parse(val);
                                        });
                                      },
                                    ),
                                  ),
                                  horizontalSpaceTiny,
                                  Container(
                                    width: 64,
                                    child: Text(
                                        "${selectedProduce[index].getMeasureUnits()}"),
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
    );
  }

  Widget? getTitle() {
    if (widget.type == "availability")
      return Text("Add Produce Availability");
    else if (widget.type == "harvest")
      return Text("Add Harvest Record");
    else if (widget.type == "order") return Text("Add Order");
  }

  bool isSelected(String id) {
    for (Product e in selectedProduce) {
      if (e.documentId == id) return true;
    }
    return false;
  }

  Future createRecord() async {
    if (widget.type == "availability")
      return await createAvailability();
    else if (widget.type == "harvest") return await createHarvest();
    return await createOrder();
  }

  Future createHarvest() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("weeklyReports");
    DocumentReference doc;
    late String farmId;
    if (widget.report != null)
      farmId = widget.report!.farmId;
    else
      farmId = Provider.of<UserData>(context, listen: false).farmId!;
    DateTime date = widget.date;
    doc = collection.doc("${date.millisecondsSinceEpoch.toString()}$farmId");
    List list = [];
    for (Product prod in selectedProduce) {
      list.add(prod.toMap());
    }
    return doc.set({
      "updatedAt": DateTime.now(),
      "harvest": {
        "userId": Provider.of<UserData>(context, listen: false).id,
        "createdAt": DateTime.now(),
        "produce": list
      }
    }, SetOptions(merge: true));
  }

  Future createOrder() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("weeklyReports");
    DocumentReference doc;
    String farmId = widget.report!.farmId;
    DateTime date = widget.date;
    doc = collection.doc("${date.millisecondsSinceEpoch.toString()}$farmId");
    List list = [];
    for (Product prod in selectedProduce) {
      list.add(prod.toMap());
    }
    return doc.set({
      "updatedAt": DateTime.now(),
      "order": {
        "userId": Provider.of<UserData>(context, listen: false).id,
        "createdAt": DateTime.now(),
        "produce": list
      }
    }, SetOptions(merge: true));
  }

  Future createAvailability() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("weeklyReports");

    DocumentReference doc;
    String farmId = Provider.of<UserData>(context, listen: false).farmId!;
    DateTime date = widget.date;

    doc = collection.doc("${date.millisecondsSinceEpoch.toString()}$farmId");
    List list = [];
    for (Product prod in selectedProduce) {
      list.add(prod.toMap());
    }
    return doc.set({
      "id": date.millisecondsSinceEpoch.toString(),
      "farmId": farmId,
      "farmName": Provider.of<UserData>(context, listen: false).farmName,
      "date": date,
      "createdAt": DateTime.now(),
      "availability": {
        "userId": Provider.of<UserData>(context, listen: false).id,
        "createdAt": DateTime.now(),
        "produce": list
      }
    }, SetOptions(merge: true));
  }
}
