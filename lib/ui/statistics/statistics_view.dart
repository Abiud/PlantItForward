import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/statistics/statistics_view_model.dart';
import 'package:stacked/stacked.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StatisticsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => StatisticsViewModel(),
    );
  }
}
