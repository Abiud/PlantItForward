import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';

class Product {
  String name;
  String quantity;
  String documentId;
  Money price;

  Product(this.name, this.quantity, this.price);

  // formatting for upload to Firbase when creating the Product
  Map<String, dynamic> toJson() =>
      {'name': name, 'quantity': quantity, 'price': price.minorUnits.toInt()};

  // creating a Product object from a firebase snapshot
  Product.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot.data()['name'],
        quantity = snapshot.data()['quantity'],
        price =
            Money.fromInt(snapshot.data()['price'], Currency.create('USD', 2)),
        documentId = snapshot.id;
}
