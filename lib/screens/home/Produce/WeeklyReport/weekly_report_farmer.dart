import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/ProduceAvailability.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/addProduceList.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/editProduceList.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/viewProduceList.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

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
    return Container(
      height: 670,
      child: Provider.of<WeeklyReport?>(context) != null
          ? Timeline.tileBuilder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
              ),
              builder: TimelineTileBuilder(
                itemCount: 4,
                indicatorBuilder: (_, index) => getIndicator(report!, index),
                startConnectorBuilder: (_, index) =>
                    !isUpperEdge(index) ? Connector.solidLine() : null,
                endConnectorBuilder: (_, index) =>
                    !isLowerEdge(index) ? Connector.solidLine() : null,
                contentsBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: getContents(context, report!, index),
                  );
                },
                itemExtentBuilder: (_, index) => index == 3 ? 100 : 200,
                // itemExtent: 220,
              ))
          : emptyReport(),
    );
  }

  Widget emptyReport() {
    return Container(
      height: 670,
      child: Timeline.tileBuilder(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          theme: TimelineTheme.of(context).copyWith(
            nodePosition: 0,
          ),
          builder: TimelineTileBuilder(
            itemCount: 4,
            indicatorBuilder: (_, index) => Indicator.outlined(
              borderWidth: 2.0,
              size: 30,
            ),
            startConnectorBuilder: (_, index) =>
                !isUpperEdge(index) ? Connector.solidLine() : null,
            endConnectorBuilder: (_, index) =>
                !isLowerEdge(index) ? Connector.solidLine() : null,
            contentsBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: getEmptyContents(context, index),
              );
            },
            itemExtentBuilder: (_, index) => index == 3 ? 100 : 200,
            // itemExtent: 220,
          )),
    );
  }

  Widget? getEmptyContents(BuildContext context, int index) {
    switch (index) {
      case 0:
        return getProduceListCard(
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
            null);
      case 1:
        return getProduceListCard(
            context, "Order", "No order has been placed", null, null, null);
      case 2:
        return getProduceListCard(context, "Harvest",
            "No harvest has been recorded.", null, null, null);
      case 3:
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardTitle("Harvest Approved"),
              Text("Harvest hasn't been recorded."),
            ],
          ),
        );
    }
  }

  Widget cardTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
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
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: cardTitle(title),
            ),
            Divider(
              color: Colors.grey.shade400,
              height: 1.5,
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
    );
  }

  Widget getIndicator(WeeklyReport rep, int index) {
    Widget indicatorOutline = Indicator.outlined(
      borderWidth: 2.0,
      size: 30,
    );
    switch (index) {
      case 0:
        if (rep.availability != null) return Indicator.dot(size: 30);
        return indicatorOutline;
      case 1:
        if (rep.order != null)
          return Indicator.dot(
            size: 30,
          );
        return indicatorOutline;
      case 2:
        if (rep.harvest != null) return Indicator.dot(size: 30);
        return indicatorOutline;
      case 3:
        if (rep.harvest != null) {
          if (rep.harvest!.approved == true)
            return Indicator.dot(
                size: 30,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ));
        }
        return indicatorOutline;
      default:
        return indicatorOutline;
    }
  }

  bool isUpperEdge(int index) {
    return index == 0;
  }

  bool isLowerEdge(int index) {
    return index == 3;
  }

  Widget getContents(BuildContext context, WeeklyReport report, int index) {
    switch (index) {
      case 0:
        return getProduceListCard(
            context,
            "Produce Availability",
            "Add Weekly Availability",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProduceList(
                          list: report.availability!,
                          report: report,
                          type: "availability",
                        ))),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProduceList(
                          date: widget.dateSelected,
                          type: "availability",
                        ))),
            report.availability);
      case 1:
        return getProduceListCard(
            context,
            "Order",
            "No order has been placed",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewProduceList(
                          report: report,
                          list: report.order!,
                          type: "order",
                        ))),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProduceList(
                          date: widget.dateSelected,
                          type: "order",
                        ))),
            report.order);
      case 2:
        return getProduceListCard(
            context,
            "Harvest",
            "Add Weekly Harvest",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProduceList(
                          list: report.harvest!,
                          report: report,
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
            report.harvest);
      case 3:
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardTitle("Harvest Approved"),
              finalStep(report),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget finalStep(WeeklyReport report) {
    if (report.harvest != null) {
      if (report.harvest!.approved == true)
        return Text("Harvest has been approved!");
      return Text("Harvest Pending approval");
    }
    return Text("Harvest hasn't been recorded.");
  }
}
