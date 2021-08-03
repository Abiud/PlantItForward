import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/screens/home/Produce/WeeklyReport/weekly_report_farmer.dart';
import 'package:plant_it_forward/screens/home/Produce/WeeklyReport/weekly_report_staff.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:plant_it_forward/utils.dart';
import 'package:provider/provider.dart';

class WeeklyReportView extends StatefulWidget {
  const WeeklyReportView({Key? key}) : super(key: key);

  @override
  _WeeklyReportViewState createState() => _WeeklyReportViewState();
}

class _WeeklyReportViewState extends State<WeeklyReportView> {
  DateTime selectedDate = findFirstDateOfTheWeek(DateTime.now());

  void nextWeek() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: DateTime.daysPerWeek));
    });
  }

  void lastWeek() {
    setState(() {
      selectedDate =
          selectedDate.subtract(Duration(days: DateTime.daysPerWeek));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => lastWeek(),
                        icon: Icon(Icons.chevron_left)),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${printFirstDateOfTheWeek(selectedDate)} - ${printLastDateOfTheWeek(selectedDate)}",
                              style: TextStyle(
                                  color: LightColors.kDarkBlue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                                "Week ${weekNumber(selectedDate).toString()} of ${selectedDate.year}"),
                          ]),
                    ),
                    IconButton(
                        onPressed: () => nextWeek(),
                        icon: Icon(Icons.chevron_right)),
                  ],
                ),
              ),
            ),
          ),
          if (Provider.of<UserData>(context).isAdmin())
            StreamProvider<List<WeeklyReport>>.value(
                initialData: [],
                value: FirebaseFirestore.instance
                    .collection("weeklyReports")
                    .where("id",
                        isEqualTo:
                            selectedDate.millisecondsSinceEpoch.toString())
                    .snapshots()
                    .map((event) => event.docs
                        .map((e) => WeeklyReport.fromMap(e.data()))
                        .toList()),
                child: WeeklyReportStaff())
          else
            StreamProvider<WeeklyReport?>.value(
                initialData: null,
                value: FirebaseFirestore.instance
                    .collection("weeklyReports")
                    .doc(
                        "${selectedDate.millisecondsSinceEpoch.toString()}${Provider.of<UserData>(context).farmId!}")
                    .snapshots()
                    .map((event) {
                  if (event.data() != null)
                    return WeeklyReport.fromMap(event.data()!);
                }),
                child: WeeklyReportFarmer(dateSelected: selectedDate)),
        ],
      ),
    );
  }
}
