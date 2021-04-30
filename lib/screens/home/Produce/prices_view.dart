import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/viewmodels/Produce/prices_view_model.dart';
import 'package:plant_it_forward/widgets/creation_aware_list_item.dart';
import 'package:plant_it_forward/widgets/product_item.dart';
import 'package:stacked/stacked.dart';

class PricesView extends StatelessWidget {
  const PricesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PricesViewModel>.reactive(
      viewModelBuilder: () => PricesViewModel(),
      onModelReady: (model) => model.listenToProducts(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: !model.busy
              ? Icon(Icons.add)
              : Center(child: CircularProgressIndicator()),
          // onPressed: () => Navigator.pushNamed(context, CreateProductViewRoute),
          onPressed: model.navigateToCreateView,
        ),
        body: model.products != null
            ? Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: model.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView.builder(
                          controller: model.scrollController,
                          itemCount: model.products.length,
                          itemBuilder: (context, index) =>
                              CreationAwareListItem(
                            itemCreated: () {
                              if (index % 20 == 0) {
                                model.requestMoreData();
                              }
                            },
                            child: index == 0
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Sort By"),
                                            horizontalSpaceSmall,
                                            DropdownButton(
                                              value: model.sortBy,
                                              items: <String>[
                                                'name',
                                                'price'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String value) {
                                                model.sortBy = value;
                                                model.updateSort();
                                              },
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.search),
                                            onPressed: () => print("search")),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => model.editProduct(index),
                                    child: ProductItem(
                                      product: model.products[index],
                                      onDeleteItem: () =>
                                          model.deleteProduct(index),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Loading(),
      ),
    );
  }
}

// class PricesView extends StatefulWidget {
//   PricesView({Key key}) : super(key: key);

//   @override
//   _PricesViewState createState() => _PricesViewState();
// }

// class _PricesViewState extends State<PricesView> {
//   TextEditingController _searchController = TextEditingController();
//   CollectionReference prices =
//       FirebaseFirestore.instance.collection("products");
//   String searchValue = "";

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   _onSearchChanged() {
//     searchResultsList();
//   }

//   searchResultsList() {
//     setState(() {
//       searchValue = _searchController.text.toLowerCase();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: CupertinoSearchTextField(
//               controller: _searchController,
//             ),
//           ),
//           StreamBuilder<QuerySnapshot>(
//             stream: (searchValue != "" && searchValue != null)
//                 ? FirebaseFirestore.instance
//                     .collection('products')
//                     .where('searchKeywords', arrayContains: searchValue)
//                     .orderBy('name')
//                     .snapshots()
//                 : FirebaseFirestore.instance
//                     .collection('products')
//                     .orderBy('name')
//                     .snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Something went wrong');
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CupertinoActivityIndicator();
//               }

//               return Container(
//                 child: Expanded(
//                   child: ListView(
//                     children:
//                         snapshot.data.docs.map((DocumentSnapshot document) {
//                       return buildProductCard(context, document);
//                     }).toList(),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
