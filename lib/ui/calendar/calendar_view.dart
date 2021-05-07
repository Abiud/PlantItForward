import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/calendar/calendar_view_model.dart';
import 'package:stacked/stacked.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CalendarViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => CalendarViewModel(),
    );
  }
}
