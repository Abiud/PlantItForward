import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/widgets/user_card.dart';

class UsersView extends StatefulWidget {
  UsersView({Key? key}) : super(key: key);

  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  ScrollController _scrollController = ScrollController();
  final StreamController<List<DocumentSnapshot>> _userController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int userLimit = 9;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _getUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _userController.close();
    super.dispose();
  }

  Stream<List<DocumentSnapshot>> listenToUsersRealTime() {
    _getUsers();
    return _userController.stream;
  }

  void _getUsers() {
    if (!_hasMoreData) {
      return;
    }

    print("fetching...");

    final CollectionReference _userCollectionReference =
        FirebaseFirestore.instance.collection("users");
    var pagechatQuery = _userCollectionReference.orderBy('name').limit(9);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    var currentRequestIndex = _allPagedResults.length;
    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var moreUsers = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = moreUsers;
          } else {
            _allPagedResults.add(moreUsers);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _userController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }
          _hasMoreData = moreUsers.length == userLimit;
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
                      onPressed: () {},
                      // onPressed: () => showSearch(
                      //     context: context, delegate: ProduceSearch()),
                      label: Text("Search"),
                      icon: Icon(Icons.search)),
                ],
              ),
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: listenToUsersRealTime(),
              builder: (BuildContext context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting ||
                    userSnapshot.connectionState == ConnectionState.none) {
                  return userSnapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("No users registered."),
                        );
                } else {
                  if (userSnapshot.hasData) {
                    final userDocs = userSnapshot.data!;
                    return Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: userDocs.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildUserCard(
                                    context,
                                    UserData.fromMap(userDocs[index].data()
                                        as Map<String, dynamic>))),
                        if (userDocs.length >= userLimit && _hasMoreData)
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
