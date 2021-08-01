import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/_wrapper_admin.dart';
import 'package:plant_it_forward/screens/home/_wrapper_farmer.dart';
import 'package:plant_it_forward/screens/home/_wrapper_volunteer.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:provider/provider.dart';

class NavWrapper extends StatefulWidget {
  NavWrapper({Key? key}) : super(key: key);

  @override
  _NavWrapperState createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  @override
  Widget build(BuildContext context) {
    // StreamProvider the userData
    _getRole() async {
      final token = await Provider.of<AuthService>(context).claims;
      final String? roleClaim = token['role'];
      final String role = roleClaim ?? 'volunteer';
      return role;
    }

    return Consumer<AuthService>(builder: (context, auth, child) {
      return FutureBuilder(
        future: _getRole(),
        builder: (context, roleSnapshot) {
          switch (roleSnapshot.data) {
            case 'admin':
              return AdminWrapper();
            case 'farmer':
              return FarmerWrapper();
            default:
              return VolunteerWrapper();
          }
        },
      );
    });
  }
}
