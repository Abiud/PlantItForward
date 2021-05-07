import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/home/home_view.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/viewmodels/startup_test_view_model.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewTestModel>.reactive(
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            body: StreamBuilder<String>(
              stream: model.stream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final bool signedIn = snapshot.hasData;
                  return signedIn ? HomeView() : Authenticate();
                }
                return Loading();
              },
            )),
        viewModelBuilder: () => StartupViewTestModel());
  }
}
