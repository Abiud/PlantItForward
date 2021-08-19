import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/Models/AppUser.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/utils/config.dart';
import 'package:plant_it_forward/screens/authenticate/authenticate.dart';
import 'package:plant_it_forward/screens/home/nav_wrapper.dart';
import 'package:plant_it_forward/services/auth.dart';
import 'package:plant_it_forward/services/database.dart';
import 'package:plant_it_forward/utils/routing_constants.dart';
import 'package:provider/provider.dart';

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print("backgorund handler");
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
        initialRoute: HomeViewRoute,
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

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
  }

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

_saveDeviceToken() async {
  // Get the token each time the application loads
  String? token = await FirebaseMessaging.instance.getToken();

  if (token != null)
    // Save the initial token to the database
    await saveTokenToDatabase(token);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

Future<void> saveTokenToDatabase(String token) async {
  if (FirebaseAuth.instance.currentUser != null) {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .doc(token)
        .set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': kIsWeb ? "Web" : Platform.operatingSystem
    });
  }
}
