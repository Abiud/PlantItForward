import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryGreen = Color(0xff3CC404);
Color secondaryBlue = Color(0xff0646FC);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> drawerItems = [
  {'icon': CupertinoIcons.chart_bar_alt_fill, 'title': "Overview"},
  {'icon': CupertinoIcons.money_dollar_circle_fill, 'title': "Prices"},
  {'icon': CupertinoIcons.doc_checkmark_fill, 'title': "Available Produce"},
  {'icon': CupertinoIcons.cube_box_fill, 'title': "Orders"},
  {'icon': Icons.people, 'title': "Users"},
];
