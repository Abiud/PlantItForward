import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/produce/price/price_list/price_list_view_model.dart';
import 'package:stacked/stacked.dart';

class PriceListView extends StatelessWidget {
  const PriceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PriceListViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => PriceListViewModel(),
    );
  }
}
