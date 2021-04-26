import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/managers/dialog_manager.dart';
import 'package:plant_it_forward/screens/router.dart';
import 'package:plant_it_forward/screens/startup_view.dart';
import 'package:plant_it_forward/services/analytics_service.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/services/navigation_service.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Plant It Forward',
      builder: (context, child) => Navigator(
          key: locator<DialogService>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(
                    child: child,
                  ))),
      navigatorKey: locator<NavigationService>().navigationKey,
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: StartUpView(),
      theme: CupertinoThemeData(brightness: Brightness.light),
      onGenerateRoute: generateRoute,
    );
  }
}
