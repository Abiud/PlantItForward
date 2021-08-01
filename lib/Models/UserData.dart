import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String name;
  String id;
  String? email;
  String? role;
  String? photoUrl;
  String? farmId;
  String? farmName;

  UserData(
      {required this.name,
      required this.id,
      this.email,
      this.role,
      this.photoUrl,
      this.farmId,
      this.farmName});

  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        role = data['role'],
        photoUrl = data['photoUrl'],
        farmId = data['farmId'],
        farmName = data['farmName'];

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot.data() as Map)["id"],
        name = (snapshot.data() as Map)["name"],
        email = (snapshot.data() as Map)["email"],
        role = (snapshot.data() as Map)["role"],
        photoUrl = (snapshot.data() as Map)["photoUrl"],
        farmId = (snapshot.data() as Map)["farmId"],
        farmName = (snapshot.data() as Map)["farmName"];

  UserData copyWith(
      {String? name,
      String? id,
      String? email,
      String? role,
      String? photoUrl,
      String? farmId,
      String? farmName}) {
    return UserData(
        name: name ?? this.name,
        id: id ?? this.id,
        email: email ?? this.email,
        role: role ?? this.role,
        photoUrl: photoUrl ?? this.photoUrl,
        farmId: photoUrl ?? this.farmId,
        farmName: photoUrl ?? this.farmName);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'farmId': farmId,
      'farmName': farmName
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
        name: map['name'],
        id: map['id'],
        email: map['email'],
        role: map['role'],
        photoUrl: map['photoUrl'],
        farmId: map['farmId'],
        farmName: map['farmName']);
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(name: $name, id: $id, email: $email, role: $role, photoUrl: $photoUrl, farmId: $farmId, farmName: $farmName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.name == name &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.photoUrl == photoUrl &&
        other.farmId == farmId &&
        other.farmName == farmName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        email.hashCode ^
        role.hashCode ^
        photoUrl.hashCode ^
        farmId.hashCode ^
        farmName.hashCode;
  }

  bool isAdmin() {
    return role == "admin";
  }

  bool isFarmer() {
    return role == "farmer";
  }

  bool isPartOfProgram() {
    return isFarmer() || isAdmin();
  }

  bool isVolunteer() {
    return role == "volunteer";
  }
}
