// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getAdjustedWeekday(DateTime dateTime) => 1 + dateTime.weekday % 7;

final dateF = new DateFormat.yMd().add_jm();

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    DateTime.now(): [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(2021, 1, 1);
final kLastDay = DateTime(kNow.year + 1, 12, 31);

DateTime beginingOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 0, 0, 0);

DateTime endOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 59, 59);

DateTime lastDayOfMonth(DateTime month) {
  var beginningNextMonth = (month.month < 12)
      ? new DateTime(month.year, month.month + 1, 1)
      : new DateTime(month.year + 1, 1, 1);

  return beginningNextMonth.subtract(new Duration(days: 1));
}

/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - getAdjustedWeekday(dec28) + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - getAdjustedWeekday(date) + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

/// Find the first date of the week which contains the provided date.
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  DateTime startOfWeek =
      dateTime.subtract(Duration(days: getAdjustedWeekday(dateTime) - 1));
  return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
}

/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  DateTime endOfWeek = dateTime
      .add(Duration(days: DateTime.daysPerWeek - getAdjustedWeekday(dateTime)));
  return DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
}

/// Find the first date of the week which contains the provided date.
String printFirstDateOfTheWeek(DateTime dateTime, {String format = "MMMMd"}) {
  return DateFormat(format).format(findFirstDateOfTheWeek(dateTime));
}

/// Find last date of the week which contains provided date.
String printLastDateOfTheWeek(DateTime dateTime, {String format = "MMMMd"}) {
  return DateFormat(format).format(findLastDateOfTheWeek(dateTime));
}
