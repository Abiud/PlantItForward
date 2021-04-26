import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Calendar/calendar.dart';
import 'package:plant_it_forward/screens/home/Chat/chat.dart';
import 'package:plant_it_forward/screens/home/Produce/produce.dart';
import 'package:plant_it_forward/screens/home/Statistics/statistics_view.dart';
import 'package:plant_it_forward/viewmodels/home_view_model.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              body: getViewForIndex(model.currentIndex),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                currentIndex: model.currentIndex,
                onTap: model.setIndex,
                items: [
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
            ),
        viewModelBuilder: () => HomeViewModel());
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return StatisticsView();
      case 1:
        return Produce();
      case 2:
        return Chat();
      case 3:
        return CalendarScreen();
      default:
        return StatisticsView();
    }
  }
}
