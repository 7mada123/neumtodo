import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../root_app.dart';

final notificationsProvider = Provider.autoDispose<Notifications>((final ref) {
  ref.maintainState = true;
  return const Notifications();
});

class Notifications {
  Future<void> setScheduleNotification({
    required final DateTime date,
    required final int id,
    required final String title,
  }) {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      null,
      tz.TZDateTime.from(date, tz.local),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: id.toString(),
    );
  }

  Future<void> cancelNotification(final int id) {
    return flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> onSelect(final String payload) => router.pushNamed(
        'SingleTodoScreen',
        arguments: int.parse(payload),
      );

  static void getNotificationAppLaunchDetails() async {
    WidgetsBinding.instance!.addPostFrameCallback((final _) async {
      final appLaunchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

      if (appLaunchDetails == null || appLaunchDetails.payload == null) return;

      if (appLaunchDetails.didNotificationLaunchApp)
        Notifications.onSelect(appLaunchDetails.payload!);
    });
  }

  const Notifications();

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  static const _initializationSettings =
      InitializationSettings(android: _initializationSettingsAndroid);

  static Future<void> init() async {
    if (!Platform.isAndroid) return;

    await flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: (final payload) async {
        onSelect(payload!);
      },
    );

    tz.initializeDatabase([]);
  }

  static const _androidNotificationDetails = AndroidNotificationDetails(
    'channel id',
    'channel name',
    importance: Importance.max,
    priority: Priority.max,
    enableLights: true,
    visibility: NotificationVisibility.public,
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
  );
}
