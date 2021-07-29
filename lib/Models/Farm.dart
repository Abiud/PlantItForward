import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:plant_it_forward/Models/UserData.dart';

class Farm {
  String name;
  String id;
  String? location;
  List<UserData>? farmers;

  Farm({
    required this.name,
    required this.id,
    this.location,
    this.farmers,
  });

  Farm copyWith({
    String? name,
    String? id,
    String? location,
    List<UserData>? farmers,
  }) {
    return Farm(
      name: name ?? this.name,
      id: id ?? this.id,
      location: location ?? this.location,
      farmers: farmers ?? this.farmers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'location': location,
      'farmers': farmers?.map((x) => x.toMap()).toList(),
    };
  }

  factory Farm.fromMap(Map<String, dynamic> map) {
    return Farm(
      name: map['name'],
      id: map['id'],
      location: map['location'],
      farmers:
          List<UserData>.from(map['farmers']?.map((x) => UserData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Farm.fromJson(String source) => Farm.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Farm(name: $name, id: $id, location: $location, farmers: $farmers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Farm &&
        other.name == name &&
        other.id == id &&
        other.location == location &&
        listEquals(other.farmers, farmers);
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ location.hashCode ^ farmers.hashCode;
  }
}
