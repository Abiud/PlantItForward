import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NavbarViewModel extends IndexTrackingViewModel {
  final statisticsView = GlobalKey<NavigatorState>();
  final produceView = GlobalKey<NavigatorState>();
  final chatView = GlobalKey<NavigatorState>();
  final calendarView = GlobalKey<NavigatorState>();
}
