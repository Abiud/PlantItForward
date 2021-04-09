import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/widgets/customInputBox.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({Key key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text field state
  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: 25),
              physics: BouncingScrollPhysics(),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 45.0),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 35,
                                color: primaryGreen,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 5.0),
                          child: Text(
                            'Register with',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            MyCustomInputBox(
                              label: 'Name',
                              inputHint: 'Joe Doe',
                              validatorFn: (val) => val.isEmpty
                                  ? "The Name can't be empty"
                                  : null,
                              onChangedFn: (val) =>
                                  {setState(() => name = val)},
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MyCustomInputBox(
                              label: 'Email',
                              inputHint: 'joedoe@gmail.com',
                              validatorFn: (val) => val.isEmpty
                                  ? "The Email can't be empty"
                                  : null,
                              onChangedFn: (val) =>
                                  {setState(() => email = val)},
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MyCustomInputBox(
                              label: 'Password',
                              inputHint: '6+ Characters',
                              validatorFn: (val) => val.length < 6
                                  ? "The Password must have 6 or more characters"
                                  : null,
                              onChangedFn: (val) =>
                                  {setState(() => password = val)},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Some dummy text for terms of service \nI don't know how this works.",
                        style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff8f9db5).withOpacity(0.45)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: scrWidth * 0.85,
                        height: 75,
                        child: Material(
                          // <----------------------------- Outer Material
                          shadowColor: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          elevation: 6.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(20)),
                            child: Material(
                              // <------------------------- Inner Material
                              type: MaterialType.transparency,
                              elevation: 6.0,
                              color: Colors.transparent,
                              shadowColor: Colors.grey[50],
                              child: InkWell(
                                //<------------------------- InkWell
                                splashColor: Colors.white30,
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    setState(() => {loading = true});
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            email, password, name);
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'Sorry we couldn\'t register your account\nPlease try again';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                //   child: Center(
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        error,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: error == '' ? 0 : 30,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff8f9db5).withOpacity(0.45)),
                        ),
                        TextSpan(
                            text: "Log In",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.toggleView();
                              },
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: secondaryBlue)),
                      ])),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
    // Scaffold(
    //   body: Container(
    //     padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
    //     child: Form(
    //         key: _formKey,
    //         child: Column(
    //           children: [
    //             SizedBox(height: 20.0),
    //             TextFormField(
    //                 validator: (val) =>
    //                     val.isEmpty ? "The Email can't be empty" : null,
    //                 onChanged: (val) {
    //                   setState(() => email = val);
    //                 }),
    //             SizedBox(
    //               height: 20.0,
    //             ),
    //             TextFormField(
    //               validator: (val) => val.length < 6
    //                   ? "The Password must have 6 or more characters"
    //                   : null,
    //               obscureText: true,
    //               onChanged: (val) {
    //                 setState(() => password = val);
    //               },
    //             ),
    //             SizedBox(
    //               height: 20.0,
    //             ),
    //             ElevatedButton(
    //                 onPressed: () async {
    //                   if (_formKey.currentState.validate()) {
    //                     dynamic result = await _auth
    //                         .registerWithEmailAndPassword(email, password);
    //                     if (result == null) {
    //                       setState(() => error = 'Invalid Credentials');
    //                     }
    //                   }
    //                 },
    //                 style: ElevatedButton.styleFrom(primary: Colors.pink[400]),
    //                 child: Text(
    //                   "Register",
    //                   style: TextStyle(color: Colors.white),
    //                 )),
    //             SizedBox(
    //               height: 12.0,
    //             ),
    //             Text(
    //               error,
    //               style: TextStyle(color: Colors.red, fontSize: 14.0),
    //             )
    //           ],
    //         )),
    //   ),
    // );
  }
}
