import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:plant_it_forward/constants/route_names.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialise() async {
    if (Platform.isIOS) {
      // request permissions if we're on android
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
    }

    // Called when the app is in the foreground and we receive a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Called when the app has been closed comlpetely and it's opened
    // from the push notification.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Called when the app is in the background and it's opened
    // from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      _serialiseAndNavigate(message.data);
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  _serialiseAndNavigate(message.data);
  print("Handling a background message: ${message.messageId}");
}

void _serialiseAndNavigate(Map<String, dynamic> message) {
  final NavigationService _navigationService = locator<NavigationService>();
  var notificationData = message['data'];
  var view = notificationData['view'];

  if (view != null) {
    // Navigate to the create post view
    if (view == 'create_post') {
      _navigationService.navigateTo(CreateProductViewRoute);
    }
  }
}
