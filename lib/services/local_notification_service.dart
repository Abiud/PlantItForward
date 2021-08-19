import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:plant_it_forward/services/router.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(
      BuildContext context, PersistentTabController persistentTabController) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (
      String? data,
    ) async {
      if (data != null) {
        Map<String, dynamic> map = jsonDecode(data);
        print(map);
        persistentTabController.jumpToTab(0);
        pushNewScreen(context, screen: generateScreen(map));
        // Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final String? groupKey = message.data['groupKey'];
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (groupKey != null) {
          AndroidNotificationDetails notificationDetails =
              AndroidNotificationDetails(
                  "plantitforward",
                  "plantitforward channel",
                  "Plant it forward General Notifications",
                  importance: Importance.max,
                  priority: Priority.high,
                  groupKey: groupKey);
          NotificationDetails notificationDetailsPlatformSpefics =
              NotificationDetails(android: notificationDetails);
          _notificationsPlugin.show(notification.hashCode, notification.title,
              notification.body, notificationDetailsPlatformSpefics,
              payload: jsonEncode(message.data));

          List<ActiveNotification> activeNotifications =
              await _notificationsPlugin
                      .resolvePlatformSpecificImplementation<
                          AndroidFlutterLocalNotificationsPlugin>()
                      ?.getActiveNotifications() ??
                  [];
          if (activeNotifications.length > 0) {
            List<String> lines =
                activeNotifications.map((e) => e.title.toString()).toList();
            InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
                lines,
                contentTitle: "${activeNotifications.length - 1} messages",
                summaryText: "${activeNotifications.length - 1} messages");
            AndroidNotificationDetails groupNotificationDetails =
                AndroidNotificationDetails(
                    "plantitforward",
                    "plantitforward channel",
                    "Plant it forward General Notifications",
                    styleInformation: inboxStyleInformation,
                    setAsGroupSummary: true,
                    groupKey: groupKey);

            NotificationDetails groupNotificationDetailsPlatformSpefics =
                NotificationDetails(android: groupNotificationDetails);
            await _notificationsPlugin.show(
                0, '', '', groupNotificationDetailsPlatformSpefics,
                payload: jsonEncode(message.data));
          }
        } else {
          AndroidNotificationDetails notificationDetails =
              AndroidNotificationDetails(
            "plantitforward",
            "plantitforward channel",
            "Plant it forward General Notifications",
            importance: Importance.max,
            priority: Priority.high,
          );
          NotificationDetails notificationDetailsPlatformSpefics =
              NotificationDetails(android: notificationDetails);
          _notificationsPlugin.show(notification.hashCode, notification.title,
              notification.body, notificationDetailsPlatformSpefics,
              payload: jsonEncode(message.data));
        }
      }

      // final NotificationDetails notificationDetails = NotificationDetails(
      //     android: AndroidNotificationDetails(
      // "plantitforward",
      // "plantitforward channel",
      // "Plant it forward General Notifications",
      // importance: Importance.max,
      // priority: Priority.high,
      // ));

      // await _notificationsPlugin.show(
      //   id,
      //   message.notification!.title,
      //   message.notification!.body,
      //   notificationDetails,
      //   payload: message.data["route"],
      // );
    } on Exception catch (e) {
      print(e);
    }
  }
}
