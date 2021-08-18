import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:plant_it_forward/services/local_notification_service.dart';
import 'package:plant_it_forward/services/router.dart' as router;
import 'package:plant_it_forward/utils/routing_constants.dart';
import 'package:provider/provider.dart';

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
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
        onGenerateRoute: router.generateRoute,
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

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
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
