import 'package:appstarbab/page_level2/cekBunting.dart';
import 'package:appstarbab/page_level2/cekMenyusui.dart';
import 'package:appstarbab/page_level2/cekPenyapihan.dart';
import 'package:appstarbab/timeZone.dart';
import 'package:appstarbab/page_level2/cekEstrus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

Future initializeNotification(BuildContext context) async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon_app');
  if (Platform.isIOS) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    var split = payload.split('|');
    String title = split[0];
    String notifId = split[1];

    if (payload != null) {
      if (title == 'Perkawinan') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => CekEstrus(id: notifId)),
        );
        NotificationModel.removeNotification(notifId);
      } else if (title == 'Bunting') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => CekBunting(id: notifId)),
        );
        NotificationModel.removeNotification(notifId);
      } else if (title == 'Menyusui') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => CekMenyusui(id: notifId)),
        );
        NotificationModel.removeNotification(notifId);
      } else if (title == 'Penyapihan') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => CekPenyapihan(id: notifId)),
        );
        NotificationModel.removeNotification(notifId);
      }
    }
  });
}

class NotificationModel {
  static final FlutterLocalNotificationsPlugin notifikasi =
      FlutterLocalNotificationsPlugin();

  static const spesifikasiAndroid = AndroidNotificationDetails(
    "id_kawin_notif",
    "Notifikasi Perkawinan",
    "Pengaturan Notifikasi Perkawinan",
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  static const spesifikasiIOS = IOSNotificationDetails();
  static const NotificationDetails platformSpesifik = NotificationDetails(
    android: spesifikasiAndroid,
    iOS: spesifikasiIOS,
  );

  //notifikasi sederhanan
  // static showNotification({String body, String id}) async {
  //   int notifId = int.parse(id);
  //   await notifikasi.show(
  //     notifId,
  //     "Ini title",
  //     body,
  //     platformSpesifik,
  //     payload: '$id',
  //   );
  // }

//notifikasi terjadwal
  static scheduleNotfication(
      {int id, String title, String body, DateTime destination}) async {
    final timeZone = TimeZone();
    String timeZoneName = await timeZone.getTimeZoneName();
    final location = await timeZone.getLocation(timeZoneName);
    int hour = 23 - destination.hour;
    int minute = 60 - destination.minute;
    final newDestination = destination.add(
        Duration(days: -1, hours: hour + 7, minutes: minute + 30, seconds: id));

    print(newDestination);
    final tz.TZDateTime now = tz.TZDateTime.from(
      DateTime.now(),
      location,
    );

    final tz.TZDateTime finish = tz.TZDateTime.from(
      newDestination,
      location,
    );

    tz.TZDateTime scheduledDate;
    if (now.isBefore(finish)) {
      scheduledDate = finish;
    }

    await notifikasi.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformSpesifik,
      androidAllowWhileIdle: true,
      payload: "$title|$id",
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print(scheduledDate);
    print(title);
  }

  static removeNotification(String id) async {
    int notifId = int.parse(id);
    await notifikasi.cancel(notifId);
  }
}
