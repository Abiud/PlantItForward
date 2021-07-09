import 'package:flutter/material.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of(context)!.auth.currentUser.role == 'admin'
        ? Text("Admin")
        : Text("User");
  }
}
