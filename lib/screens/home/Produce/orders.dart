import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/screens/home/Produce/ordersStaff.dart';
import 'package:plant_it_forward/screens/home/Produce/ordersFarmer.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (Provider.of<UserData>(context).isAdmin()) {
        return OrdersStaff();
      }
      return OrdersFarmer();
    });
  }
}
