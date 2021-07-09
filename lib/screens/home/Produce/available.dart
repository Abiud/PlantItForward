import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Produce/availableFarmer.dart';
import 'package:plant_it_forward/screens/home/Produce/availableStaff.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class Available extends StatelessWidget {
  const Available({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of(context)!.auth.currentUser.role == 'admin'
        ? AvailableStaff()
        : AvailableFarmer();
  }
}
