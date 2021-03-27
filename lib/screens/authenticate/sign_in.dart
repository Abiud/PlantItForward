import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/customWidgets/customInputBox.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SvgPicture.asset("assets/PIF-Logo_2_10.svg"),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, top: 40),
                          child: Image(
                            image:
                                AssetImage('assets/PIF-Logo-removebg_10.png'),
                            width: scrWidth < 720 ? scrWidth / 2 : 330,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 25.0),
                          child: Text(
                            'Sign in',
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
                            'Sign in with',
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
                        height: 20,
                      ),
                      Text(
                        "Some dummy text for terms of service \nI don't know how this works.",
                        style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff8f9db5).withOpacity(0.45)),
                      ),
                      SizedBox(
                        height: 20,
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
                                        .signInWithEmail(email, password);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Invalid Credentials';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                //   child: Center(
                                child: Center(
                                  child: Text(
                                    "Sign In",
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
                          text: "Don't have an account? ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff8f9db5).withOpacity(0.45)),
                        ),
                        TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.toggleView();
                              },
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: secondaryBlue))
                      ])),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                  ClipPath(
                    clipper: OutterClippedPart(),
                    child: Container(
                      color: primaryGreen,
                      width: scrWidth,
                      height: scrHeight,
                    ),
                  ),
                  ClipPath(
                    clipper: InnerClippedPart(),
                    child: Container(
                      color: secondaryBlue,
                      width: scrWidth,
                      height: scrHeight,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

class btnStyle extends StatelessWidget {
  String char;
  double wdt;
  Function onPressedFn;

  btnStyle({this.char, this.wdt, this.onPressedFn});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wdt,
      height: 58,
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
                offset: Offset(12, 11),
                blurRadius: 26,
                color: Color(0xffaaaaaa).withOpacity(0.1))
          ]),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color(0xff0962FF)),
        ),
      ),
    );
  }
}

class OutterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);

    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);

    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
