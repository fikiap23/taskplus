import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:permission_handler/permission_handler.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    // Request notification permission
    await _requestNotificationPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future _requestNotificationPermission() async {
    // Check if notification permission is already granted
    PermissionStatus status = await Permission.notification.status;

    if (status != PermissionStatus.granted) {
      // If not granted, request permission
      status = await Permission.notification.request();

      if (status != PermissionStatus.granted) {
        // Permission not granted. Handle accordingly.
        print('Notification permission not granted');
        // You can show a message to the user or take appropriate action.
      }
    }
  }

  static int generateUniqueNotificationId() {
    int largePrime =
        2147483647; // A large prime number within the 32-bit integer range
    return DateTime.now().millisecondsSinceEpoch % largePrime;
  }

  static Future scheduleNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime deadline,
    required ReminderFrequency frequency,
    required int interval, // Tambahkan parameter interval
  }) async {
    Duration timeDifference = deadline.difference(DateTime.now());
    if (timeDifference.isNegative) {
      // Deadline has already passed
      print('Deadline has already passed');
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    int minutesInInterval;
    switch (frequency) {
      case ReminderFrequency.minute:
        minutesInInterval =
            interval; // Menentukan interval langsung dalam menit
        break;
      case ReminderFrequency.hour:
        minutesInInterval = interval * 60; // Ubah interval ke menit
        break;
      case ReminderFrequency.day:
      default:
        minutesInInterval = interval * 60 * 24; // Ubah interval ke menit
        break;
    }

    print('Time difference: ${timeDifference.inMinutes}');

    for (int i = 1; i <= timeDifference.inMinutes; i += minutesInInterval) {
      DateTime scheduledTime = deadline.subtract(Duration(minutes: i));
      tz.TZDateTime scheduledTimeLocal =
          tz.TZDateTime.from(scheduledTime, tz.local);

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'task_channel',
        'Task Channel',
        channelDescription: 'Channel for task notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
        ticker: 'task_ticker',
        subText: "📌Task reminder ",
        icon: 'taskplus_logo',
      );
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      int scheduleNotificationId = generateUniqueNotificationId();
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        scheduleNotificationId,
        title,
        body,
        scheduledTimeLocal,
        notificationDetails,
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

enum ReminderFrequency {
  minute,
  hour,
  day,
}
