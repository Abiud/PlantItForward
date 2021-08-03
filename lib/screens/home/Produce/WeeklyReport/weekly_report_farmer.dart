import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/Availability/addAvailability.dart';
import 'package:plant_it_forward/screens/home/Produce/Availability/editAvailability.dart';
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
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          availabilityTitle(),
                          verticalSpaceSmall,
                          getProduceListCard(context, report!, "availability"),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order",
                          style: TextStyle(
                              color: LightColors.kDarkBlue,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2),
                        ),
                        verticalSpaceSmall,
                        if (Provider.of<WeeklyReport?>(context)!.order != null)
                          Container()
                        else
                          Text("No order has been placed.",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ))
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    width: double.infinity,
                    child: Padding(
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
                          getProduceListCard(context, report, "harvest")
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : emptyReport());
  }

  Widget emptyReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                availabilityTitle(),
                verticalSpaceSmall,
                Container(
                  height: 200,
                  child: Card(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AddAvailability(
                                    date: widget.dateSelected,
                                  ))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: secondaryBlue),
                            horizontalSpaceSmall,
                            Text(
                              "Add weekly availability",
                              style: TextStyle(
                                  color: secondaryBlue,
                                  fontWeight: FontWeight.w400),
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        verticalSpaceSmall,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order",
                style: TextStyle(
                    color: LightColors.kDarkBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2),
              ),
              verticalSpaceSmall,
              Text("No order has been placed.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ))
            ],
          ),
        ),
        verticalSpaceMedium,
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

  Widget availabilityTitle() {
    return Text(
      "Produce Availability",
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Widget getProduceListCard(
      BuildContext context, WeeklyReport report, String type) {
    if (type == "availability")
      return Container(
        height: 200,
        child: Card(
          child: Provider.of<WeeklyReport?>(context)!.availability != null
              ? InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAvailability(
                                availability: report.availability!,
                                date: report.date,
                              ))),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: Provider.of<WeeklyReport?>(context)!
                        .availability!
                        .produce
                        .length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              Provider.of<WeeklyReport?>(context)!
                                  .availability!
                                  .produce[index]
                                  .name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                            Text(Provider.of<WeeklyReport?>(context)!
                                .availability!
                                .produce[index]
                                .quantity
                                .toString()),
                            horizontalSpaceTiny,
                            Text(Provider.of<WeeklyReport?>(context)!
                                .availability!
                                .produce[index]
                                .getMeasureUnits())
                          ],
                        ),
                      );
                    },
                  ),
                )
              : InkWell(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddAvailability(
                                report: Provider.of<WeeklyReport?>(context)!,
                                date: widget.dateSelected,
                              ))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: secondaryBlue),
                        horizontalSpaceSmall,
                        Text(
                          "Add weekly availability",
                          style: TextStyle(
                              color: secondaryBlue,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                ),
        ),
      );
    else
      return Container(
        height: 200,
        child: Card(
          child: Provider.of<WeeklyReport?>(context)!.harvest != null
              ? InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAvailability(
                                availability: report.harvest!,
                                date: report.date,
                              ))),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: Provider.of<WeeklyReport?>(context)!
                        .harvest!
                        .produce
                        .length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              Provider.of<WeeklyReport?>(context)!
                                  .harvest!
                                  .produce[index]
                                  .name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                            Text(Provider.of<WeeklyReport?>(context)!
                                .harvest!
                                .produce[index]
                                .quantity
                                .toString()),
                            horizontalSpaceTiny,
                            Text(Provider.of<WeeklyReport?>(context)!
                                .harvest!
                                .produce[index]
                                .getMeasureUnits())
                          ],
                        ),
                      );
                    },
                  ),
                )
              : InkWell(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddAvailability(
                                report: report,
                                date: widget.dateSelected,
                              ))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: secondaryBlue),
                        horizontalSpaceSmall,
                        Text(
                          "Record weekly harvest",
                          style: TextStyle(
                              color: secondaryBlue,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                ),
        ),
      );
  }
}
