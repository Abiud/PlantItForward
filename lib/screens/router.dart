import 'package:flutter/material.dart';
import 'package:plant_it_forward/constants/route_names.dart';
import 'package:plant_it_forward/screens/authenticate/register.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';
import 'package:plant_it_forward/screens/home/Statistics/statistics_view.dart';
import 'package:plant_it_forward/screens/home/home_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignIn(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Register(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    // case CreatePostViewRoute:
    //   var postToEdit = settings.arguments as Post;
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: CreatePostView(
    //       edittingPost: postToEdit,
    //     ),
    //   );
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
