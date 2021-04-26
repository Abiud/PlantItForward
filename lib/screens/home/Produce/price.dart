import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/widgets/product_card.dart';

class Price extends StatefulWidget {
  Price({Key key}) : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  TextEditingController _searchController = TextEditingController();
  CollectionReference prices =
      FirebaseFirestore.instance.collection("products");
  String searchValue = "";
  // Future resultsLoaded;
  // List _allResults = [];
  // List _resultsList = [];
  // bool loading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    setState(() {
      searchValue = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CupertinoSearchTextField(
              controller: _searchController,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: (searchValue != "" && searchValue != null)
                ? FirebaseFirestore.instance
                    .collection('products')
                    .where('searchKeywords', arrayContains: searchValue)
                    .orderBy('name')
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('name')
                    .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              }

              return Container(
                child: Expanded(
                  child: ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return buildProductCard(context, document);
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
