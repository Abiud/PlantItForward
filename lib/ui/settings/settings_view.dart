import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/settings/settings_view_model.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => SettingsViewModel(),
    );
  }
}
