import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
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
          ..scale(scaleFactor)
          ..rotateY(isDrawerOpen ? -0.5 : 0),
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0)),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
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
                                  : scrWidth - (scrWidth * -0.85);
                              yOffset = 120;
                              scaleFactor = 0.8;
                              isDrawerOpen = true;
                            });
                          }),
                  Column(
                    children: [
                      // Text('Location'),
                      Row(
                        children: [
                          Icon(
                            Icons.pie_chart,
                            color: primaryGreen,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text('Overview')
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: Icon(Icons.chat_outlined), onPressed: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
