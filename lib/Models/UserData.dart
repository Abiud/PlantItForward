import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? name;
  String id;
  String? email;
  String? role;

  UserData({required this.id, this.name, this.email, this.role});

  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        role = data['role'];

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot.data() as Map)["id"],
        name = (snapshot.data() as Map)["name"],
        email = (snapshot.data() as Map)["email"],
        role = (snapshot.data() as Map)["role"];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
