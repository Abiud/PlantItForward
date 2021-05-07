import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/product_view.dart';

class NewProductView extends StatefulWidget {
  NewProductView({Key? key}) : super(key: key);

  @override
  _NewProductViewState createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Currency usdCurrency = Currency.create('USD', 2);
  //Product product =
  //new Product("", "per ounce", Money.fromInt(0, Currency.create('USD', 2)));

  @override
  Widget build(BuildContext context) {
    return Container();
    // String price = product.price.toString();
    // return CupertinoPageScaffold(
    //   navigationBar: CupertinoNavigationBar(
    //     heroTag: 'new_product', // a different string for each navigationBar
    //     transitionBetweenRoutes: false,
    //     middle: Text("Add Produce"),
    //   ),
    //   child: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Material(
    //         color: Colors.white,
    //         child: Form(
    //           key: _formKey,
    //           child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Column(
    //               children: [
    //                 TextFormField(
    //                   decoration: InputDecoration(
    //                       border: UnderlineInputBorder(),
    //                       labelText: 'Name',
    //                       hintText: "Lettuce"),
    //                   initialValue: product.name,
    //                   validator: (val) {
    //                     if (product.name.length > 0) {
    //                       return null;
    //                     }
    //                     return "Name cannot be empty";
    //                   },
    //                   onChanged: (val) {
    //                     product.name = val;
    //                   },
    //                 ),
    //                 SizedBox(
    //                   height: 16,
    //                 ),
    //                 DropdownButtonFormField(
    //                     decoration: InputDecoration(
    //                         border: UnderlineInputBorder(),
    //                         labelText: 'Quantity',
    //                         hintText: "Per pound/Per bunch"),
    //                     value: product.quantity,
    //                     onChanged: (val) {
    //                       product.quantity = val;
    //                     },
    //                     items: <String>['per ounce', 'per bunch']
    //                         .map<DropdownMenuItem<String>>((String e) {
    //                       return DropdownMenuItem<String>(
    //                         child: Text(e),
    //                         value: e,
    //                       );
    //                     }).toList()),
    //                 SizedBox(
    //                   height: 16,
    //                 ),
    //                 TextFormField(
    //                   decoration: InputDecoration(
    //                       border: UnderlineInputBorder(),
    //                       labelText: 'Price',
    //                       hintText: "\$2.50"),
    //                   initialValue: price,
    //                   validator: (val) {
    //                     try {
    //                       product.price = usdCurrency.parse(price);
    //                       return null;
    //                     } catch (e) {
    //                       return r'The value needs to be in the format "$0.0"';
    //                     }
    //                   },
    //                   onChanged: (val) {
    //                     price = val;
    //                   },
    //                 ),
    //                 SizedBox(
    //                   height: 16,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     CupertinoButton(
    //                         child: Text("Save"),
    //                         color: primaryGreen,
    //                         onPressed: () {
    //                           if (_formKey.currentState.validate()) {
    //                             createProduct(context).then((val) async {
    //                               var doc = await FirebaseFirestore.instance
    //                                   .collection("products")
    //                                   .doc(val.id)
    //                                   .get();
    //                               Product newProd = Product.fromSnapshot(doc);
    //                               Navigator.pushReplacement(
    //                                   context,
    //                                   CupertinoPageRoute(
    //                                       builder: (context) => ProductView(
    //                                             product: newProd,
    //                                           )));
    //                             });
    //                           }
    //                         }),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  // Future createProduct(context) async {
  //   final collection = FirebaseFirestore.instance.collection('products');

  //   return await collection.add(product.toJson());
  // }
}
