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
import 'package:plant_it_forward/screens/home/Admin/Farms/editFarm.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class AddFarm extends StatefulWidget {
  AddFarm({Key? key}) : super(key: key);

  @override
  _AddFarmState createState() => _AddFarmState();
}

class _AddFarmState extends State<AddFarm> {
  final ScrollController _scrollControllerOne = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  final TextEditingController searchField = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String name = "";
  String? location = "";
  List<UserData>? farmers;
  Timer? _debounce;
  bool loadingResults = false;
  List<UserData> selectedUsers = [];
  List<UserData> results = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding Farm"),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: FloatingActionButton.extended(
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
            onPressed: () {
              if (!loading) {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    loading = true;
                  });
                  addFarm().then((val) async {
                    Farm? tempFarm;
                    await FirebaseFirestore.instance
                        .collection("farms")
                        .doc(val)
                        .get()
                        .then((value) =>
                            tempFarm = Farm.fromMap(value.data()!, value.id));

                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Successfully created!"),
                        duration: Duration(
                          seconds: 2,
                        )));
                    if (tempFarm != null)
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditFarm(farm: tempFarm!)));
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
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Name',
                            hintText: "Name..."),
                        initialValue: name,
                        validator: (val) {
                          if (name.length > 0) {
                            return null;
                          }
                          return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          name = val;
                        },
                      ),
                    ),
                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Information',
                            hintText: "Information..."),
                        initialValue: location,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (val) {
                          return null;
                        },
                        onChanged: (val) {
                          location = val;
                        },
                      ),
                    ),
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
                                labelText: 'Search Users',
                                hintText: "Type name of User"),
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
                  ],
                )),
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
                                setState(() {
                                  selectedUsers.removeWhere((UserData e) =>
                                      e.id == results[index].id);
                                });
                              } else {
                                if (results[index].farmId != null)
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return confirmationDialog(
                                            context, results[index]);
                                      });
                                else
                                  setState(() {
                                    selectedUsers.add(results[index]);
                                  });
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
            verticalSpaceTiny,
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
                        itemCount: selectedUsers.length,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (BuildContext context, index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                closeOnTap: false,
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () => setState(() {
                                  selectedUsers.removeAt(index);
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
                                children: [
                                  selectedUsers[index].photoUrl != null
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              selectedUsers[index].photoUrl!))
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
                                      selectedUsers[index].name,
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

  bool isSelected(String id) {
    for (UserData e in selectedUsers) {
      if (e.id == id) return true;
    }
    return false;
  }

  Widget confirmationDialog(BuildContext context, UserData item) {
    return AlertDialog(
      title: Text("User already has a Farm"),
      content: Text(
          "This user already belongs to farm ${item.farmName}. If you continue the user new farm will be $name."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              setState(() {
                selectedUsers.add(item);
              });
              Navigator.of(context).pop();
            },
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }

  Future<String?> addFarm() async {
    final db = FirebaseFirestore.instance;
    final farmCollection = db.collection('farms');
    WriteBatch batch = db.batch();

    String? newFarmId;
    List<Map<String, dynamic>> usersMap = [];
    for (UserData user in selectedUsers) {
      usersMap.add({"name": user.name, "id": user.id});
    }
    await farmCollection
        .add({"name": name, "location": location, "farmers": usersMap}).then(
            (value) {
      newFarmId = value.id;
      for (UserData user in selectedUsers) {
        batch.update(db.collection("users").doc(user.id),
            {"farmId": value.id, "farmName": name});
      }
    });
    await batch.commit();
    if (newFarmId == null) return Future.error("Farm couldn't be created");
    return Future.value(newFarmId);
  }
}
