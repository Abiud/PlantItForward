import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Calendar/calendar.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/screens/home/homeScreen.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [HomeScreen(), Produce(), Chat(), CalendarScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.graph_circle_fill),
          title: ("Overview"),
          activeColorPrimary: primaryGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.cube_box_fill),
          title: ("Produce"),
          activeColorPrimary: primaryGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          title: ("Chat"),
          activeColorPrimary: primaryGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.calendar_circle_fill),
          title: ("Calendar"),
          activeColorPrimary: primaryGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  // return CupertinoTabScaffold(
  //   tabBar: CupertinoTabBar(
  //     // backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
  //     activeColor: primaryGreen,
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.graph_circle_fill),
  //         label: 'Overview',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.cube_box_fill),
  //         label: 'Produce',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.chat_bubble_2_fill),
  //         label: 'Chat',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.calendar_circle_fill),
  //         label: 'Calendar',
  //       ),
  //     ],
  //   ),
  //   tabBuilder: (context, index) {
  //     switch (index) {
  //       case 0:
  //         return CupertinoTabView(builder: (context) {
  //           return HomeScreen();
  //         });
  //       case 1:
  //         return CupertinoTabView(builder: (context) {
  //           return CupertinoPageScaffold(
  //             child: Produce(),
  //           );
  //         });
  //       case 2:
  //         return CupertinoTabView(builder: (context) {
  //           return CupertinoPageScaffold(
  //             child: Chat(),
  //           );
  //         });
  //       case 3:
  //         return CupertinoTabView(builder: (context) {
  //           return CupertinoPageScaffold(
  //             child: CalendarScreen(),
  //           );
  //         });
  //       default:
  //         return CupertinoTabView(builder: (context) {
  //           return CupertinoPageScaffold(
  //             child: HomeScreen(),
  //           );
  //         });
  //     }
  //   },
  // );
}
