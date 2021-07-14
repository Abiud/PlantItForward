import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it_forward/Models/CalEvent.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class EditEvent extends StatefulWidget {
  final CalEvent calEvent;
  const EditEvent({Key? key, required this.calEvent}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  late String _setTimeStart, _setDateStart, _setTimeEnd, _setDateEnd;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDateEnd = DateTime.now();
  TimeOfDay selectedTimeEnd = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    super.initState();
    setDateTimeInputs();
  }

  void setDateTimeInputs() {
    DateTime sDate = widget.calEvent.startDateTime;
    DateTime? eDate = widget.calEvent.endDateTime;

    _startDateController.text = DateFormat.yMd().format(sDate);
    _startTimeController.text = formatDate(
        DateTime(2019, 08, 1, sDate.hour, sDate.minute),
        [hh, ':', nn, " ", am]).toString();
    selectedDateStart = sDate;
    selectedTimeStart = TimeOfDay.fromDateTime(sDate);

    if (eDate != null) {
      _endDateController.text = DateFormat.yMd().format(eDate);
      _endTimeController.text = formatDate(
          DateTime(2019, 08, 1, eDate.hour, eDate.minute),
          [hh, ':', nn, " ", am]).toString();
      selectedDateEnd = eDate;
      selectedTimeEnd = TimeOfDay.fromDateTime(eDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: "ViewEvent",
          transitionBetweenRoutes: false,
          middle: Text("View Event"),
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
                  editEvent(context).then((val) async {
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                        initialValue: widget.calEvent.title,
                        validator: (val) {
                          if (widget.calEvent.title.length > 0) {
                            return null;
                          }
                          return "Title cannot be empty";
                        },
                        onChanged: (val) {
                          widget.calEvent.title = val;
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
                        initialValue: widget.calEvent.description,
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
                          widget.calEvent.description = val;
                        },
                      ),
                      if (widget.calEvent.needVolunteers == true) ...[
                        verticalSpaceMedium,
                        Text("This event was marked as accepting volunteers")
                      ],
                      if (widget.calEvent.volunteers != null) ...[
                        verticalSpaceMedium,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.calEvent.volunteers!.length,
                          itemBuilder: (BuildContext context, int index) {
                            UserData volunteer =
                                widget.calEvent.volunteers![index];
                            return Card(
                              child: InkWell(
                                splashColor: primaryGreen.withAlpha(30),
                                // onTap: () {
                                //   Navigator.push(
                                //       context,
                                //       CupertinoPageRoute(
                                //           builder: (context) => ViewEvent(
                                //               calEvent: _selectedEvents[index])));
                                // },
                                child: ListTile(
                                  title: Text(volunteer.name!,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  subtitle: Text(volunteer.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ]
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
        initialDate: isStartDate ? selectedDateStart : selectedDateEnd,
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
          _endDateController.text = DateFormat.yMd().format(selectedDateEnd);
        });
    }
  }

  Future<Null> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? selectedTimeStart : selectedTimeEnd,
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
        _endTimeController.text = selectedTimeEnd.hour.toString() +
            ' : ' +
            selectedTimeEnd.minute.toString();
        _endTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTimeEnd.hour, selectedTimeEnd.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future editEvent(context) async {
    final eventDoc =
        FirebaseFirestore.instance.collection('events').doc(widget.calEvent.id);
    final AuthService auth = Provider.of(context)!.auth;

    return await eventDoc.update({
      "startDateTime": DateTime(
          selectedDateStart.year,
          selectedDateStart.month,
          selectedDateStart.day,
          selectedTimeStart.hour,
          selectedTimeStart.minute),
      "endDateTime": DateTime(selectedDateEnd.year, selectedDateEnd.month,
          selectedDateEnd.day, selectedTimeEnd.hour, selectedTimeEnd.minute),
      "endDate": selectedDateEnd,
      "startDate": DateTime(selectedDateStart.year, selectedDateStart.month,
          selectedDateStart.day),
      "title": widget.calEvent.title,
      "description": widget.calEvent.description,
      "userId": auth.currentUser.id,
    });
  }
}
