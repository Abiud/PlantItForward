import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plant_it_forward/Models/CalEvent.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/helperFunctions.dart';
import 'package:plant_it_forward/screens/home/Profile/editProfile.dart';
import 'package:plant_it_forward/screens/home/Settings/settings.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/ClippedParts.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:provider/provider.dart';

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
        body: Stack(
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
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          Provider.of<UserData>(context).name,
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Provider.of<UserData>(context).photoUrl != null
                    ? GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EditProfile(
                                      profile: Provider.of<UserData>(context),
                                    ))),
                        child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                Provider.of<UserData>(context).photoUrl!)),
                      )
                    : GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EditProfile(
                                      profile: Provider.of<UserData>(context),
                                    ))),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )),
                horizontalSpaceSmall,
                GestureDetector(
                  onTap: () => showCupertinoModalBottomSheet(
                      context: context, builder: (context) => ModalFit()),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: LightColors.kDarkBlue,
                ),
                horizontalSpaceTiny,
                Text(
                  "Upcoming Events",
                  style: TextStyle(
                      color: LightColors.kDarkBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                horizontalSpaceSmall,
                StreamBuilder<List<CalEvent>>(
                  stream: FirebaseFirestore.instance
                      .collection("events")
                      .where("endDate", isGreaterThan: DateTime.now())
                      .snapshots()
                      .map((doc) => doc.docs
                          .map((e) => CalEvent.fromSnapshot(e.id, e.data()))
                          .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    } else {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error retrieving events!"),
                        );
                      } else {
                        if (snapshot.data != null) {
                          List<CalEvent> events = snapshot.data!;
                          return Container(
                            height: 100,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                return eventCard(events[index]);
                              },
                            ),
                          );
                        }
                        return Center(
                          child: Text("No events scheduled!"),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          if (Provider.of<UserData>(context).isAdmin()) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.assignment,
                    color: LightColors.kDarkBlue,
                  ),
                  horizontalSpaceTiny,
                  Text(
                    "Week Active Orders",
                    style: TextStyle(
                        color: LightColors.kDarkBlue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2),
                  ),
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
          ],
        ])),
      ],
    ));
  }

  Widget eventCard(CalEvent event) {
    return Card(
      child: Container(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cutString(event.title, 18),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              verticalSpaceTiny,
              Text(DateFormat("hh:mm a").format(event.startDateTime),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              Text("Tuesday, 20 July",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
            ],
          ),
        ),
      ),
    );
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
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
          onTap: () => _auth.signOut(),
        )
      ],
    ));
  }
}
