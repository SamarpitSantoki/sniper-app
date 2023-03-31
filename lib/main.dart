import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sniper/helpers/work_handler.dart';
import 'package:sniper/routes/routes.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/ic_bg_service_small',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  Workmanager().initialize(
    initializeService,
    isInDebugMode:
        true, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerPeriodicTask(
    "task-identifier",
    "simpleTask",
    frequency: const Duration(minutes: 15),
  );

  await initializeService();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "VP Financials",
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesClass.getInitialRoute(),
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          body: Center(
            child: Text('Not Found'),
          ),
        ),
      ),
      getPages: RoutesClass.routes,
    ),
  );
}

// class DayTile extends StatelessWidget {
//   const DayTile({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Today",
//             style: TextStyle(color: Colors.white, fontSize: 20)),
//         const SizedBox(height: 10),
//         ListView(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: const [
//             NotificationTile(),
//             NotificationTile(),
//           ],
//         ),
//       ],
//     );
//   }
// }
