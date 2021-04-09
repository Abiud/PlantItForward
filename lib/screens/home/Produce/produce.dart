import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/screens/home/Produce/new_product_view.dart';
import 'package:plant_it_forward/widgets/swipeDetector.dart';
import 'package:plant_it_forward/screens/home/Produce/price.dart';

class Produce extends StatefulWidget {
  const Produce({Key key}) : super(key: key);

  @override
  _ProduceState createState() => _ProduceState();
}

class _ProduceState extends State<Produce> {
  int segmentedControlGroupValue = 0;

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text(
      "Orders",
    ),
    1: Text("Available"),
    2: Text("Prices")
  };

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeLeft: () {
        setState(() {
          if (segmentedControlGroupValue < 2) {
            segmentedControlGroupValue++;
          }
        });
      },
      onSwipeRight: () {
        setState(() {
          if (segmentedControlGroupValue > 0) {
            segmentedControlGroupValue--;
          }
        });
      },
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            heroTag: 'produce', // a different string for each navigationBar
            transitionBetweenRoutes: false,
            middle: CupertinoSlidingSegmentedControl(
                groupValue: segmentedControlGroupValue,
                children: myTabs,
                onValueChanged: (i) {
                  setState(() {
                    segmentedControlGroupValue = i;
                  });
                }),
            trailing: segmentedControlGroupValue == 2
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      CupertinoIcons.add,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => NewProductView()));
                    },
                  )
                : SizedBox(),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: Center(
                child: Builder(builder: (context) {
                  switch (segmentedControlGroupValue) {
                    case 0:
                      return Text("Orders");
                    case 1:
                      return Text("Available");
                    case 2:
                      return Price();
                    default:
                      return Text("Orders");
                  }
                }),
                //   ],
                // ),
              ),
            ),
          )),
    );
  }
}
