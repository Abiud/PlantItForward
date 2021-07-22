import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Produce/product_view.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/loading.dart';

class ProduceSearch extends SearchDelegate<String> {
  final Algolia _algoliaApp = AlgoliaApplication.algolia;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    final AlgoliaQuery searchQuery =
        _algoliaApp.instance.index("AppProduce").query(query);
    if (query.isNotEmpty) {
      return FutureBuilder(
        future: searchQuery.getObjects(),
        builder: (BuildContext context,
            AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
            default:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final AlgoliaObjectSnapshot result =
                        snapshot.data!.hits[index];
                    return ListTile(
                      leading: Icon(Icons.list),
                      title: Text(result.data['name']),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ProductView(
                                    produceId: result.data['objectID'])));
                      },
                    );
                  },
                  itemCount: snapshot.data?.hits.length,
                );
              }
          }
        },
      );
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final AlgoliaQuery searchQuery =
        _algoliaApp.instance.index("AppProduce").query(query);

    if (query.length < 2) {
      return Container();
    }
    return FutureBuilder(
      future: searchQuery.getObjects(),
      builder:
          (BuildContext context, AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Loading();
          default:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final AlgoliaObjectSnapshot result =
                      snapshot.data!.hits[index];
                  return ListTile(
                      leading: Icon(Icons.food_bank),
                      title: Text(result.data['name']));
                },
                itemCount: snapshot.data?.hits.length,
              );
            }
        }
      },
    );
  }
}
