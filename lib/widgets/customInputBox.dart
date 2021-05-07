import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_it_forward/config.dart';

class MyCustomInputBox extends StatefulWidget {
  final String label;
  final String inputHint;
  final Function validatorFn;
  final Function onChangedFn;
  final Function onFieldSubmittedFn;
  MyCustomInputBox(
      {required Key key,
      required this.label,
      required this.inputHint,
      required this.validatorFn,
      required this.onChangedFn,
      required this.onFieldSubmittedFn})
      : super(key: key);

  @override
  _MyCustomInputBoxState createState() => _MyCustomInputBoxState();
}

class _MyCustomInputBoxState extends State<MyCustomInputBox> {
  bool isSubmitted = false;
  final checkBoxIcon = 'assets/checkbox.svg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
            child: Text(
              widget.label,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: TextFormField(
            obscureText: widget.label == 'Password' ? true : false,
            // validator: widget.validatorFn,
            // onChanged: widget.onChangedFn,
            // onFieldSubmitted: widget.onFieldSubmittedFn,
            style: TextStyle(
                fontSize: 19,
                color: secondaryBlue,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: widget.inputHint,
                hintStyle: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[350],
                    fontWeight: FontWeight.bold),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                focusColor: secondaryBlue,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide(color: secondaryBlue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide(color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: isSubmitted == true
                    ? Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(checkBoxIcon),
                        ))
                    : Visibility(
                        visible: false,
                        child: SvgPicture.asset(checkBoxIcon),
                      )),
          ),
        )
      ],
    );
  }
}
