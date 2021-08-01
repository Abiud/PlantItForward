import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/widgets/contact_card.dart';
import 'package:provider/provider.dart';

class AddChat extends StatelessWidget {
  const AddChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Start Conversation",
          ),
        ),
        body: StreamBuilder(
          stream: DatabaseService(uid: Provider.of<UserData>(context).id)
              .userCollection
              .snapshots()
              .map((QuerySnapshot list) => list.docs
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
                        if (snapshot.data![index].id ==
                            Provider.of<UserData>(context).id) {
                          return Container();
                        }
                        return buildContactCard(context, snapshot.data![index],
                            Provider.of<UserData>(context).id);
                      }),
                ],
              );
            } else {
              return Loading();
            }
          },
        ));
  }
}
