import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/screens/home/Produce/Prices/product_history.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class ProductView extends StatefulWidget {
  final Product? product;
  final String? produceId;
  final String? parentId;

  ProductView({Key? key, this.product, this.produceId, this.parentId})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Currency usdCurrency = Currency.create('USD', 2);
  String? price;
  String? quantityValue;
  late Future<Product> _prod;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      setState(() {
        price = widget.product!.price.toString();
        quantityValue = widget.product!.measure;
      });
    }
    _prod = getProduct();
  }

  Future<Product> getProduct() async {
    if (widget.product != null) {
      setState(() {
        price = widget.product!.price.toString();
        quantityValue = widget.product!.measure;
      });
      return Future.value(widget.product);
    }
    Product prod = Product(name: "", documentId: "", updatedAt: "");
    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.produceId)
        .get()
        .then((value) => prod = Product.fromSnapshot(value))
        .catchError((error, stackTrace) {
      Future.error(error);
    });
    setState(() {
      price = prod.price.toString();
      quantityValue = prod.measure;
    });
    return Future.value(prod);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _prod,
        builder: (context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              Product item = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: Text(item.name),
                  actions: [
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      elevation: 2,
                      onSelected: (res) {
                        if (res == 0) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ProductHistoryView(
                                  productId: item.documentId));
                        } else if (res == 1) {
                          deleteTrip(item);
                          Navigator.pop(context);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<Object>>[
                          if (widget.parentId == null) ...[
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
                          ],
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
                  ],
                ),
                floatingActionButton: widget.parentId == null
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: FloatingActionButton.extended(
                          backgroundColor: primaryGreen,
                          elevation: 2,
                          label: Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: !loading
                              ? Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )
                              : CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                          onPressed: () {
                            if (!loading) {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                updateTrip(context, item).then((_) async {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            }
                          },
                        ),
                      )
                    : null,
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
                                initialValue: item.name,
                                validator: (val) {
                                  if (item.name.length > 0) {
                                    return null;
                                  }
                                  return "Name cannot be empty";
                                },
                                onChanged: (val) {
                                  item.name = val.toString();
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
                                    item.measure = val.toString();
                                    quantityValue = val.toString();
                                  },
                                  items: <String>[
                                    'per pound',
                                    'per bunch',
                                    'per pint',
                                    'per foot',
                                    'per head'
                                  ].map<DropdownMenuItem<String>>((String e) {
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
                                  try {
                                    item.price = usdCurrency.parse(price!);
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
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
                                  verticalSpaceTiny,
                                  Text(getFarmerPrice(item.price!).toString())
                                ],
                              ),
                              verticalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Farmer price (75/25) with adjustments",
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
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
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
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
                                    style:
                                        TextStyle(color: Colors.grey.shade800),
                                  ),
                                  verticalSpaceTiny,
                                  Text("??")
                                ],
                              ),
                            ],
                          ),
                        ))),
              );
            }
          }
        });
  }

  Future updateTrip(context, Product item) async {
    final doc =
        FirebaseFirestore.instance.collection('products').doc(item.documentId);

    item.updatedAt = FieldValue.serverTimestamp();

    return await doc.set(item.toJson());
  }

  Future deleteTrip(Product item) async {
    if (widget.parentId != null) {
      return await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.parentId)
          .collection("history")
          .doc(item.documentId)
          .delete();
    } else {
      return await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.parentId)
          .delete();
    }
  }

  Money getFarmerPrice(Money price) {
    return price * 0.8;
  }
}
