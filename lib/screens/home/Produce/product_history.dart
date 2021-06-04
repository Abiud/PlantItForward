import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/widgets/product_card_history.dart';

class ProductHistoryView extends StatefulWidget {
  final String productId;
  ProductHistoryView({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductHistoryViewState createState() => _ProductHistoryViewState();
}

class _ProductHistoryViewState extends State<ProductHistoryView> {
  bool loading = true;
  List _allResults = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProductHistory();
  }

  Future<void> getProductHistory() async {
    setState(() {
      loading = true;
    });
    // final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .collection("history")
        .orderBy("updatedAt")
        .get();

    setState(() {
      _allResults = data.docs;
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Loading()
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 6),
                  child: Text("Changes",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 12),
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _allResults.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildProductCardHistory(context, _allResults[index])),
                )
              ],
            ),
      // ListView.builder(
      //     itemCount: _allResults.length,
      //     itemBuilder: (BuildContext context, int index) =>
      //         buildProductCard(context, _allResults[index])),
    );
  }
}
