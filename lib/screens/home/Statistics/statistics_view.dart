import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Profile/profile.dart';
import 'package:plant_it_forward/screens/home/Settings/settings.dart';
import 'package:plant_it_forward/viewmodels/statistics_view_model.dart';
import 'package:stacked/stacked.dart';

class StatisticsView extends StatefulWidget {
  StatisticsView({Key? key}) : super(key: key);

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StatisticsViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                heroTag:
                    'overview', // a different string for each navigationBar
                transitionBetweenRoutes: false,
                leading: CupertinoButton(
                  child: Icon(
                    CupertinoIcons.settings,
                    color: secondaryBlue,
                  ),
                  onPressed: () => showCupertinoModalBottomSheet(
                      context: context, builder: (context) => ModalFit()),
                ),
                backgroundColor: Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.transparent)),
              ),
              child: Center(
                child: Text(model.title),
              ),
            ),
        viewModelBuilder: () => StatisticsViewModel());
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Profile'),
            leading: Icon(CupertinoIcons.person),
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Profile()));
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(CupertinoIcons.settings),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(CupertinoIcons.power),
            onTap: () {
              Navigator.pop(context);
              // AuthenticationService().signOut();
            },
          ),
        ],
      ),
    ));
  }
}
