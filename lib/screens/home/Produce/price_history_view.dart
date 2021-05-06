import 'package:flutter/material.dart';
import 'package:plant_it_forward/viewmodels/Produce/price_history_view_model.dart';
import 'package:stacked/stacked.dart';

class PriceHistoryView extends StatelessWidget {
  final String productId;
  const PriceHistoryView({Key key, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        onModelReady: (model) {
          model.getHistory(productId);
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text("History"),
              ),
              body: Text("Hi"),
            ),
        viewModelBuilder: () => PriceHistoryViewModel());
  }
}
