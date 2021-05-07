import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/auth/auth_view_model.dart';
import 'package:plant_it_forward/ui/auth/login/login_view.dart';
import 'package:plant_it_forward/ui/auth/register/register_view.dart';
import 'package:stacked/stacked.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      builder: (context, model, child) => model.showLogin
          ? LoginView(toggleView: model.toggleView)
          : RegisterView(toggleView: model.toggleView),
      viewModelBuilder: () => AuthViewModel(),
    );
  }
}
