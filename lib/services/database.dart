import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  // Collection reference
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection("items");

  Future updateUserData(String sugars, String name, int strength) async {
    return await itemCollection
        .doc(uid)
        .set({'sugars': sugars, "name": name, "strength": strength});
  }

  Stream<QuerySnapshot> get items {
    return itemCollection.snapshots();
  }
}
