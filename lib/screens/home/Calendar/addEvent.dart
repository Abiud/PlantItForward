import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

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
  bool needVolunteers = false;

  late String _setTimeStart, _setDateStart, _setTimeEnd, _setDateEnd;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay(hour: 00, minute: 00);
  DateTime? selectedDateEnd;
  TimeOfDay? selectedTimeEnd;

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
            elevation: 2,
            child: !loading
                ? Icon(Icons.save)
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
            onPressed: () {
              if (!loading) {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    loading = true;
                  });
                  createEvent(context).then((val) async {
                    print(val.id);
                    setState(() {
                      loading = false;
                    });
                  });
                }
              }
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _selectDate(context, true);
                              },
                              child: TextFormField(
                                  enabled: false,
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                    contentPadding: fieldContentPadding,
                                    enabledBorder: fieldEnabledBorder,
                                    focusedBorder: fieldFocusedBorder,
                                    errorBorder: fieldErrorBorder,
                                    disabledBorder: fieldEnabledBorder,
                                    labelText: 'Start date',
                                  ),
                                  // initialValue: strDate,
                                  onSaved: (val) {
                                    _setDateStart = val!;
                                  },
                                  validator: (val) {
                                    if (val == "")
                                      return "Start date is requierd";
                                    return null;
                                  }),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _selectTime(context, true);
                              },
                              child: TextFormField(
                                  enabled: false,
                                  controller: _startTimeController,
                                  decoration: InputDecoration(
                                      contentPadding: fieldContentPadding,
                                      enabledBorder: fieldEnabledBorder,
                                      focusedBorder: fieldFocusedBorder,
                                      errorBorder: fieldErrorBorder,
                                      disabledBorder: fieldEnabledBorder,
                                      labelText: 'Start time'),
                                  // initialValue: strDate,
                                  onSaved: (val) {
                                    _setTimeStart = val!;
                                  },
                                  validator: (val) {
                                    print(val);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Text(
                        "To",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalSpaceSmall,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context, false);
                                },
                                child: TextFormField(
                                  enabled: false,
                                  controller: _endDateController,
                                  decoration: InputDecoration(
                                    contentPadding: fieldContentPadding,
                                    enabledBorder: fieldEnabledBorder,
                                    focusedBorder: fieldFocusedBorder,
                                    errorBorder: fieldErrorBorder,
                                    disabledBorder: fieldEnabledBorder,
                                    labelText: 'End date',
                                  ),
                                  // initialValue: strDate,
                                  onSaved: (val) {
                                    _setDateEnd = val!;
                                  },
                                ),
                              ),
                            ),
                            horizontalSpaceSmall,
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  _selectTime(context, false);
                                },
                                child: TextFormField(
                                  enabled: false,
                                  controller: _endTimeController,
                                  decoration: InputDecoration(
                                      contentPadding: fieldContentPadding,
                                      enabledBorder: fieldEnabledBorder,
                                      focusedBorder: fieldFocusedBorder,
                                      errorBorder: fieldErrorBorder,
                                      disabledBorder: fieldEnabledBorder,
                                      labelText: 'End time'),
                                  // initialValue: strDate,
                                  onSaved: (val) {
                                    _setTimeEnd = val!;
                                  },
                                ),
                              ),
                            ),
                          ]),
                      verticalSpaceMedium,
                      Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalSpaceSmall,
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: fieldContentPadding,
                            enabledBorder: fieldEnabledBorder,
                            focusedBorder: fieldFocusedBorder,
                            errorBorder: fieldErrorBorder,
                            labelText: 'Title',
                            hintText: "Title..."),
                        initialValue: title,
                        validator: (val) {
                          if (title.length > 0) {
                            return null;
                          }
                          return "Title cannot be empty";
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
                            hintText: "Description..."),
                        initialValue: description,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
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
                      CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Text("Need volunteers?"),
                          subtitle: Text(
                              "If this box is checked volunteers will be able to sign up to help."),
                          value: needVolunteers,
                          onChanged: (val) {
                            setState(() {
                              needVolunteers = val!;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isStartDate ? selectedDateStart : selectedDateEnd!,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      if (isStartDate)
        setState(() {
          selectedDateStart = picked;
          _startDateController.text =
              DateFormat.yMd().format(selectedDateStart);
        });
      else
        setState(() {
          selectedDateEnd = picked;
          _endDateController.text = DateFormat.yMd().format(selectedDateEnd!);
        });
    }
  }

  Future<Null> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? selectedTimeStart : selectedTimeEnd!,
    );
    if (picked != null) if (isStartTime)
      setState(() {
        selectedTimeStart = picked;
        _startTimeController.text = selectedTimeStart.hour.toString() +
            ' : ' +
            selectedTimeStart.minute.toString();
        _startTimeController.text = formatDate(
            DateTime(
                2019, 08, 1, selectedTimeStart.hour, selectedTimeStart.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    else
      setState(() {
        selectedTimeEnd = picked;
        _endTimeController.text = selectedTimeEnd!.hour.toString() +
            ' : ' +
            selectedTimeEnd!.minute.toString();
        _endTimeController.text = formatDate(
            DateTime(
                2019, 08, 1, selectedTimeEnd!.hour, selectedTimeEnd!.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future createEvent(context) async {
    final collection = FirebaseFirestore.instance.collection('events');
    final AuthService auth = Provider.of(context)!.auth;

    return await collection.add({
      "startDateTime": DateTime(
          selectedDateStart.year,
          selectedDateStart.month,
          selectedDateStart.day,
          selectedTimeStart.hour,
          selectedTimeStart.minute),
      "endDateTime": selectedDateEnd != null
          ? DateTime(
              selectedDateEnd!.year,
              selectedDateEnd!.month,
              selectedDateEnd!.day,
              selectedTimeEnd!.hour,
              selectedTimeEnd!.minute)
          : null,
      "endDate": selectedDateEnd,
      "startDate": selectedDateStart,
      "needVolunteers": needVolunteers,
      "title": title,
      "description": description,
      "userId": auth.currentUser.id,
    });
  }
}