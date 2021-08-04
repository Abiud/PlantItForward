import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/ProduceAvailability.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/addProduceList.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/editProduceList.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:provider/provider.dart';

class WeeklyReportFarmer extends StatefulWidget {
  final DateTime dateSelected;
  const WeeklyReportFarmer({Key? key, required this.dateSelected})
      : super(key: key);

  @override
  _WeeklyReportFarmerState createState() => _WeeklyReportFarmerState();
}

class _WeeklyReportFarmerState extends State<WeeklyReportFarmer> {
  @override
  Widget build(BuildContext context) {
    WeeklyReport? report = Provider.of<WeeklyReport?>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Provider.of<WeeklyReport?>(context) != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getProduceListCard(
                      context,
                      "Produce Availability",
                      "Add Weekly Availability",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProduceList(
                                    list: report!.availability!,
                                    date: report.date,
                                    type: "availability",
                                  ))),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProduceList(
                                    date: widget.dateSelected,
                                    type: "availability",
                                  ))),
                      report!.availability),
                  verticalSpaceSmall,
                  getProduceListCard(
                      context,
                      "Order",
                      "No order has been placed",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProduceList(
                                    list: report.order!,
                                    date: report.date,
                                    type: "order",
                                  ))),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProduceList(
                                    date: widget.dateSelected,
                                    type: "order",
                                  ))),
                      report.order),
                  verticalSpaceSmall,
                  getProduceListCard(
                      context,
                      "Harvest",
                      "Add Weekly Harvest",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProduceList(
                                    list: report.harvest!,
                                    date: report.date,
                                    type: "harvest",
                                  ))),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProduceList(
                                    report: report,
                                    date: widget.dateSelected,
                                    type: "harvest",
                                  ))),
                      report.harvest),
                ],
              )
            : emptyReport());
  }

  Widget emptyReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getProduceListCard(
            context,
            "Produce Availability",
            "Add Weekly Availability",
            null,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProduceList(
                          date: widget.dateSelected,
                          type: "availability",
                        ))),
            null),
        verticalSpaceSmall,
        getProduceListCard(
            context, "Order", "No order has been placed", null, null, null),
        verticalSpaceSmall,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Harvest",
                style: TextStyle(
                    color: LightColors.kDarkBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2),
              ),
              verticalSpaceSmall,
              Text("No harvest has been recorded.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget cardTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget getProduceListCard(
      BuildContext context,
      String title,
      String emptyPrompt,
      Future<dynamic> Function()? editRoute,
      Future<dynamic> Function()? addRoute,
      ProduceAvailability? step) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardTitle(title),
              Divider(
                height: 1,
              ),
              Expanded(
                child: step != null
                    ? InkWell(
                        onTap: editRoute,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          itemCount: step.produce.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    step.produce[index].name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  Text(step.produce[index].quantity.toString()),
                                  horizontalSpaceTiny,
                                  Text(step.produce[index].getMeasureUnits())
                                ],
                              ),
                            );
                          },
                        ))
                    : title == "Order"
                        ? Center(
                            child: Text(emptyPrompt,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                )),
                          )
                        : InkWell(
                            onTap: addRoute,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: secondaryBlue),
                                  horizontalSpaceSmall,
                                  Text(
                                    emptyPrompt,
                                    style: TextStyle(
                                        color: secondaryBlue,
                                        fontWeight: FontWeight.w400),
                                  )
                                ]),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
