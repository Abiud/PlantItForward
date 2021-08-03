import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:plant_it_forward/Models/Product.dart';

class ProduceAvailability {
  String userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? comments;
  List<Product> produce;

  ProduceAvailability({
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.comments,
    required this.produce,
  });

  ProduceAvailability copyWith({
    String? id,
    String? userId,
    DateTime? postDateTime,
    DateTime? postDate,
    String? comments,
    List<Product>? produce,
  }) {
    return ProduceAvailability(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
      produce: produce ?? this.produce,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'comments': comments,
      'produce': produce.map((x) => x.toMap()).toList(),
    };
  }

  factory ProduceAvailability.fromMap(Map<String, dynamic> map) {
    return ProduceAvailability(
      userId: map['userId'],
      createdAt: (map['createdAt'])?.toDate(),
      updatedAt: (map['updatedAt'])?.toDate(),
      comments: map['comments'],
      produce:
          List<Product>.from(map['produce']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ProduceAvailable(userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt comments: $comments, produce: $produce)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProduceAvailability &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.comments == comments &&
        listEquals(other.produce, produce);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        comments.hashCode ^
        produce.hashCode;
  }
}
