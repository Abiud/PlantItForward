import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/customWidgets/drawerScreen.dart';
import 'package:plant_it_forward/screens/home/chat.dart';
import 'package:plant_it_forward/screens/home/homeScreen.dart';
import 'package:plant_it_forward/screens/home/price.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          DrawerScreen(
              selectedIndex: selectedIndex,
              onIndexChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                });
              }),
          // MainSection(
          //   selectedIndex: selectedIndex,
          // )
          GestureDetector(
            onTap: () {
              setState(() {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
              });
            },
            onPanUpdate: (det) {
              if (det.delta.dy > 0) {
                setState(() {
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                });
              }
            },
            child: AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0)),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isDrawerOpen
                                ? IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      setState(() {
                                        xOffset = 0;
                                        yOffset = 0;
                                        scaleFactor = 1;
                                        isDrawerOpen = false;
                                      });
                                    })
                                : IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      setState(() {
                                        xOffset = scrWidth < 720
                                            ? 230
                                            : scrWidth - (scrWidth * 0.85);
                                        yOffset = 120;
                                        scaleFactor = 0.8;
                                        isDrawerOpen = true;
                                      });
                                    }),
                            Text(
                              drawerItems[selectedIndex]['title'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.chat_outlined),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat()));
                                })
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Builder(builder: (context) {
                          switch (selectedIndex) {
                            case 0:
                              return HomeScreen();
                            case 1:
                              return Price();
                            default:
                              return HomeScreen();
                          }
                        })
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
