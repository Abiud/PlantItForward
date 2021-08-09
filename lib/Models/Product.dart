import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/extensions/CapExtension.dart';

class Product {
  String? userId;
  String name;
  String? measure;
  String documentId;
  Money? price;
  dynamic createdAt;
  dynamic updatedAt;
  int? quantity;
  // bool? rushOrder;
  String? comments;

  Product(
      {required this.name,
      this.measure,
      this.price,
      this.userId,
      required this.documentId,
      this.createdAt,
      this.updatedAt,
      this.quantity = 0,
      this.comments});

  // formatting for upload to Firbase when creating the Product
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name.inCaps,
        'measure': measure,
        'price': price?.minorUnits.toInt(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'quantity': quantity,
        'comments': comments
      };

  // creating a Product object from a firebase snapshot
  Product.fromSnapshot(DocumentSnapshot snapshot)
      : name = (snapshot.data() as Map)['name'],
        measure = (snapshot.data() as Map)['measure'],
        price = Money.fromInt(
            (snapshot.data() as Map)['price'], Currency.create('USD', 2)),
        documentId = snapshot.id,
        createdAt = (snapshot.data() as Map)['createdAt'],
        updatedAt = (snapshot.data() as Map)['updatedAt'],
        comments = (snapshot.data() as Map)['comments'],
        quantity = (snapshot.data() as Map)['quantity'];

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'],
        measure: map['measure'],
        userId: map['userId'],
        price: map['price'] != null
            ? Money.fromInt(map['price'], Currency.create('USD', 2))
            : null,
        documentId: map['documentId'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        comments: map['comments'],
        quantity: map['quantity']);
  }

  static Product fromAlgolia(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      measure: map['measure'],
      price: map['price'] != null
          ? Money.fromInt(map['price'], Currency.create('USD', 2))
          : null,
      documentId: map['objectID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name.inCaps,
      'measure': measure,
      'price': price?.minorUnits.toInt(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'quantity': quantity,
      'documentId': documentId,
      'comments': comments
    }..removeWhere((key, value) => value == null);
  }

  String getMeasureUnits() {
    if (measure == 'per pound') return 'pounds';
    if (measure == 'per pint') return 'pints';
    if (measure == 'per foot') return 'feet';
    if (measure == 'per head') return 'heads';
    return 'bunches';
  }
}
