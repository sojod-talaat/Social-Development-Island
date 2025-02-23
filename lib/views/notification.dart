import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'وصف القناة',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  List<String> messages = [
    "﴿ فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا ﴾",
    "اللهم إني أسألك العفو والعافية في الدنيا والآخرة",
    "﴿ وَبَشِّرِ ٱلصَّـٰبِرِینَ ﴾",
    "اللهم اجعل هذا اليوم فرجًا لكل مهموم",
    "سبحان الله وبحمده، سبحان الله العظيم",
    "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير",
    "اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك",
    "أستغفر الله العظيم وأتوب إليه",
    "رضيت بالله ربًا، وبالإسلام دينًا، وبمحمد ﷺ نبيًا ورسولًا",
    "اللهم إني أسألك العفو والعافية في الدنيا والآخرة",
    "اللهم اغفر لي ذنوبي، ووسع لي في رزقي، وبارك لي في حياتي",
    "اللهم اجعل القرآن العظيم ربيع قلبي ونور صدري وجلاء حزني وذهاب همي",
    "اللهم ارزقني حسن الخاتمة",
    "اللهم احفظني من بين يديَّ ومن خلفي وعن يميني وعن شمالي ومن فوقي وأعوذ بعظمتك أن أغتال من تحتي",
  ];

  String randomMessage = (messages..shuffle()).first;

  await flutterLocalNotificationsPlugin.show(
    0,
    "رسالة اليوم",
    randomMessage,
    platformChannelSpecifics,
  );
}
