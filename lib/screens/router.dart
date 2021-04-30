import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/constants/route_names.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/home/Produce/create_product_view.dart';
import 'package:plant_it_forward/screens/home/home_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Authenticate(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case CreateProductViewRoute:
      var productToEdit = settings.arguments as Product;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateProductView(
          edittingProduct: productToEdit,
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
