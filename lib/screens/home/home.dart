import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Calendar/calendar.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/screens/home/homeScreen.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
        activeColor: primaryGreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_circle_fill),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box_fill),
            label: 'Produce',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar_circle_fill),
            label: 'Calendar',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return HomeScreen();
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Produce(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Chat(),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: CalendarScreen(),
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeScreen(),
              );
            });
        }
      },
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Stack(
    //     children: [
    //       SafeArea(
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(top: 12.0),
    //               child: Container(
    //                 margin: EdgeInsets.symmetric(horizontal: 20),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     isDrawerOpen
    //                         ? IconButton(
    //                             icon: Icon(Icons.arrow_back_ios),
    //                             onPressed: () {
    //                               setState(() {
    //                                 xOffset = 0;
    //                                 yOffset = 0;
    //                                 scaleFactor = 1;
    //                                 isDrawerOpen = false;
    //                               });
    //                             })
    //                         : IconButton(
    //                             icon: Icon(Icons.menu),
    //                             onPressed: () {
    //                               setState(() {
    //                                 xOffset = scrWidth < 720
    //                                     ? 230
    //                                     : scrWidth - (scrWidth * 0.85);
    //                                 yOffset = 120;
    //                                 scaleFactor = 0.8;
    //                                 isDrawerOpen = true;
    //                               });
    //                             }),
    //                     Text(
    //                       drawerItems[selectedIndex]['title'].toString(),
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.bold, fontSize: 18),
    //                     ),
    //                     IconButton(
    //                         icon: Icon(Icons.chat_outlined),
    //                         onPressed: () {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => Chat()));
    //                         })
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Column(
    //               children: [
    //                 Builder(builder: (context) {
    //                   switch (selectedIndex) {
    //                     case 0:
    //                       return HomeScreen();
    //                     case 1:
    //                       return Chat();
    //                     case 2:
    //                       return Price();
    //                     default:
    //                       return HomeScreen();
    //                   }
    //                 })
    //               ],
    //             )
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
