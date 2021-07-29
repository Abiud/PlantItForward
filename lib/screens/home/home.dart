import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Admin/admin_view.dart';
import 'package:plant_it_forward/screens/home/Calendar/calendar.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/screens/home/homeScreen.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

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
    if (Provider.of(context)!.auth.currentUser!.isPartOfProgram()) {
      List<Widget> screens = [
        HomeScreen(),
        Produce(),
        Chat(),
        CalendarScreen()
      ];
      if (Provider.of(context)!.auth.currentUser!.isAdmin())
        return [...screens, AdminView()];
      return screens;
    }
    return [HomeScreen(), CalendarScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    if (Provider.of(context)!.auth.currentUser!.isPartOfProgram()) {
      List<PersistentBottomNavBarItem> tabs = [
        PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: ("Home"),
            activeColorPrimary: primaryGreen,
            inactiveColorPrimary: CupertinoColors.systemGrey),
        PersistentBottomNavBarItem(
            icon: Icon(Icons.shopping_basket),
            title: ("Produce"),
            activeColorPrimary: primaryGreen,
            inactiveColorPrimary: CupertinoColors.systemGrey),
        PersistentBottomNavBarItem(
            icon: Icon(Icons.forum),
            title: ("Chat"),
            activeColorPrimary: primaryGreen,
            inactiveColorPrimary: CupertinoColors.systemGrey),
        PersistentBottomNavBarItem(
            icon: Icon(Icons.calendar_today),
            title: ("Calendar"),
            activeColorPrimary: primaryGreen,
            inactiveColorPrimary: CupertinoColors.systemGrey),
      ];
      if (Provider.of(context)!.auth.currentUser!.isAdmin())
        return [
          ...tabs,
          PersistentBottomNavBarItem(
              icon: Icon(Icons.people),
              title: ("Manage"),
              activeColorPrimary: primaryGreen,
              inactiveColorPrimary: CupertinoColors.systemGrey),
        ];
      return tabs;
    }
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: primaryGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.calendar_today),
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
}
