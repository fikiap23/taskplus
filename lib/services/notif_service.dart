import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
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
  }) async {
    Duration timeDifference = deadline.difference(DateTime.now());
    if (timeDifference.isNegative) {
      // Deadline has already passed
      print('Deadline has already passed');
      return;
    }

    tz.initializeTimeZones();

    tz.setLocalLocation(tz.local);

    for (int i = 1; i <= timeDifference.inMinutes; i++) {
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
        ticker: 'task_ticker',
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

  static Future showReminderNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime deadline,
    required int intervalValue,
    required IntervalType intervalType,
  }) async {
    RepeatInterval repeatInterval = _getRepeatInterval(intervalType);

    print('interval: $intervalType, $intervalValue');
    print('repeatInterval: $repeatInterval');
    print('deadline: $deadline');

    // Calculate the time difference between current time and deadline
    Duration timeDifference =
        deadline.toLocal().difference(DateTime.now().toLocal());

    print('timeDifference: $timeDifference');

    if (timeDifference.isNegative) {
      // Deadline has passed, cancel the notification
      int reminderNotificationId = generateUniqueNotificationId();
      print('Cancelling notification with id $reminderNotificationId');
      await _flutterLocalNotificationsPlugin.cancel(reminderNotificationId);
      return;
    }

    // Notification is scheduled to appear in the future
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Channel',
      channelDescription: 'Channel for task reminders',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'reminder_ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    int reminderNotificationId = generateUniqueNotificationId();
    print('Scheduling notification with id $reminderNotificationId');
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      reminderNotificationId,
      title,
      body,
      repeatInterval,
      notificationDetails,
      payload: payload,
    );
  }

  static RepeatInterval _getRepeatInterval(IntervalType intervalType) {
    switch (intervalType) {
      case IntervalType.minutes:
        return RepeatInterval.everyMinute;
      case IntervalType.hours:
        return RepeatInterval.hourly;
      case IntervalType.days:
        return RepeatInterval.daily;
    }
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

enum IntervalType {
  minutes,
  hours,
  days,
}
