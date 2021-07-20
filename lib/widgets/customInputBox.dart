import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_it_forward/config.dart';

class MyCustomInputBox extends StatelessWidget {
  final label;
  final inputHint;
  final validatorFn;
  final onChangedFn;
  final TextInputType keyboardType;
  final checkBoxIcon = 'assets/checkbox.svg';

  const MyCustomInputBox(
      {Key? key,
      this.label,
      this.inputHint,
      this.keyboardType = TextInputType.text,
      this.validatorFn,
      this.onChangedFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSubmitted = false;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
            child: Text(
              label!,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: TextFormField(
            keyboardType: keyboardType,
            obscureText: label == 'Password' ? true : false,
            validator: validatorFn,
            onChanged: onChangedFn,
            style: TextStyle(
                backgroundColor: Colors.white,
                fontSize: 19,
                color: secondaryBlue,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: inputHint,
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
