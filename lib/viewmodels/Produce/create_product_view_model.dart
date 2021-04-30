import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/services/analytics_service.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/services/firestore_service.dart';
import 'package:plant_it_forward/viewmodels/base_model.dart';
import 'package:money2/money2.dart';

class CreateProductViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  final Currency usdCurrency = Currency.create('USD', 2);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  Product _product;
  Product get product => _product;

  bool _editting = false;
  bool get editting => _editting;

  Future addProduct() async {
    setBusy(true);

    await getCurrentUser();

    var result;
    if (!_editting) {
      result = await _firestoreService
          .addProduct(Product(
              name: _product.name,
              quantity: _product.quantity,
              price: _product.price,
              userId: currentUser.id))
          .then((value) async {
        _product.documentId = value.id;
      });
      await _analyticsService.logProductCreated();
    } else {
      result = await _firestoreService.updateProduct(Product(
        name: _product.name,
        quantity: _product.quantity,
        price: _product.price,
        documentId: _product.documentId,
      ));
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title:
            _editting ? 'Couldn\'t edit product' : 'Couldn\'t create product',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
          title: _editting
              ? 'Product successfully Updated'
              : 'Product successfully Added',
          description: _editting
              ? 'Your product has been updated'
              : 'Your product has been added');
      if (!_editting) {
        _editting = true;
      }
    }

    notifyListeners();
  }

  void setEdittingProduct(Product edittingProduct) {
    if (edittingProduct == null) {
      _product = new Product(
          name: "",
          quantity: "per ounce",
          price: Money.fromInt(0, Currency.create('USD', 2)));
    } else {
      _product = edittingProduct;
      _editting = true;
    }
  }

  String validatePrice(String val) {
    try {
      _product.price = usdCurrency.parse(val);
      return null;
    } catch (e) {
      return r'The value needs to be in the format "$0.0"';
    }
  }
}
