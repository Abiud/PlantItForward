import 'package:flutter/material.dart';
import 'package:plant_it_forward/utils/config.dart';

// Input Decorations
EdgeInsetsGeometry fieldContentPadding = EdgeInsets.all(8);

InputBorder fieldEnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(12)));

InputBorder fieldFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: secondaryBlue, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(12)));

InputBorder fieldErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(12)));

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.fromLTRB(16, 0, 0, 0);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);
