import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/extensions/CapExtension.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String userId;
  final String name;
  final String quantity;
  final String documentId;
  final Money price;

  Product(
      {@required this.userId,
      @required this.name,
      this.documentId,
      this.quantity,
      this.price});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name.inCaps,
      'quantity': quantity,
      'price': price.minorUnits.toInt(),
      'searchKeywords': createKeywords()
    };
  }

  static Product fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Product(
      name: map['name'],
      quantity: map['quantity'],
      userId: map['userId'],
      price: Money.fromInt(map['price'], Currency.create('USD', 2)),
      documentId: documentId,
    );
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
