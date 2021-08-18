import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/addProduceList.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/editProduceList.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/viewInvoice.dart';
import 'package:plant_it_forward/screens/home/Produce/shared/viewProduceList.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class WeeklyReportStaff extends StatelessWidget {
  const WeeklyReportStaff({Key? key}) : super(key: key);

  bool isUpperEdge(int index) {
    return index == 0;
  }

  bool isLowerEdge(int index) {
    return index == 3;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: Provider.of<List<WeeklyReport>>(context).length,
        itemBuilder: (context, index) {
          WeeklyReport report = Provider.of<List<WeeklyReport>>(context)[index];
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.farmName,
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (report.updatedAt != null)
                          Column(
                            children: [
                              Text(
                                "Last update",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              Text(
                                dateF.format(report.updatedAt!),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FixedTimeline.tileBuilder(
                        theme: TimelineTheme.of(context).copyWith(
                          nodePosition: 0,
                        ),
                        builder: TimelineTileBuilder(
                          itemCount: 4,
                          indicatorBuilder: (_, index) =>
                              getIndicator(report, index),
                          startConnectorBuilder: (_, index) =>
                              !isUpperEdge(index)
                                  ? Connector.solidLine()
                                  : null,
                          endConnectorBuilder: (_, index) => !isLowerEdge(index)
                              ? Connector.solidLine()
                              : null,
                          contentsBuilder: (_, index) =>
                              getContent(context, report, index),
                          itemExtent: 60,
                        )),
                  )
                ],
              ),
            ),
          );
        },
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

  Widget getContent(BuildContext context, WeeklyReport rep, int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Availability",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    rep.availability != null
                        ? Text("${rep.availability!.produce.length} items",
                            style: TextStyle(color: Colors.grey.shade800))
                        : Text(
                            "Not submitted",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                  ],
                ),
              ),
              if (rep.availability != null) ...[
                horizontalSpaceTiny,
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ViewProduceList(
                                report: rep,
                                list: rep.availability!,
                                type: "availability",
                              ))),
                  child: Text("View"),
                )
              ]
            ],
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    rep.order != null
                        ? Text("${rep.order!.produce.length} items",
                            style: TextStyle(color: Colors.grey.shade800))
                        : Text(
                            "Not submitted",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                  ],
                ),
              ),
              horizontalSpaceTiny,
              OutlinedButton(
                onPressed: () {
                  if (rep.order != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProduceList(
                                  list: rep.order!,
                                  report: rep,
                                  type: "order",
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProduceList(
                                  report: rep,
                                  date: rep.id,
                                  type: "order",
                                )));
                  }
                },
                child: Text("Set"),
              )
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Harvest",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    rep.harvest != null
                        ? Text("${rep.harvest!.produce.length} items",
                            style: TextStyle(color: Colors.grey.shade800))
                        : Text(
                            "Not submitted",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                  ],
                ),
              ),
              if (rep.harvest != null) ...[
                horizontalSpaceTiny,
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProduceList(
                                list: rep.harvest!,
                                report: rep,
                                type: "harvest",
                              ))),
                  child: Text("Edit"),
                ),
                horizontalSpaceTiny,
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ViewProduceList(
                                report: rep,
                                list: rep.harvest!,
                                type: "harvest",
                              ))),
                  child: Text("View"),
                )
              ] else ...[
                horizontalSpaceTiny,
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddProduceList(
                                report: rep,
                                date: rep.id,
                                type: "harvest",
                              ))),
                  child: Text("Record"),
                )
              ]
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Harvest Approved",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    if (rep.harvest != null)
                      rep.harvest!.approved == true
                          ? Text("Harvest has been approved",
                              style: TextStyle(color: Colors.grey.shade800))
                          : Text(
                              "Purchased produce",
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                    else
                      Text(
                        "Not submitted",
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                  ],
                ),
              ),
              if (rep.harvest != null) ...[
                horizontalSpaceTiny,
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              ViewInvoice(report: rep, harvest: rep.harvest!))),
                  child: Text("View"),
                )
              ]
            ],
          ),
        );
    }
    return Container();
  }
}
