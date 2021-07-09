import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/extensions/CapExtension.dart';

class Product {
  String? userId;
  String name;
  String? quantity;
  String documentId;
  Money? price;
  dynamic createdAt;
  dynamic updatedAt;

  Product(
      {required this.name,
      this.quantity,
      this.price,
      this.userId,
      required this.documentId,
      this.createdAt,
      required this.updatedAt});

  // formatting for upload to Firbase when creating the Product
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name.inCaps,
        'quantity': quantity,
        'price': price?.minorUnits.toInt(),
        'searchKeywords': createKeywords(),
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };

  // creating a Product object from a firebase snapshot
  Product.fromSnapshot(DocumentSnapshot snapshot)
      : name = (snapshot.data() as Map)['name'],
        quantity = (snapshot.data() as Map)['quantity'],
        price = Money.fromInt(
            (snapshot.data() as Map)['price'], Currency.create('USD', 2)),
        documentId = snapshot.id,
        createdAt = (snapshot.data() as Map)['createdAt'],
        updatedAt = (snapshot.data() as Map)['updatedAt'];

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'],
        quantity: map['quantity'],
        userId: map['userId'],
        price: Money.fromInt(map['price'], Currency.create('USD', 2)),
        documentId: map['documentId'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name.inCaps,
      'quantity': quantity,
      'price': price?.minorUnits.toInt(),
      'searchKeywords': createKeywords(),
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
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
