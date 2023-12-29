// import 'package:flutter/material.dart';

// import 'main_app.dart';

// void main() async {
//   runApp(const MainApp());
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskplus/main_app.dart';
import 'package:taskplus/services/notif_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

//  handle in terminated state

  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runApp(const MainApp());
}
