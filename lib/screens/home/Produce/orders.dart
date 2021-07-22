import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Produce/ordersStaff.dart';
import 'package:plant_it_forward/screens/home/Produce/ordersFarmer.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of(context)!.auth.currentUser.role == 'admin'
        ? OrdersStaff()
        : OrdersFarmer();
  }
}
