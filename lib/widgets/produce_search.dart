import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/services/algolia.dart';
import 'package:plant_it_forward/shared/loading.dart';

class ItemSearch extends SearchDelegate<String> {
  final String indexName;
  final Function navFunction;
  ItemSearch({required this.indexName, required this.navFunction});
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
        _algoliaApp.instance.index(indexName).query(query);
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
                      onTap: () => navFunction(result.data['objectID']),
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
        _algoliaApp.instance.index(indexName).query(query);

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
                      onTap: () => navFunction(result.data['objectID']),
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
