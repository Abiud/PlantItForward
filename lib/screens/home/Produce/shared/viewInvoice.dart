import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/Models/WeeklyReport.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class ViewInvoice extends StatefulWidget {
  final WeeklyReport report;
  ViewInvoice({Key? key, required this.report}) : super(key: key);

  @override
  _ViewInvoiceState createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  final Currency usdCurrency = Currency.create('USD', 2);
  List<TextEditingController> _quantityControllers = [];
  List<TextEditingController> _priceControllers = [];
  List<Product> produce = [];
  bool loading = false;
  bool loadingResults = false;

  @override
  void initState() {
    super.initState();
    produce = widget.report.harvest!.produce;
    for (Product prod in produce) {
      _quantityControllers
          .add(new TextEditingController(text: prod.quantity.toString()));
      _priceControllers
          .add(new TextEditingController(text: prod.price.toString()));
    }
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
          title: Text(widget.report.farmName),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                loading = true;
              });
              saveInvoice().then((value) {
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
              "Save",
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
          padding: EdgeInsets.symmetric(horizontal: 12),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            verticalSpaceMedium,
            Row(
              children: [
                Expanded(
                  child: Text("Produce Purchased",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                ),
                Text(
                  DateFormat.yMMMMd().format(widget.report.date),
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ],
            ),
            verticalSpaceSmall,
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: produce.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  produce[index].name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 35,
                                    child: TextField(
                                      onTap: () => _quantityControllers[index]
                                              .selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _quantityControllers[index]
                                                      .value
                                                      .text
                                                      .length),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          isDense: true),
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      controller: _quantityControllers[index],
                                      onChanged: (val) {
                                        setState(() {
                                          produce[index].quantity =
                                              int.parse(val);
                                        });
                                      },
                                    ),
                                  ),
                                  horizontalSpaceTiny,
                                  Text("${produce[index].getMeasureUnits()}"),
                                ],
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 55,
                                      child: TextField(
                                        onTap: () => _priceControllers[index]
                                                .selection =
                                            TextSelection(
                                                baseOffset:
                                                    _priceControllers[index]
                                                        .value
                                                        .text
                                                        .length,
                                                extentOffset:
                                                    _priceControllers[index]
                                                        .value
                                                        .text
                                                        .length),
                                        inputFormatters: [
                                          CurrencyTextInputFormatter(
                                              symbol: '\$')
                                        ],
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4),
                                            isDense: true),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _priceControllers[index],
                                        onChanged: (val) {
                                          setState(() {
                                            produce[index].price = usdCurrency
                                                .parse(_priceControllers[index]
                                                    .text);
                                          });
                                        },
                                      ),
                                    ),
                                    horizontalSpaceTiny,
                                    Text(
                                      "${produce[index].measure}",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              Text("Total: ${getMult(produce[index])}")
                            ],
                          ),
                        ],
                      ),
                    ));
              },
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Total: ${getTotal()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Container(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  String getMult(Product prod) {
    Money? total = prod.price! * prod.quantity!;
    return total.toString();
  }

  Money getMultMoney(Product prod) {
    return prod.price! * prod.quantity!;
  }

  String getTotal() {
    Money total = Money.fromString("\$0.00", usdCurrency);
    for (Product prod in produce) {
      total = getMultMoney(prod) + total;
    }
    return total.toString();
  }

  Future saveInvoice() async {
    final db = FirebaseFirestore.instance;
    String farmId = widget.report.farmId;
    final reportDoc = db
        .collection("weeklyReports")
        .doc("${widget.report.date.millisecondsSinceEpoch.toString()}$farmId");
    WriteBatch batch = db.batch();
    List<Map<String, dynamic>> prods = [];
    for (Product prod in produce) {
      prods.add(prod.toMap());
    }

    batch.set(
        reportDoc,
        {
          "invoice": {"produce": prods, "createdAt": DateTime.now()},
          "harvest": {"approved": true},
          "updatedAt": DateTime.now()
        },
        SetOptions(merge: true));

    return await batch.commit();
  }
}
