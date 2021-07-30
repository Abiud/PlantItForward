import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:plant_it_forward/Models/UserData.dart';

class Farm {
  String name;
  String id;
  String? location;
  List<UserData>? farmers;
  DocumentReference? reference;

  Farm(
      {required this.name,
      required this.id,
      this.location,
      this.farmers,
      this.reference});

  Farm copyWith(
      {String? name,
      String? id,
      String? location,
      List<UserData>? farmers,
      DocumentReference? reference}) {
    return Farm(
        name: name ?? this.name,
        id: id ?? this.id,
        location: location ?? this.location,
        farmers: farmers ?? this.farmers,
        reference: reference ?? this.reference);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'location': location,
      'farmers': farmers?.map((x) => x.toMap()).toList(),
    };
  }

  factory Farm.fromMap(Map<String, dynamic> map, String id,
      {DocumentReference? reference}) {
    return Farm(
        name: map['name'],
        id: id,
        location: map['location'],
        farmers: map['farmers'] != null
            ? List<UserData>.from(
                map['farmers']?.map((x) => UserData.fromMap(x)))
            : null,
        reference: reference);
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Farm(name: $name, id: $id, location: $location, farmers: $farmers, reference $reference)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Farm &&
        other.name == name &&
        other.id == id &&
        other.location == location &&
        listEquals(other.farmers, farmers) &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        location.hashCode ^
        farmers.hashCode ^
        reference.hashCode;
  }
}
