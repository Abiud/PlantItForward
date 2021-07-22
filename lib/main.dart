import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Provider(
      auth: AuthService(),
      db: DatabaseService(uid: ""),
      child: MaterialApp(
        title: "Plant It Forward",
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: secondaryBlue,
            accentColor: primaryGreen,
            colorScheme: ColorScheme.light(primary: secondaryBlue)),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context)!.auth;
    return StreamBuilder<String?>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          if (signedIn) {
            return FutureBuilder(
                future: auth.setCurrentUser(snapshot.data!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Home();
                  } else {
                    return Loading();
                  }
                });
          }
          return Authenticate();
        }
        return Loading();
      },
    );
  }
}
