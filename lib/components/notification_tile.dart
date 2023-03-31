import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sniper/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModelApp notification;
  NotificationTile({
    super.key,
    required this.notification,
  });
  final formater = DateFormat("hh:mm a, d MMM");
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          notification.title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              notification.body,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: Colors.white.withOpacity(0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formater.format(notification.createdAt.toLocal()),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
