import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_it_forward/Models/Convo.dart';
import 'package:plant_it_forward/Models/UserData.dart';

class ChatService {
  Stream<List<Convo>> streamConversations(String uid) {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs.map((DocumentSnapshot doc) {
              return Convo.fromSnapshot(doc);
            }).toList());
  }

  static Stream<List<UserData>> getUsersByList(List<String> userIds) {
    final List<Stream<UserData>> streams = [];
    for (String id in userIds) {
      streams.add(FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .snapshots()
          .map((DocumentSnapshot snap) => UserData.fromSnapshot(snap)));
    }
    return StreamZip<UserData>(streams).asBroadcastStream();
  }
}
