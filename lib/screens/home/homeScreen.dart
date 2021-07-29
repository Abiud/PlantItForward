import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Profile/editProfile.dart';
import 'package:plant_it_forward/screens/home/Settings/settings.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/ClippedParts.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(
      children: [
        ClipPath(
          clipper: HomeOutterClippedPart(),
          child: Container(
            color: secondaryBlue,
            width: screenWidth(context),
            height: screenHeight(context),
          ),
        ),
        ClipPath(
          clipper: HomeInnerClippedPart(),
          child: Container(
            color: primaryGreen,
            width: screenWidth(context),
            height: screenHeight(context),
          ),
        ),
        SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Provider.of(context)!.auth.currentUser!.photoUrl != null
                    ? GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EditProfile(
                                      profile: Provider.of(context)!
                                          .auth
                                          .currentUser!,
                                    ))),
                        child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(Provider.of(context)!
                                .auth
                                .currentUser!
                                .photoUrl!)),
                      )
                    : IconButton(
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EditProfile(
                                      profile: Provider.of(context)!
                                          .auth
                                          .currentUser!,
                                    ))),
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                horizontalSpaceSmall,
                IconButton(
                    onPressed: () => showCupertinoModalBottomSheet(
                        context: context, builder: (context) => ModalFit()),
                    icon: Icon(Icons.settings, color: Colors.white))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  "Upcoming Events",
                  style: TextStyle(
                      color: LightColors.kDarkBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2),
                ),
                horizontalSpaceTiny,
                Icon(
                  Icons.event,
                  color: LightColors.kDarkBlue,
                )
              ],
            ),
          ),
          verticalSpaceSmall,
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                horizontalSpaceSmall,
                testEvent(),
                testEvent(),
                testEvent(),
              ],
            ),
          ),
          verticalSpaceMedium,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  "Active Order",
                  style: TextStyle(
                      color: LightColors.kDarkBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2),
                ),
                horizontalSpaceTiny,
                Icon(
                  Icons.assignment,
                  color: LightColors.kDarkBlue,
                )
              ],
            ),
          ),
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 120,
              width: double.infinity,
              child: Card(),
            ),
          )
        ])),
      ],
    )));
  }

  Widget testEvent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cutString("New Event about some stuff", 18),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            verticalSpaceTiny,
            Text("2:00pm - 4:00pm",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            Text("Tuesday, 20 July",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
          ],
        ),
      ),
    );
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
        ListTile(
          title: Text('Log out'),
          leading: Icon(Icons.logout),
          onTap: () => AuthService().signOut(),
        ),
      ],
    ));
  }
}
