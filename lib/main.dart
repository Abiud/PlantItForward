import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/customWidgets/provider_widget.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/authenticate/register.dart';
import 'package:plant_it_forward/screens/authenticate/sign_in.dart';
import 'package:plant_it_forward/screens/home/home.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/shared/loading.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      db: FirebaseFirestore.instance,
      child: MaterialApp(
        title: "Plant It Forward",
        theme: ThemeData.light(),
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : Authenticate();
        }
        return Loading();
      },
    );
  }
}
