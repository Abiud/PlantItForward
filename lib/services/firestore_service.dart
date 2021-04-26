import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _productsCollectionReference =
      FirebaseFirestore.instance.collection('products');

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Product>> _allPagedResults = [<Product>[]];

  static const int ProductsLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMoreProducts = true;

  Future createUser(UserData user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserData.fromData(userData.data());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addProduct(Product product) async {
    try {
      await _productsCollectionReference.add(product.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getProductsOnceOff() async {
    try {
      var productDocumentSnapshot =
          await _productsCollectionReference.limit(ProductsLimit).get();
      if (productDocumentSnapshot.docs.isNotEmpty) {
        return productDocumentSnapshot.docs
            .map((snapshot) => Product.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToProductsRealTime() {
    // Register the handler for when the products data changes
    _requestProducts();
    return _productsController.stream;
  }

  // #1: Move the request products into it's own function
  void _requestProducts() {
    // #2: split the query from the actual subscription
    var pageProductsQuery = _productsCollectionReference
        .orderBy('name')
        // #3: Limit the amount of results
        .limit(ProductsLimit);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pageProductsQuery = pageProductsQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreProducts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pageProductsQuery.snapshots().listen((productsSnapshot) {
      if (productsSnapshot.docs.isNotEmpty) {
        var products = productsSnapshot.docs
            .map((snapshot) => Product.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.name != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the products for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = products;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(products);
        }

        // #11: Concatenate the full list to be shown
        var allProducts = _allPagedResults.fold<List<Product>>(<Product>[],
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all products
        _productsController.add(allProducts);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = productsSnapshot.docs.last;
        }

        // #14: Determine if there's more products to request
        _hasMoreProducts = products.length == ProductsLimit;
      }
    });
  }

  Future deleteProduct(String documentId) async {
    await _productsCollectionReference.doc(documentId).delete();
  }

  Future updateProduct(Product product) async {
    try {
      await _productsCollectionReference
          .doc(product.documentId)
          .update(product.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  void requestMoreData() => _requestProducts();
}
