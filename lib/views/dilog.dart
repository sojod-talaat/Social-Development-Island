import 'package:flutter/material.dart';

class NotificationDialog {
  static void show(BuildContext context) {
    List<String> messages = [
      "﴿ فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا ﴾",
      "اللهم إني أسألك العفو والعافية في الدنيا والآخرة",
      "﴿ وَبَشِّرِ ٱلصَّـٰبِرِینَ ﴾",
      "اللهم اجعل هذا اليوم فرجًا لكل مهموم",
    ];

    String randomMessage = (messages..shuffle()).first;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تنبيه '),
        content: Text(randomMessage, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسنًا"),
          ),
        ],
      ),
    );
  }
}
