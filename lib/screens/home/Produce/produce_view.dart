import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/app/app.locator.dart';
import 'package:plant_it_forward/screens/home/Produce/prices_view.dart';
import 'package:plant_it_forward/viewmodels/produce_view_model.dart';
import 'package:stacked/stacked.dart';

class ProduceView extends StatelessWidget {
  const ProduceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProduceViewModel>.reactive(
        disposeViewModel: false,
        // Inidicate that we only want to initialise a specialty viewmodel once
        initialiseSpecialViewModelsOnce: true,
        builder: (context, model, child) => DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                // backgroundColor: Colors.white,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          text: "Orders",
                        ),
                        Tab(
                          text: "Available",
                        ),
                        Tab(
                          text: "Prices",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Center(
                    child: Text("orders"),
                  ),
                  Center(
                    child: Text("available"),
                  ),
                  PricesView()
                ],
              ),
            )),
        viewModelBuilder: () => locator<ProduceViewModel>());
  }
}
