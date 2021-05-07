import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';

class ProductView extends StatefulWidget {
  final Product product;
  ProductView({Key? key, required this.product}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Currency usdCurrency = Currency.create('USD', 2);

  @override
  Widget build(BuildContext context) {
    return Container();
    // String price = widget.product.price.toString();
    // String quantityValue = widget.product.quantity;
    // return CupertinoPageScaffold(
    //   navigationBar: CupertinoNavigationBar(
    //     heroTag: 'single_product', // a different string for each navigationBar
    //     transitionBetweenRoutes: false,
    //     middle: Text(widget.product.name),
    //     trailing: Material(
    //       child: PopupMenuButton(
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(15.0))),
    //         padding: EdgeInsets.all(0),
    //         onSelected: (res) {
    //           if (res == 0) {
    //             deleteTrip(context);
    //             Navigator.pop(context);
    //           }
    //         },
    //         itemBuilder: (BuildContext context) {
    //           return [
    //             PopupMenuItem(
    //               value: 0,
    //               child: ListTile(
    //                 leading: Icon(
    //                   CupertinoIcons.delete,
    //                   size: 24,
    //                 ),
    //                 title: Text('Delete'),
    //               ),
    //             ),
    //           ];
    //         },
    //       ),
    //     ),
    //   ),
    //   // trailing: CupertinoButton(
    //   //   padding: EdgeInsets.zero,
    //   //   child: Icon(
    //   //     CupertinoIcons.ellipsis_vertical,
    //   //   ),
    //   //   onPressed: () {},
    //   // )),
    //   child: SafeArea(
    //       child: SingleChildScrollView(
    //           child: Material(
    //     color: Colors.white,
    //     child: Form(
    //         key: _formKey,
    //         child: Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Column(
    //             children: [
    //               DropdownButtonFormField(
    //                   decoration: InputDecoration(
    //                       border: UnderlineInputBorder(),
    //                       labelText: 'Quantity',
    //                       hintText: "Per pound/Per bunch"),
    //                   value: quantityValue,
    //                   onChanged: (val) {
    //                     widget.product.quantity = val;
    //                     quantityValue = val;
    //                   },
    //                   items: <String>['per ounce', 'per bunch']
    //                       .map<DropdownMenuItem<String>>((String e) {
    //                     return DropdownMenuItem<String>(
    //                       child: Text(e),
    //                       value: e,
    //                     );
    //                   }).toList()),
    //               SizedBox(
    //                 height: 16,
    //               ),
    //               TextFormField(
    //                 decoration: InputDecoration(
    //                     border: UnderlineInputBorder(),
    //                     labelText: 'Price',
    //                     hintText: "\$2.50"),
    //                 initialValue: price,
    //                 validator: (val) {
    //                   // if (val.startsWith(RegExp('\$' + '[0-9]+[.][0-9]+'))) {
    //                   try {
    //                     widget.product.price = usdCurrency.parse(price);
    //                     return null;
    //                   } catch (e) {
    //                     return r'The value needs to be in the format "$0.0"';
    //                   }
    //                 },
    //                 onChanged: (val) {
    //                   price = val;
    //                 },
    //               ),
    //               SizedBox(
    //                 height: 16,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   CupertinoButton(
    //                       child: Text("Save"),
    //                       color: primaryGreen,
    //                       onPressed: () {
    //                         if (_formKey.currentState.validate()) {
    //                           updateTrip(context);
    //                         }
    //                       }),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         )),
    //   ))),
    // );
  }

  // Future updateTrip(context) async {
  //   final doc = FirebaseFirestore.instance
  //       .collection('products')
  //       .doc(widget.product.documentId);

  //   return await doc.set(widget.product.toJson());
  // }

  // Future deleteTrip(context) async {
  //   final doc = FirebaseFirestore.instance
  //       .collection('products')
  //       .doc(widget.product.documentId);

  //   return await doc.delete();
  // }
}
