import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/product_view.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget buildProductCard(BuildContext context, DocumentSnapshot document) {
  final product = Product.fromSnapshot(document);

  return new Container(
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        splashColor: primaryGreen.withAlpha(30),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProductView(
                        product: product,
                      )));
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(fontSize: 20),
                        ),
                        horizontalSpaceSmall,
                        Text(
                          product.quantity!,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(product.price.toString()),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
