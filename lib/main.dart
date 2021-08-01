import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/Models/AppUser.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/home/nav_wrapper.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        StreamProvider<AppUser?>.value(
            value: AuthService().appUser, initialData: null)
      ],
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
    final AppUser? user = Provider.of<AppUser?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<UserData>.value(
        initialData: UserData(id: user.uid, name: ""),
        value: DatabaseService(uid: user.uid).profile,
        child: NavWrapper(),
      );
    }
  }
}
