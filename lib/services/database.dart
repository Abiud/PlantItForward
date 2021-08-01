import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_it_forward/Models/UserData.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  // Collection reference
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection("items");

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection("messages");

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserData> get profile {
    return _userCollection.doc(uid).snapshots().map(_profileFromSnapshot);
  }

  UserData _profileFromSnapshot(DocumentSnapshot snapshot) {
    return UserData.fromSnapshot(snapshot);
  }

  Future updateUserData(String sugars, String name, int strength) async {
    return await itemCollection
        .doc(uid)
        .set({'sugars': sugars, "name": name, "strength": strength});
  }

  Stream<QuerySnapshot> get items {
    return itemCollection.snapshots();
  }

  Stream<List<UserData>> streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot snap) =>
                UserData.fromData(snap.data() as Map<String, dynamic>))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }
}
