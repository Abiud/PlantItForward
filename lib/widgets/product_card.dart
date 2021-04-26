import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';

Widget buildProductCard(BuildContext context, DocumentSnapshot document) {
  //final product = Product.fromSnapshot(document);

  return new Container(
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        splashColor: primaryGreen.withAlpha(30),
        onTap: () {
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => ProductView(
          //               product: product,
          //             )));
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      // product.name,
                      "hi",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      // product.quantity,
                      "hi",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Spacer(),
                    // Column(
                    //   children: [Text(product.price.toString())],
                    // ),
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
