import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plant_it_forward/Models/Farm.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class EditFarm extends StatefulWidget {
  final Farm farm;
  EditFarm({Key? key, required this.farm}) : super(key: key);

  @override
  _EditFarmState createState() => _EditFarmState();
}

class _EditFarmState extends State<EditFarm> {
  final ScrollController _scrollControllerOne = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  final TextEditingController searchField = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  bool loading = false;
  Timer? _debounce;
  bool loadingResults = false;
  List<UserData> results = [];
  List<UserData> farmersToRemove = [];
  List<UserData> farmersToAdd = [];

  @override
  void dispose() {
    _debounce?.cancel();
    searchField.dispose();
    _scrollControllerOne.dispose();
    _scrollControllerTwo.dispose();
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
            .index("AppUsers")
            .query(query)
            .getObjects();
        setState(() {
          results = algoliaResults.hits
              .map((e) => UserData(
                  name: e.data['name'],
                  id: e.data['objectID'],
                  farmId: e.data['farmId'],
                  farmName: e.data['farmName']))
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
      appBar: AppBar(
        title: Text(widget.farm.name),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: FloatingActionButton.extended(
            backgroundColor: primaryGreen,
            elevation: 2,
            label: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
            icon: !loading
                ? Icon(
                    Icons.edit,
                    color: Colors.white,
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
            onPressed: () {
              if (!loading) {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    loading = true;
                  });
                  editFarm().then((val) async {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Successfully updated!"),
                        duration: Duration(
                          seconds: 2,
                        )));
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "We couldn't create the document, please try again later."),
                        duration: Duration(
                          seconds: 3,
                        )));
                  });
                }
              }
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: fieldContentPadding,
                          enabledBorder: fieldEnabledBorder,
                          focusedBorder: fieldFocusedBorder,
                          errorBorder: fieldErrorBorder,
                          labelText: 'Name',
                          hintText: "Name..."),
                      initialValue: widget.farm.name,
                      validator: (val) {
                        if (widget.farm.name.length > 0) {
                          return null;
                        }
                        return "Title cannot be empty";
                      },
                      onChanged: (val) {
                        widget.farm.name = val;
                      },
                    ),
                    verticalSpaceMedium,
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: fieldContentPadding,
                          enabledBorder: fieldEnabledBorder,
                          focusedBorder: fieldFocusedBorder,
                          errorBorder: fieldErrorBorder,
                          labelText: 'Information',
                          hintText: "Information..."),
                      initialValue: widget.farm.location,
                      onChanged: (val) {
                        widget.farm.location = val;
                      },
                    ),
                    verticalSpaceMedium,
                    Stack(
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
                              labelText: 'Add Users',
                              hintText: "Type name of User"),
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
                  ],
                ),
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
                          shape: isSelected(results[index].id)
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
                              if (isSelected(results[index].id)) {
                                toRemove(results[index]);
                              } else {
                                if (results[index].farmId != null &&
                                    results[index].farmId != widget.farm.id)
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return farmConfirmationDialog(
                                            context, results[index]);
                                      });
                                else
                                  toAdd(results[index]);
                              }
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
            if (widget.farm.farmers != null) verticalSpaceTiny,
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
                        itemCount: widget.farm.farmers!.length,
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
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return confirmationDialog(context,
                                            widget.farm.farmers![index]);
                                      });
                                },
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
                                children: [
                                  widget.farm.farmers![index].photoUrl != null
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(widget
                                              .farm.farmers![index].photoUrl!))
                                      : Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/PIF-Logo_3_5.webp"),
                                                  fit: BoxFit.cover)),
                                        ),
                                  horizontalSpaceMedium,
                                  Expanded(
                                    child: Text(
                                      widget.farm.farmers![index].name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
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

  bool isSelected(String id) {
    for (UserData e in widget.farm.farmers!) {
      if (e.id == id) return true;
    }
    return false;
  }

  Widget confirmationDialog(BuildContext context, UserData item) {
    return AlertDialog(
      title: Text("Remove User from Farm"),
      content: Text(
          "Do you want to continue? ${item.name} will lose all access to records regarding this farm."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              toRemove(item);
              Navigator.of(context).pop();
            },
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }

  Widget farmConfirmationDialog(BuildContext context, UserData item) {
    return AlertDialog(
      title: Text("User already has a Farm"),
      content: Text(
          "This user already belongs to farm ${item.farmName}. If you continue the user new farm will be ${widget.farm.name}."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              toAdd(item);
              Navigator.of(context).pop();
            },
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }

  void toAdd(UserData user) {
    setState(() {
      widget.farm.farmers!.add(user);
    });
    farmersToRemove.removeWhere((UserData item) => item.id == user.id);
    farmersToAdd.add(user);
  }

  void toRemove(UserData user) {
    setState(() {
      widget.farm.farmers!.removeWhere((UserData item) => item.id == user.id);
    });
    farmersToAdd.removeWhere((UserData item) => item.id == user.id);
    farmersToRemove.add(user);
  }

  Future editFarm() async {
    final db = FirebaseFirestore.instance;
    final farmDoc = db.collection('farms').doc(widget.farm.id);
    final userCollection = db.collection('users');
    WriteBatch batch = db.batch();

    if (farmersToRemove.isNotEmpty) {
      List<Map<String, dynamic>> usersMap = [];
      for (UserData user in farmersToRemove) {
        batch.update(
            userCollection.doc(user.id), {"farmId": null, "farmName": null});
        usersMap.add({"name": user.name, "id": user.id});
      }
      batch.update(farmDoc, {'farmers': FieldValue.arrayRemove(usersMap)});
    }
    if (farmersToAdd.isNotEmpty) {
      List<Map<String, dynamic>> usersMap = [];
      for (UserData user in farmersToAdd) {
        batch.update(userCollection.doc(user.id),
            {"farmId": widget.farm.id, "farmName": widget.farm.name});
        usersMap.add({"name": user.name, "id": user.id});
      }
      batch.update(farmDoc, {'farmers': FieldValue.arrayUnion(usersMap)});
    }

    batch.update(
        farmDoc, {"name": widget.farm.name, "location": widget.farm.location});

    return await batch.commit();
  }
}
