import "dart:async";
import "dart:convert";
import "dart:typed_data";
import "dart:ui";

import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter_background_service/flutter_background_service.dart";
import 'package:flutter/material.dart';
import "package:flutter_background_service_android/flutter_background_service_android.dart";
import "package:mixpanel_flutter/mixpanel_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:web_socket_channel/web_socket_channel.dart";

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  AwesomeNotifications().setChannel(
    NotificationChannel(
      channelKey: 'Hellll123',
      channelName: 'MY FOREGROUND SERVICE',
      channelDescription: 'This channel is used for important notifications.',
      defaultColor: Colors.red,
      playSound: true,
      vibrationPattern: Int64List.fromList(
        <int>[100, 200, 300, 400, 500, 400, 300, 200, 400],
      ),
      enableLights: true,
      ledColor: Colors.red,
      enableVibration: true,
      importance: NotificationImportance.High,
      criticalAlerts: true,
      channelShowBadge: true,
      locked: false,
    ),
  );

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      autoStart: true,
      isForegroundMode: false,

      autoStartOnBoot: true,
      onStart: onStart,
      // auto start service
      notificationChannelId: 'Hellll123',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // this will be executed when app is in background in separated isolate
      // create a future to execute your task
    
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  Mixpanel mixpanel = await Mixpanel.init("2bea7b41829ab329c59895fff1316584",
      trackAutomaticEvents: true);

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  /// OPTIONAL when use custom notification
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  var channel = WebSocketChannel.connect(
    Uri.parse('ws://15.206.99.131:4444/'),
  );

  Timer.periodic(const Duration(seconds: 5), (timer) {
    service.invoke("connected", {"connected": true});

    try {
      channel.sink.add(const JsonEncoder().convert({
        "type": "ping",
        "data": {
          "timestamp": DateTime.now().toIso8601String(),
        }
      }));
    } catch (e) {
      timer.cancel();
      onStart(service);
    }
  });

  channel.stream.listen(
    (message) async {

      message = jsonDecode(message);

      if (message['type'] == "id") {
        mixpanel.identify(message['id']);
        mixpanel.track("Opened");
        mixpanel.flush();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("wid", message['id']);
        return;
      }

      // show notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'Hellll123',
          title: message['title'],
          body: message['body'],
          criticalAlert: true,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
      );

      // write to shared preferences

      // invoke method to update ui
      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "message": message,
        },
      );
    },
    onError: (error) {
      service.invoke("connected", {"connected": false});

      // do nothing if error is due to connection closed
      if (error.toString().contains("Connection timed out")) {
        return;
      }
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        timer.cancel();
        onStart(service);
      });
    },
    onDone: () {
      service.invoke("connected", {"connected": false});

      // when server closes the connection
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        timer.cancel();
        onStart(service);
      });
    },
  );

  service.on('stopService').listen((event) {
    service.invoke("connected", {"connected": false});

    channel.sink.close();
    mixpanel.track("Closed");
    mixpanel.flush();
    service.stopSelf();
  });
}
