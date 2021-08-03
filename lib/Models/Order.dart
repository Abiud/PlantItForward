import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:plant_it_forward/Models/Product.dart';

class Order {
  String userId;
  List<Product> produce;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? comments;
  bool approved;

  Order(
      {required this.userId,
      required this.produce,
      this.createdAt,
      this.updatedAt,
      this.comments,
      this.approved = false});

  Order copyWith({
    String? userId,
    List<Product>? produce,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? comments,
  }) {
    return Order(
      userId: userId ?? this.userId,
      produce: produce ?? this.produce,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'produce': produce.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'comments': comments,
      'approved': approved,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      userId: map['userId'],
      produce:
          List<Product>.from(map['produce']?.map((x) => Product.fromMap(x))),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      comments: map['comments'],
      approved: map['approved'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Order(userId: $userId, produce: $produce, createdAt: $createdAt, updatedAt: $updatedAt, comments: $comments, approved $approved)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.userId == userId &&
        listEquals(other.produce, produce) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.approved == approved &&
        other.comments == comments;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        produce.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        approved.hashCode ^
        comments.hashCode;
  }
}
