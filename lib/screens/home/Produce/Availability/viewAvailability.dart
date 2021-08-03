import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:provider/provider.dart';

class ViewAvailability extends StatefulWidget {
  final WeeklyReport report;
  ViewAvailability({Key? key, required this.report}) : super(key: key);

  @override
  _ViewAvailabilityState createState() => _ViewAvailabilityState();
}

class _ViewAvailabilityState extends State<ViewAvailability> {
  final TextEditingController commentBox = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    if (widget.report.availability!.comments != null)
      commentBox.text = widget.report.availability!.comments!;
  }

  @override
  void dispose() {
    commentBox.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Produce Availability"),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                loading = true;
              });
              editAvailability().then((value) {
                FocusScope.of(context).unfocus();
                setState(() {
                  loading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Successfully updated!"),
                    duration: Duration(
                      seconds: 2,
                    )));
              });
            },
            backgroundColor: primaryGreen,
            elevation: 2,
            label: Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
            icon: !loading
                ? Icon(
                    Icons.edit,
                    color: Colors.white,
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
          ),
        ),
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.report.availability!.produce.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.report.availability!.produce[index].name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      horizontalSpaceTiny,
                      Text(
                          "${widget.report.availability!.produce[index].quantity} ${widget.report.availability!.produce[index].getMeasureUnits()}"),
                    ],
                  ),
                ));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: TextField(
                controller: commentBox,
                decoration: InputDecoration(
                    contentPadding: fieldContentPadding,
                    enabledBorder: fieldEnabledBorder,
                    focusedBorder: fieldFocusedBorder,
                    errorBorder: fieldErrorBorder,
                    labelText: 'Comments',
                    hintText: "Comments..."),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future editAvailability() async {
    final db = FirebaseFirestore.instance;
    String farmId = widget.report.farmId;
    final reportDoc = db
        .collection("weeklyReports")
        .doc("${widget.report.date.millisecondsSinceEpoch.toString()}$farmId");
    WriteBatch batch = db.batch();

    batch.update(reportDoc, {
      "availability.comments": commentBox.text,
      "updatedAt": DateTime.now()
    });

    return await batch.commit();
  }
}
