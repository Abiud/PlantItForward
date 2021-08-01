import 'package:cloud_firestore/cloud_firestore.dart';

class Convo {
  Map<String, dynamic> lastMessage;
  List<dynamic> users;

  Convo({required this.lastMessage, required this.users});

  // formatting for upload to Firbase when creating the Product
  Map<String, dynamic> toJson() => {'lastMessage': lastMessage, 'users': users};

  // creating a Product object from a firebase snapshot
  Convo.fromSnapshot(DocumentSnapshot snapshot)
      : lastMessage = (snapshot.data() as Map)['lastMessage'],
        users = (snapshot.data() as Map)['users'];

  List<dynamic> get userIds {
    return users;
  }
}
