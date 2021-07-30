import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/screens/home/Produce/product_view.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/utils.dart';

Widget buildProductCardHistory(
    BuildContext context, DocumentSnapshot document, String parentId) {
  final product = Product.fromSnapshot(document);

  return Container(
    child: Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      ProductView(product: product, parentId: parentId)));
        },
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 5,
              color: Colors.grey.shade600,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Last update on " +
                                dateF.format(product.updatedAt!.toDate()),
                            style: TextStyle(color: Colors.grey)),
                        verticalSpaceTiny,
                        Text(
                          product.name,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpaceTiny,
                        Row(
                          children: [
                            Text(product.price.toString()),
                            horizontalSpaceTiny,
                            Text(
                              product.measure!,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  horizontalSpaceSmall,
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
