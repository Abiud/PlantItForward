import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/ProduceAvailability.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class ViewProduceList extends StatefulWidget {
  final WeeklyReport report;
  final ProduceAvailability list;
  final String type;
  ViewProduceList(
      {Key? key, required this.report, required this.list, required this.type})
      : super(key: key);

  @override
  _ViewProduceListState createState() => _ViewProduceListState();
}

class _ViewProduceListState extends State<ViewProduceList> {
  bool loading = false;
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
          title: Text(widget.report.farmName),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            verticalSpaceMedium,
            if (widget.type == "harvest")
              Text("Harvest",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))
            else if (widget.type == "order")
              Text("Order",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))
            else if (widget.type == "availability")
              Text("Produce Availability",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
            verticalSpaceSmall,
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.list.produce.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.list.produce[index].name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          horizontalSpaceTiny,
                          Text(
                              "${widget.list.produce[index].quantity} ${widget.list.produce[index].getMeasureUnits()}"),
                        ],
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
