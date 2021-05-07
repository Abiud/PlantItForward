import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/produce/price/price_history/price_history_view_model.dart';
import 'package:stacked/stacked.dart';

class PriceHistoryView extends StatelessWidget {
  const PriceHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PriceHistoryViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => PriceHistoryViewModel(),
    );
  }
}
