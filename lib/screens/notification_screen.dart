import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sniper/components/notification_tile.dart';
import 'package:sniper/controllers/auth_controller.dart';
import 'package:sniper/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final textController = TextEditingController();

  final scrollController = ScrollController();

  final notificationController = Get.put(NotificationController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    notificationController.fetchMessages();
    

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () => authController.logout(),
            child: const Text('Sniper Notifications')),
        actions: [
          IconButton(
            onPressed: () async {
              notificationController.fetchMessages();
              authController.verifyConnection();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cloud_done),
            color: notificationController.connected.value
                ? Colors.green
                : Colors.red,
          ),
          // IconButton(
          //   onPressed: () {
          //     FlutterBackgroundService().invoke("stopService");
          //   },
          //   icon: const Icon(Icons.cleaning_services),
          //   color: connected ? Colors.green : Colors.red,
          // ),
        ],
        backgroundColor: const Color.fromRGBO(15, 3, 49, 1),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(15, 3, 49, 1),
              Color.fromRGBO(38, 28, 81, 1),
            ],
            transform: GradientRotation(1),
          ),
        ),
        child: Obx(
          () => notificationController.fetching.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
                : Obx(
                    () => authController.sniperAllowed.value
                        ? ListView.separated(
                  itemCount: notificationController.notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  controller: scrollController,
                  reverse: true,

                  itemBuilder: (context, index) {
                    return NotificationTile(
                      notification: notificationController.notifications[index],
                    );
                    // return const DayTile();
                  },
                  // children: const [
                  //   DayTile(),
                  //   DayTile(),
                  //   DayTile(),
                  //   DayTile(),
                  //   DayTile(),
                  // ],
                          )
                        : const Text(
                            'You are not allowed to use Sniper. Please contact your admin.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ),
          )),
    );
  }
}
