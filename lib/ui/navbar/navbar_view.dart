import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/calendar/calendar_view.dart';
import 'package:plant_it_forward/ui/chat/chat_list/chat_list_view.dart';
import 'package:plant_it_forward/ui/navbar/navbar_view_model.dart';
import 'package:plant_it_forward/ui/produce/produce_view.dart';
import 'package:plant_it_forward/ui/statistics/statistics_view.dart';
import 'package:stacked/stacked.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavbarViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
        body: IndexedStack(
          children: [
            StatisticsView(),
            ProduceView(),
            ChatListView(),
            CalendarView(),
          ],
          index: model.currentIndex,
        ),
      ),
      viewModelBuilder: () => NavbarViewModel(),
    );
  }
}
