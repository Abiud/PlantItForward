import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/viewmodels/Produce/create_product_view_model.dart';
import 'package:stacked/stacked.dart';

class CreateProductView extends StatelessWidget {
  final Product edittingProduct;
  CreateProductView({Key key, this.edittingProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price;
    return ViewModelBuilder<CreateProductViewModel>.reactive(
        viewModelBuilder: () => CreateProductViewModel(),
        onModelReady: (model) {
          model.setEdittingProduct(edittingProduct);
          price = model.product?.price.toString();
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: primaryGreen,
                title: Text(
                  model.editting ? 'Edit Product' : 'Add Product',
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => model.deleteProduct()),
                  IconButton(
                      icon: Icon(CupertinoIcons.clock_solid),
                      onPressed: () => {}),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: !model.busy
                    ? model.editting
                        ? Icon(Icons.edit)
                        : Icon(Icons.add)
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                onPressed: () {
                  if (!model.busy) {
                    if (model.formKey.currentState.validate()) {
                      model.addProduct();
                      FocusScope.of(context).unfocus();
                    }
                  }
                },
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceMedium,
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: InputBorder.none,
                          hintText: "Lettuce",
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding:
                              EdgeInsets.only(left: 14, bottom: 6, top: 8),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryBlue)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[200]),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        initialValue: model.product.name,
                        validator: (val) {
                          if (model.product.name.length > 0) {
                            return null;
                          }
                          return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          model.product.name = val;
                        },
                      ),
                      verticalSpaceMedium,
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Quantity",
                            border: InputBorder.none,
                            hintText: "Per pound/Per bunch",
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding:
                                EdgeInsets.only(left: 14, bottom: 6, top: 8),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryBlue)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[200]),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          value: model.product.quantity,
                          onChanged: (val) {
                            model.product.quantity = val;
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
                        autofocus: false,
                        inputFormatters: [
                          CurrencyTextInputFormatter(symbol: '\$')
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Price",
                          border: InputBorder.none,
                          hintText: "\$2.00",
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding:
                              EdgeInsets.only(left: 14, bottom: 6, top: 8),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryBlue)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        initialValue: price,
                        validator: (val) => model.validatePrice(val),
                        onChanged: (val) {
                          price = val;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
