import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/constants/route_names.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/services/firestore_service.dart';
import 'package:plant_it_forward/services/navigation_service.dart';
import 'package:plant_it_forward/viewmodels/base_model.dart';

class PricesViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 52);
  ScrollController get scrollController => _scrollController;

  StreamSubscription _streamSubscription;

  List<Product> _products;
  List<Product> get products => _products;

  String sortBy = "name";

  void listenToProducts() {
    setBusy(true);

    _streamSubscription =
        _firestoreService.listenToProductsRealTime().listen((productsData) {
      List<Product> updatedProducts = productsData;
      if (updatedProducts != null && updatedProducts.length > 0) {
        _products = updatedProducts;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _firestoreService.resetStream();
    super.dispose();
  }

  Future deleteProduct(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the product?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var productToDelete = _products[index];
      setBusy(true);
      await _firestoreService.deleteProduct(productToDelete.documentId);
      setBusy(false);
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreateProductViewRoute);
  }

  void editProduct(int index) {
    _navigationService.navigateTo(CreateProductViewRoute,
        arguments: _products[index]);
  }

  void updateSort() {
    _firestoreService.sortProductsBy = sortBy;
    _streamSubscription?.cancel();
    _firestoreService.resetStream();
    listenToProducts();
  }

  void requestMoreData() => _firestoreService.requestMoreData();
}
