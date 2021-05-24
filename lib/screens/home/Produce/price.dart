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

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  bool loading = true;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var productSnapshot in _allResults) {
        var title = Product.fromSnapshot(productSnapshot).name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(productSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  Future<void> getUsersPastTripsStreamSnapshots() async {
    setState(() {
      loading = true;
    });
    // final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    setState(() {
      loading = false;
    });
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoSearchTextField(
                controller: _searchController,
              ),
            ),
            loading
                ? CupertinoActivityIndicator()
                : Expanded(
                    child: RefreshIndicator(
                      child: ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: _resultsList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildProductCard(context, _resultsList[index])),
                      onRefresh: getUsersPastTripsStreamSnapshots,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
