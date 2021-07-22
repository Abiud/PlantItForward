import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/new_product_view.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/produce_search.dart';
import 'package:plant_it_forward/widgets/product_card.dart';

class Price extends StatefulWidget {
  Price({Key? key}) : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
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
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: RefreshIndicator(
              child:
                  ListView(physics: AlwaysScrollableScrollPhysics(), children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: secondaryBlue,
                              elevation: 1,
                              backgroundColor: Colors.white,
                              onSurface: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8)),
                          onPressed: () => showSearch(
                              context: context, delegate: ProduceSearch()),
                          label: Text("Search"),
                          icon: Icon(Icons.search)),
                      horizontalSpaceSmall,
                      TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: secondaryBlue,
                              elevation: 1,
                              backgroundColor: Colors.white,
                              onSurface: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8)),
                          onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => NewProductView())),
                          label: Text("Add"),
                          icon: Icon(Icons.add)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildProductCard(context, _resultsList[index])),
                ),
              ]),
              onRefresh: getUsersPastTripsStreamSnapshots,
            ),
          );
  }
}
