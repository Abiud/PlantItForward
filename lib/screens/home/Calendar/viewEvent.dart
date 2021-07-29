import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/CalEvent.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Calendar/editEvent.dart';
import 'package:plant_it_forward/screens/home/Profile/viewProfile.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';
import 'package:plant_it_forward/widgets/task_column.dart';

class ViewEvent extends StatefulWidget {
  final CalEvent calEvent;
  const ViewEvent({Key? key, required this.calEvent}) : super(key: key);

  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  late CalEvent event;

  @override
  void initState() {
    super.initState();
    setState(() {
      event = widget.calEvent;
    });
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  String getFormattedDate() {
    // format start date and time as Month Day, Year Hours:Minutes AM/PM
    // Ex. July 10, 2021 5:00pm
    String start = DateFormat.yMMMMd().add_jm().format(event.startDateTime);
    if (event.startDate == event.endDate) {
      return start + " - " + DateFormat.jm().format(event.endDateTime!);
    }
    if (event.endDate != null) {
      return start +
          " - " +
          DateFormat.yMMMMd().add_jm().format(event.endDateTime!);
    }
    return start;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      // backgroundColor: LightColors.kLightYellow,
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: secondaryBlue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                )),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              event.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            child: Text(
                              event.userId,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black38,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // verticalSpaceSmall,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('Details'),
                            Row(children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: CircleBorder(),
                                    elevation: 1),
                                child: Icon(
                                  Icons.notifications_off,
                                  color: secondaryBlue,
                                ),
                                onPressed: () {},
                              ),
                              if (Provider.of(context)!.auth.currentUser!.id ==
                                  event.userId) ...[
                                horizontalSpaceSmall,
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
                                          builder: (context) =>
                                              EditEvent(calEvent: event))),
                                  label: Text("Edit"),
                                  icon: Icon(Icons.edit),
                                ),
                              ],
                            ]),
                          ],
                        ),
                        // SizedBox(height: 15.0),
                        verticalSpaceMedium,
                        TaskColumn(
                            icon: Icons.access_time,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Date',
                            subtitle: getFormattedDate()),
                        if (event.description != null) ...[
                          verticalSpaceMedium,
                          TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'Description',
                            subtitle: event.description,
                          ),
                        ],
                        verticalSpaceMedium,
                        if (event.needVolunteers) ...[
                          TaskColumn(
                            icon: Icons.people,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Volunteers',
                            subtitle:
                                'This event was marked as in need of volunteers.',
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: getVolunteerRegistrationButton(context)),
                          )
                        ],
                        if (event.volunteers != null) ...[
                          verticalSpaceTiny,
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            children: [
                              for (UserData volunteer in event.volunteers!)
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ViewProfile(
                                                userId: volunteer.id,
                                              ))),
                                  child: Chip(
                                      labelPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        child: Text(
                                            volunteer.name[0].toUpperCase()),
                                      ),
                                      label: Text(
                                        volunteer.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: LightColors.kBlue,
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.0, vertical: 8)),
                                )
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future registerVolunteer(BuildContext context) async {
    UserData user = Provider.of(context)!.auth.currentUser!;
    return await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .update({
      'volunteers': FieldValue.arrayUnion([
        {"name": user.name, "id": user.id}
      ])
    });
  }

  Future removeVolunteer(BuildContext context) async {
    UserData user = Provider.of(context)!.auth.currentUser!;
    final idx =
        event.volunteers!.indexWhere((element) => element.id == user.id);
    if (idx < 0) return Future.error("User not found in calEvent list");
    UserData dataToDelete = event.volunteers![idx];
    return await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .update({
      'volunteers': FieldValue.arrayRemove([
        {"name": dataToDelete.name, "id": dataToDelete.id}
      ])
    });
  }

  Widget getVolunteerRegistrationButton(BuildContext context) {
    Widget registerButton = TextButton.icon(
      style: TextButton.styleFrom(
          primary: secondaryBlue,
          elevation: 1,
          backgroundColor: Colors.white,
          onSurface: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      onPressed: () => registerVolunteer(context).then((value) => setState(() {
            event.volunteers!.add(Provider.of(context)!.auth.currentUser!);
          })),
      label: Text("I want to volunteer!"),
      icon: Icon(Icons.emoji_people),
    );
    Widget removeButton = TextButton.icon(
      style: TextButton.styleFrom(
          primary: secondaryBlue,
          elevation: 1,
          backgroundColor: Colors.white,
          onSurface: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      onPressed: () => removeVolunteer(context).then((value) => setState(() {
            event.volunteers!.removeWhere((element) =>
                element.id == Provider.of(context)!.auth.currentUser!.id);
          })),
      label: Text("Remove from list!"),
      icon: Icon(Icons.remove),
    );
    if (event.volunteers == null) return registerButton;
    if (event.volunteers!.isEmpty) return registerButton;
    for (UserData item in event.volunteers!) {
      if (item.id == Provider.of(context)!.auth.currentUser!.id)
        return removeButton;
    }
    return registerButton;
  }
}
