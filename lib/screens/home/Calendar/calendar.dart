import 'dart:collection';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/CalEvent.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Calendar/addEvent.dart';
import 'package:plant_it_forward/screens/home/Calendar/viewEvent.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/utils.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool loadingEvents = true;
  List<CalEvent> todayEvents = [];
  LinkedHashMap<DateTime, List<CalEvent>> _groupedEvents =
      LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: fontWeight);
  }

  late DateTime today;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    firstDate = beginingOfDay(DateTime(today.year, today.month, 1));
    lastDate = endOfDay(lastDayOfMonth(today));
  }

  _groupEvents(List<CalEvent> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(
          event.startDate.year, event.startDate.month, event.startDate.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    });
  }

  _getEventsForDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: DatabaseService(uid: Provider.of<UserData>(context).id)
              .eventCollection
              .where("startDate", isGreaterThanOrEqualTo: firstDate)
              .where("startDate", isLessThanOrEqualTo: lastDate)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final events = snapshot.data!.docs
                  .map((e) => CalEvent.fromSnapshot(
                      e.id, e.data() as Map<String, dynamic>))
                  .toList();
              _groupEvents(events);
              DateTime selectedDate = _selectedDay;
              final _selectedEvents = _groupedEvents[selectedDate] ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                      firstDay: kFirstDay,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      calendarStyle: CalendarStyle(
                          weekendTextStyle: dayStyle(FontWeight.normal),
                          defaultTextStyle: dayStyle(FontWeight.normal),
                          markersMaxCount: 3,
                          selectedDecoration: BoxDecoration(
                              color: secondaryBlue, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(
                              color: Color(0xa905808B),
                              shape: BoxShape.circle)),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: Color(0xff30384c),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        weekendStyle: TextStyle(
                            color: Color(0xffcd5c5c),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      headerStyle: HeaderStyle(
                          titleCentered: true,
                          headerPadding: EdgeInsets.symmetric(vertical: 12.0),
                          formatButtonVisible: false,
                          titleTextStyle: TextStyle(
                              color: Color(0xff30384c),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          leftChevronIcon: Icon(Icons.chevron_left,
                              color: Color(0xff30384c)),
                          rightChevronIcon: Icon(Icons.chevron_right,
                              color: Color(0xff30384c))),
                      onCalendarCreated: (controller) =>
                          _pageController = controller,
                      onHeaderTapped: (day) {
                        _selectDate(context);
                      },
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          // Call `setState()` when updating calendar format
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        // No need to call `setState()` here
                        _focusedDay = focusedDay;
                        setState(() {
                          firstDate = beginingOfDay(
                              DateTime(_focusedDay.year, _focusedDay.month, 1));
                          lastDate = endOfDay(lastDayOfMonth(_focusedDay));
                        });
                      },
                      calendarBuilders: CalendarBuilders()),
                  verticalSpaceSmall,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondaryBlue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, top: 18, right: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat('EEEE, dd MMMM, yyyy')
                                          .format(selectedDate),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                        primary: secondaryBlue,
                                        elevation: 1,
                                        backgroundColor: Colors.white,
                                        onSurface: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8)),
                                    onPressed: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => AddEvent())),
                                    label: Text("Add"),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              )),
                          verticalSpaceSmall,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _selectedEvents.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  child: OpenContainer(
                                      transitionType:
                                          ContainerTransitionType.fadeThrough,
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      closedBuilder: (BuildContext _,
                                          VoidCallback openContainer) {
                                        return ListTile(
                                          onTap: openContainer,
                                          title: Text(
                                              _selectedEvents[index].title,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                DateFormat("hh:mm a").format(
                                                    _selectedEvents[index]
                                                        .startDateTime),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                              if (_selectedEvents[index]
                                                      .endDate !=
                                                  null) ...[
                                                Text(
                                                  " - ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  DateFormat("hh:mm a").format(
                                                      _selectedEvents[index]
                                                          .endDateTime!),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ],
                                              horizontalSpaceSmall,
                                              Expanded(
                                                  child: Text(
                                                      _selectedEvents[index]
                                                          .userId,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ),
                                        );
                                      },
                                      openBuilder:
                                          (BuildContext _, VoidCallback __) {
                                        return ViewEvent(
                                            calEvent: _selectedEvents[index]);
                                      }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Loading();
          },
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _focusedDay,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: kFirstDay,
        lastDate: kLastDay);
    if (picked != null) {
      int yearDiff = picked.year - kFirstDay.year;
      _pageController.jumpToPage(12 * yearDiff + picked.month - 1);
      setState(() {
        _selectedDay = picked;
      });
    }
  }
}
