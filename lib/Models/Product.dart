// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/extensions/CapExtension.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String userId;
  String name;
  String quantity;
  String documentId;
  Money price;
  dynamic createdAt;
  dynamic updatedAt;

  Product(
      {this.userId = "",
      required this.name,
      this.documentId = "",
      required this.quantity,
      required this.price,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name.inCaps,
      'quantity': quantity,
      'price': price.minorUnits.toInt(),
      'searchKeywords': createKeywords(),
      'createdAt': createdAt,
      'updated_at': updatedAt
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }

  static Product fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
        name: map['name'],
        quantity: map['quantity'],
        userId: map['userId'],
        price: Money.fromInt(map['price'], Currency.create('USD', 2)),
        documentId: documentId,
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt']);
  }

  List createKeywords() {
    String lowName = name.toLowerCase();
    List subs = [];
    for (var i = 1; i <= name.length; i++) {
      subs.add(lowName.substring(0, i));
    }
    return subs;
  }
}
