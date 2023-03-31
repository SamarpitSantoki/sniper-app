import 'package:get/get.dart';
import 'package:sniper/screens/greeting_screen.dart';
import 'package:sniper/screens/login_screen.dart';
import 'package:sniper/screens/notification_screen.dart';

class RoutesClass {
  static String home = '/home';
  static String login = '/login';
  static String register = '/register';
  static String greeting = "/greeting";

  static String getHomeRoute() => home;
  static String getLoginRoute() => login;
  static String getRegisterRoute() => register;
  static String getGreetingRoute() => greeting;

  static String getInitialRoute() => greeting;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => NotificationScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: greeting, page: () => const GreetingScreen())
  ];
}
