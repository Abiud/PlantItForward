import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? name;
  String id;
  String? email;
  String? role;
  String? photoUrl;

  UserData({this.name, required this.id, this.email, this.role, this.photoUrl});

  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        role = data['role'],
        photoUrl = data['photoUrl'];

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot.data() as Map)["id"],
        name = (snapshot.data() as Map)["name"],
        email = (snapshot.data() as Map)["email"],
        role = (snapshot.data() as Map)["role"],
        photoUrl = (snapshot.data() as Map)["photoUrl"];

  UserData copyWith(
      {String? name,
      String? id,
      String? email,
      String? role,
      String? photoUrl}) {
    return UserData(
        name: name ?? this.name,
        id: id ?? this.id,
        email: email ?? this.email,
        role: role ?? this.role,
        photoUrl: photoUrl ?? this.photoUrl);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'role': role,
      'photoUrl': photoUrl
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
        name: map['name'],
        id: map['id'],
        email: map['email'],
        role: map['role'],
        photoUrl: map['photoUrl']);
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(name: $name, id: $id, email: $email, role: $role, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.name == name &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        email.hashCode ^
        role.hashCode ^
        photoUrl.hashCode;
  }
}
