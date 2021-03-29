import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/customWidgets/provider_widget.dart';
import 'package:plant_it_forward/services/auth.dart';

class DrawerScreen extends StatefulWidget {
  final int selectedIndex;
  final Function onIndexChanged;
  DrawerScreen({Key key, this.selectedIndex, this.onIndexChanged})
      : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [primaryGreen, Color(0xff4FC91D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        padding: EdgeInsets.only(top: 50, bottom: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of(context).auth.currentUser?.name ?? "User",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          Provider.of(context).auth.currentUser?.role ??
                              "Farmer",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: drawerItems.map((e) {
                  int index = drawerItems.indexOf(e);
                  bool isAdmin =
                      Provider.of(context).auth.currentUser.isAdmin();
                  if (isAdmin) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Theme(
                        data: ThemeData(splashColor: Colors.green),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              widget.onIndexChanged(index);
                            },
                            child: Container(
                              color: index == widget.selectedIndex
                                  ? Colors.green
                                  : Colors.transparent,
                              height: 52,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    e['icon'],
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(e['title'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))
                                ],
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  } else {
                    if (e['admin'] == false) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Theme(
                          data: ThemeData(splashColor: Colors.green),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                widget.onIndexChanged(index);
                              },
                              child: Container(
                                color: index == widget.selectedIndex
                                    ? Colors.green
                                    : Colors.transparent,
                                height: 52,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      e['icon'],
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(e['title'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))
                                  ],
                                ),
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    }
                  }
                  return SizedBox();
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    Text("Settings",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      icon: Icon(Icons.logout),
                      label: Text("logout"),
                      style: TextButton.styleFrom(primary: Colors.white),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
