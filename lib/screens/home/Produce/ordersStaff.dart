import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/home/Produce/new_product_view.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/utils.dart';
import 'package:plant_it_forward/widgets/produce_search.dart';

class OrdersStaff extends StatefulWidget {
  const OrdersStaff({Key? key}) : super(key: key);

  @override
  _OrdersStaffState createState() => _OrdersStaffState();
}

class _OrdersStaffState extends State<OrdersStaff> {
  DateTime selectedDate = DateTime.now();

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
        children: [
          Container(
            width: double.infinity,
            child: Card(
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (weekNumber(DateTime.now()) != weekNumber(selectedDate))
                    TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: secondaryBlue,
                            elevation: 1,
                            backgroundColor: Colors.white,
                            onSurface: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8)),
                        onPressed: () => setState(() {
                              selectedDate = DateTime.now();
                            }),
                        label: Text("Today"),
                        icon: Icon(Icons.calendar_today)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            style: TextButton.styleFrom(
                                primary: secondaryBlue,
                                elevation: 1,
                                backgroundColor: Colors.white,
                                onSurface: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8)),
                            onPressed: () => showSearch(
                                context: context, delegate: ProduceSearch()),
                            label: Text("Search"),
                            icon: Icon(Icons.search)),
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
                                    builder: (context) => NewProductView())),
                            label: Text("Add"),
                            icon: Icon(Icons.add)),
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
}
