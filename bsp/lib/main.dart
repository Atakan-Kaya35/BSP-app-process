import 'dart:async';
import 'dart:ui';

import 'package:bsp/homePage.dart';
import 'package:bsp/noti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initservice();

  runApp(const MyApp());
}

Future<void> initservice() async{
  // variables
  var service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      onBackground: iosBackground,
      onForeground: onStart
    ), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, 
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: "notichannelid",
      initialNotificationTitle: "Initial Noti",
      initialNotificationContent: "Initial noti content",
      foregroundServiceNotificationId: 0
      )
    );
    service.startService();
}

// onstant method
@pragma("vm:enry-point")
void onStart(ServiceInstance service){
  DartPluginRegistrant.ensureInitialized();

  service.on("setAsForeground").listen((event) {
    print("foreground==================================");
  });
  service.on("setAsBackground").listen((event) {
    print("background==================================");
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 10), (timer){
    print("oluyor aslinda");
    Noti().showNotification(title: "YOU DID IT");
  });
}

// iosBackground
@pragma("vm:enry-point")
Future<bool> iosBackground(ServiceInstance service) async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Sugar Pedictor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: HomePage(),
    ); 
  }
}
