import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sniper/models/notification_model.dart';
import "package:http/http.dart" as http;

class NotificationController extends GetxController {
  final notifications =
      RxList(List<NotificationModelApp>.empty(growable: true));
  final connected = RxBool(false);
  final fetching = RxBool(false);
  final FlutterBackgroundService _service = FlutterBackgroundService();

  void updateMessages(Map<String, dynamic> message, String timestamp) async {
    notifications.insert(0, NotificationModelApp.fromJson(message));
  }

  void fetchMessages() async {
    fetching.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempList = [];
    var fetchedData =
        await http.get(Uri.parse("http://15.206.99.131:4444/notifications"));

    var fetchedDataJson = jsonDecode(fetchedData.body);

    fetchedDataJson.forEach((element) {
      tempList.add(jsonEncode(element));
    });

    await prefs.setStringList("messages", tempList);

    notifications.value = tempList
        .map((e) => NotificationModelApp.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
    print(notifications);

    fetching.value = false;
  }

  @override
  void onInit() {
    _service.on('update').listen((event) {
      print("update called asd");
      updateMessages(event!['message'], event['current_date']);
    });

    _service.on('id').listen((event) {
      print("id: called");
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("wid", event!['id']);
      });
    });

    _service.on('connected').listen((event) {
      print("connected: called");
      connected.value = event!['connected'];
    });

    super.onInit();
  }
}
