import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/screens/home/Produce/product_history.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:another_flushbar/flushbar.dart';

class ProductView extends StatefulWidget {
  final Product product;
  ProductView({Key? key, required this.product}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Currency usdCurrency = Currency.create('USD', 2);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    String price = widget.product.price.toString();
    String? quantityValue = widget.product.quantity;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'single_product', // a different string for each navigationBar
        transitionBetweenRoutes: false,
        middle: Text(widget.product.name),
        trailing: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            elevation: 2,
            padding: EdgeInsets.all(0),
            onSelected: (res) {
              if (res == 0) {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => ProductHistoryView(
                        productId: widget.product.documentId));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ProductHistoryView(
                //             productId: widget.product.documentId)));
              } else if (res == 1) {
                deleteTrip(context);
                Navigator.pop(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<Object>>[
                PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      size: 24,
                    ),
                    title: Text('history'),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.delete,
                      size: 24,
                    ),
                    title: Text('Delete'),
                  ),
                ),
              ];
            },
          ),
        ),
      ),
      child: SafeArea(
          child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          child: !loading
              ? Icon(Icons.edit)
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
          onPressed: () {
            if (!loading) {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                updateTrip(context).then((_) async {
                  setState(() {
                    loading = false;
                  });
                  await Flushbar(
                    title: 'Item updated!',
                    message: widget.product.name + ' updated succefully',
                    duration: Duration(seconds: 1),
                  ).show(context);
                });
              }
            }
          },
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Name',
                            hintText: "Lettuce"),
                        initialValue: widget.product.name,
                        validator: (val) {
                          if (widget.product.name.length > 0) {
                            return null;
                          }
                          return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          widget.product.name = val.toString();
                        },
                      ),
                      verticalSpaceMedium,
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: fieldContentPadding,
                              enabledBorder: fieldEnabledBorder,
                              focusedBorder: fieldFocusedBorder,
                              errorBorder: fieldErrorBorder,
                              labelText: 'Quantity',
                              hintText: "Per pound/Per bunch"),
                          value: quantityValue,
                          onChanged: (val) {
                            widget.product.quantity = val.toString();
                            quantityValue = val.toString();
                          },
                          items: <String>['per ounce', 'per bunch']
                              .map<DropdownMenuItem<String>>((String e) {
                            return DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            );
                          }).toList()),
                      verticalSpaceMedium,
                      TextFormField(
                        inputFormatters: [
                          CurrencyTextInputFormatter(symbol: '\$')
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Price',
                            hintText: "\$2.50"),
                        initialValue: price,
                        validator: (val) {
                          // if (val.startsWith(RegExp('$' + '[0-9]+[.][0-9]+'))) {
                          try {
                            widget.product.price = usdCurrency.parse(price);
                            return null;
                          } catch (e) {
                            return r'The value needs to be in the format ".0"';
                          }
                        },
                        onChanged: (val) {
                          price = val;
                        },
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Farmer price (80/20)",
                              style: TextStyle(color: Colors.grey.shade800)),
                          verticalSpaceTiny,
                          Text(getFarmerPrice().toString())
                        ],
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Farmer price (75/25) with adjustments",
                              style: TextStyle(color: Colors.grey.shade800)),
                          verticalSpaceTiny,
                          Text("??")
                        ],
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Farmer price 2 - Lost adjustment (All)",
                              style: TextStyle(color: Colors.grey.shade800)),
                          verticalSpaceTiny,
                          Text("??")
                        ],
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Farmer price 3 - Discounts + Trade Basket Losses ONLY",
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                          verticalSpaceTiny,
                          Text("??")
                        ],
                      ),
                    ],
                  ),
                ))),
      )),
    );
  }

  Future updateTrip(context) async {
    final doc = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.documentId);

    widget.product.updatedAt = FieldValue.serverTimestamp();

    return await doc.set(widget.product.toJson());
  }

  Future deleteTrip(context) async {
    final doc = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.documentId);

    return await doc.delete();
  }

  Money getFarmerPrice() {
    return widget.product.price! * 0.8;
  }
}
