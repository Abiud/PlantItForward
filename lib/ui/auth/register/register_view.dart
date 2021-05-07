import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/auth/register/register_view_model.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatelessWidget {
  final Function toggleView;
  const RegisterView({Key? key, required this.toggleView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => RegisterViewModel(),
    );
  }
}
