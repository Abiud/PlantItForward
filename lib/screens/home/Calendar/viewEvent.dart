import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/CalEvent.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Calendar/calendar.dart';
import 'package:plant_it_forward/screens/home/Calendar/editEvent.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';
import 'package:plant_it_forward/widgets/task_column.dart';
import 'package:plant_it_forward/widgets/top_container.dart';

class ViewEvent extends StatelessWidget {
  final CalEvent calEvent;
  const ViewEvent({Key? key, required this.calEvent}) : super(key: key);

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
    String start = DateFormat.yMMMMd().add_jm().format(calEvent.startDateTime);
    if (calEvent.startDate == calEvent.endDate) {
      return start + " - " + DateFormat.jm().format(calEvent.endDateTime!);
    }
    if (calEvent.endDate != null) {
      return start +
          " - " +
          DateFormat.yMMMMd().add_jm().format(calEvent.endDateTime!);
    }
    return start;
  }

  static CircleAvatar alertIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.notifications,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 180,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back,
                                color: Colors.white, size: 30.0)),
                        // Icon(Icons.search, color: Colors.white, size: 25.0),
                        if (Provider.of(context)!.auth.currentUser.id ==
                            calEvent.userId)
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        EditEvent(calEvent: calEvent))),
                            child: Text("Edit"),
                            style: TextButton.styleFrom(
                                primary: secondaryBlue,
                                elevation: 1,
                                backgroundColor: Colors.white,
                                onSurface: Colors.white),
                          )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
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
                                    calEvent.title,
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
                                    calEvent.userId,
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
                    )
                  ]),
            ),
            // verticalSpaceSmall,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('Details'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalendarScreen()),
                                  );
                                },
                                child: alertIcon(),
                              ),
                            ],
                          ),
                          // SizedBox(height: 15.0),
                          verticalSpaceMedium,
                          TaskColumn(
                              icon: Icons.access_time,
                              iconBackgroundColor: LightColors.kRed,
                              title: 'Date',
                              subtitle: getFormattedDate()),
                          if (calEvent.description != null) ...[
                            verticalSpaceMedium,
                            TaskColumn(
                              icon: Icons.blur_circular,
                              iconBackgroundColor: LightColors.kDarkYellow,
                              title: 'Description',
                              subtitle: calEvent.description,
                            ),
                          ],
                          verticalSpaceMedium,
                          TaskColumn(
                            icon: Icons.people,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Volunteers',
                            subtitle:
                                'This event was marked as in need of volunteers.',
                          ),
                          if (calEvent.volunteers != null) ...[
                            verticalSpaceSmall,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 240,
                                        childAspectRatio: 3.4,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 1),
                                itemCount: calEvent.volunteers!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  UserData volunteer =
                                      calEvent.volunteers![index];
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Chip(
                                        labelPadding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        avatar: CircleAvatar(
                                          backgroundColor: Colors.white70,
                                          child: Text(
                                              volunteer.name![0].toUpperCase()),
                                        ),
                                        label: Text(
                                          volunteer.name!,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.indigo,
                                        elevation: 2,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8)),
                                  );
                                },
                              ),
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
      ),
    );
  }
}
