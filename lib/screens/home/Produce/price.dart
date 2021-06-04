import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/screens/home/Produce/new_product_view.dart';
import 'package:plant_it_forward/shared/loading.dart';
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

  bool _showBackToTopButton = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            _scrollController.offset >= 100) {
          setState(() {
            _showBackToTopButton = true;
          });
        } else {
          setState(() {
            _showBackToTopButton = false;
          });
        }
        // setState(() {
        //   if (_scrollController.offset >= 400) {
        //     _showBackToTopButton = true; // show the back-to-top button
        //   } else {
        //     _showBackToTopButton = false; // hide the back-to-top button
        //   }
        // });
      });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
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
            floatingActionButton: _showBackToTopButton == false
                ? null
                : FloatingActionButton(
                    onPressed: _scrollToTop,
                    child: Icon(Icons.arrow_upward),
                  ),
            body: RefreshIndicator(
              child: ListView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 2),
                          //   child: Container(
                          //     width: screenWidthFraction(context, dividedBy: 2),
                          //     child: CupertinoSearchTextField(
                          //       controller: _searchController,
                          //     ),
                          //   ),
                          // ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => NewProductView()));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => NewProductView()));
                            },
                          )
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
