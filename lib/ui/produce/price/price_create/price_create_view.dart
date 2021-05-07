import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/produce/price/price_create/price_create_view_model.dart';
import 'package:stacked/stacked.dart';

class PriceCreateView extends StatelessWidget {
  const PriceCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PriceCreateViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => PriceCreateViewModel(),
    );
  }
}
