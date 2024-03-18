import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti{
  final FlutterLocalNotificationsPlugin notificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  Future<void> initNotification() async {
    AndroidInitializationSettings initSettingsAndroid = 
        const AndroidInitializationSettings("flutter_logo");
    
    var initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id,String? title,String? body,String? payload) async{}
    );

    var initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS
    );

    await notificationsPlugin.initialize(initializationSettings,
    onDidReceiveBackgroundNotificationResponse: (
      NotificationResponse notificationResponse
    ) async{});
  }

  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(sound: RawResourceAndroidNotificationSound("noti_sound"), "changeit", "channelName", importance: Importance.max, icon: "@mipmap/ic_launcher"), // Specify the sound here,
      iOS: DarwinNotificationDetails()
    );
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async{
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }
}