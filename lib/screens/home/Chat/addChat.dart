import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/widgets/contact_card.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart'
    as ProviderWidget;

class AddChat extends StatelessWidget {
  const AddChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = ProviderWidget.Provider.of(context)!.auth;
    final DatabaseService db = ProviderWidget.Provider.of(context)!.db;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // leading: CupertinoNavigationBarBackButton(),
          heroTag: 'addChat', // a different string for each navigationBar
          transitionBetweenRoutes: false,
          middle: Text(
            "Add Chat",
          ),
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: db.userCollection.snapshots().map((QuerySnapshot list) =>
                list.docs
                    .map((DocumentSnapshot snap) => UserData.fromSnapshot(snap))
                    .toList()),
            builder:
                (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data![index].id == auth.currentUser.id) {
                            return Container();
                          }
                          return buildContactCard(context,
                              snapshot.data![index], auth.currentUser.id);
                        }),
                  ],
                );
              } else {
                return Loading();
              }
            },
          ),
        ));
  }
}
