import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  String title = "";
  String description = "";

  late String _setTime, _setDate;
  late String _hour, _minute, _time;

  String strDate = DateFormat.yMd().format(DateTime.now());
  String strTime = formatDate(
      DateTime(2021, 08, 1, DateTime.now().hour, DateTime.now().minute),
      [hh, ':', nn, " ", am]).toString();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: "AddEvent",
          transitionBetweenRoutes: false,
          middle: Text("Add Event"),
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => print("hi"),
            elevation: 2,
            child: !loading
                ? Icon(Icons.save)
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: fieldContentPadding,
                              enabledBorder: fieldEnabledBorder,
                              focusedBorder: fieldFocusedBorder,
                              errorBorder: fieldErrorBorder,
                              labelText: 'Date',
                              hintText: "Date..."),
                          // initialValue: strDate,
                          onSaved: (val) {
                            _setDate = val!;
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: fieldContentPadding,
                              enabledBorder: fieldEnabledBorder,
                              focusedBorder: fieldFocusedBorder,
                              errorBorder: fieldErrorBorder,
                              labelText: 'Time',
                              hintText: "Time..."),
                          // initialValue: strDate,
                          onSaved: (val) {
                            _setTime = val!;
                          },
                        ),
                      ),
                      verticalSpaceMedium,
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Name',
                            hintText: "Lettuce"),
                        initialValue: title,
                        validator: (val) {
                          if (title.length > 0) {
                            return null;
                          }
                          return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      verticalSpaceMedium,
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Description',
                            hintText: "Description"),
                        initialValue: description,
                        validator: (val) {
                          // if (description.length > 0) {
                          //   return null;
                          // }
                          return null;
                          // return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          description = val;
                        },
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        strDate = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        strTime = _time;
        strTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
}
