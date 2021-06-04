import 'package:plant_it_forward/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/services/database.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  final DatabaseService db;

  Provider(
      {Key? key, required Widget child, required this.auth, required this.db})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider? of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}
