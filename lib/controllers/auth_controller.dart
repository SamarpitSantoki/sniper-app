import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sniper/constants/apis.dart';
import 'package:sniper/routes/routes.dart';

class AuthController extends GetxController {
  final uid = ''.obs;
  final wid = ''.obs;
  final accessToken = ''.obs;
  final sniperAllowed = false.obs;
  final FlutterBackgroundService _service = FlutterBackgroundService();

  @override
  void onInit() async {
    super.onInit();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken.value = prefs.getString('accessToken') ?? '';

    if (accessToken.value != '') {
      fetchProfile();
      verifyConnection();

      Get.offAllNamed(RoutesClass.getHomeRoute());
    }
  }

  void login(String email, String password) async {
    var response = await http.post(Uri.parse(baseUrl + loginApi),
        body: {"email": email, "password": password});

    var responseJson = jsonDecode(response.body);
    print(responseJson);

    if (responseJson['status'] == true) {
      accessToken.value = responseJson['token'];
      Get.offAllNamed(RoutesClass.getHomeRoute());
    } else {
      Get.snackbar("Error", responseJson['message'],
          colorText: Colors.red, backgroundColor: Colors.red.withOpacity(0.1));
    }

    print(accessToken);

    fetchProfile();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken.value);
  }

  void logout() async {
    accessToken.value = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken.value);
  }

  void fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken.value = prefs.getString('accessToken') ?? '';
    wid.value = prefs.getString('wid') ?? '';
    uid.value = prefs.getString('uid') ?? '';
  }

  void fetchProfile() async {
    var response = await http.post(Uri.parse(baseUrl + profileApi), headers: {
      "x-access-token": accessToken.value,
    });

    var responseJson = jsonDecode(response.body);

    if (responseJson['status'] == true) {
      uid.value = responseJson['user']['_id'];
    }
    print('uid$uid');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid.value);
  }

  void verifyConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    wid.value = prefs.getString('wid') ?? '';
    uid.value = prefs.getString('uid') ?? '';

    var response =
        await http.post(Uri.parse(socketUrl + verifyConnectionApi), body: {
      "uid": uid.value,
      "wid": wid.value,
    });

    // sniperAllowed.value = response.body == 'verified' ? true : false;
    print("asdasd${response.body}");
  }
}
