import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}
