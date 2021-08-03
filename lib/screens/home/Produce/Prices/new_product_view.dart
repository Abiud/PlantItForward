import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/Prices/product_view.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/extensions/CapExtension.dart';

class NewProductView extends StatefulWidget {
  NewProductView({Key? key}) : super(key: key);

  @override
  _NewProductViewState createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Currency usdCurrency = Currency.create('USD', 2);
  bool loading = false;
  String name = "";
  String measure = "per pound";
  Money price = Money.fromInt(0, Currency.create('USD', 2));
  String strPrice = "\$0.00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Produce"),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: FloatingActionButton.extended(
          backgroundColor: primaryGreen,
          elevation: 2,
          label: Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
          icon: !loading
              ? Icon(
                  Icons.add,
                  color: Colors.white,
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
          onPressed: () {
            if (!loading) {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                setState(() {
                  loading = true;
                });
                createProduct(context).then((val) async {
                  var doc = await FirebaseFirestore.instance
                      .collection("products")
                      .doc(val.id)
                      .get();
                  setState(() {
                    loading = false;
                  });
                  Product newProd = Product.fromSnapshot(doc);

                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ProductView(
                                product: newProd,
                              )));
                });
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: fieldContentPadding,
                      enabledBorder: fieldEnabledBorder,
                      focusedBorder: fieldFocusedBorder,
                      errorBorder: fieldErrorBorder,
                      labelText: 'Name',
                      hintText: "Lettuce"),
                  initialValue: name,
                  validator: (val) {
                    if (name.length > 0) {
                      return null;
                    }
                    return "Name cannot be empty";
                  },
                  onChanged: (val) {
                    name = val;
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
                    value: measure,
                    onChanged: (val) {
                      measure = val.toString();
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
                  inputFormatters: [CurrencyTextInputFormatter(symbol: '\$')],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: fieldContentPadding,
                      enabledBorder: fieldEnabledBorder,
                      focusedBorder: fieldFocusedBorder,
                      errorBorder: fieldErrorBorder,
                      labelText: 'Price',
                      hintText: "\$2.50"),
                  initialValue: strPrice,
                  validator: (val) {
                    try {
                      price = usdCurrency.parse(strPrice);
                      return null;
                    } catch (e) {
                      return r'The value needs to be in the format ".0"';
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      strPrice = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createProduct(context) async {
    final collection = FirebaseFirestore.instance.collection('products');

    return await collection.add({
      "name": name.inCaps,
      "price": price.minorUnits.toInt(),
      "measure": measure,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp()
    });
  }
}
