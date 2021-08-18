import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/screens/home/Produce/Prices/product_view.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

Widget productCardDefault(BuildContext context, Product product) {
  return Container(
    height: 90,
    child: Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProductView(
                        product: product,
                      )));
        },
        child: Stack(children: [
          Container(
            height: double.infinity,
            width: 5,
            color: secondaryBlue,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            style: TextStyle(color: Colors.grey, fontSize: 14),
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
        ]),
      ),
    ),
  );
}

Widget productCardWithOptions(BuildContext context, Product product) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return confirmationDialog(context, product);
            }),
      ),
      IconSlideAction(
        caption: 'Close',
        color: Colors.grey.shade600,
        icon: Icons.close,
        onTap: () {},
      ),
    ],
    child: Container(
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ProductView(
                          product: product,
                        )));
          },
          child: Stack(children: [
            Container(
              height: 70,
              width: 5,
              color: secondaryBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
          ]),
        ),
      ),
    ),
  );
}

Widget confirmationDialog(BuildContext context, Product item) {
  return AlertDialog(
    title: Text("Do you want to delete the selected produce?"),
    content: Text("The selected produce will be permanently deleted."),
    actions: [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
      TextButton(
          onPressed: () {
            deleteTrip(item).whenComplete(() => Navigator.of(context).pop());
          },
          child: Text(
            "Continue",
            style: TextStyle(color: Colors.redAccent),
          ))
    ],
  );
}

Future deleteTrip(Product item) async {
  return await FirebaseFirestore.instance
      .collection("products")
      .doc(item.documentId)
      .delete();
}
