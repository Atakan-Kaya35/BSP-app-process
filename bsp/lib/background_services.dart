import 'dart:async';
import 'dart:ui';

import 'package:bsp/noti.dart';
import 'package:bsp/user_holder.dart';
import 'package:bsp/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BG_Services {

  UserHolder holder = UserHolder();
  int lastTime = 0;
  
  BG_Services() {
    holder.addUser("Atakan Kaya", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
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
  static void onStart(ServiceInstance service){
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
      checkWellness();
    });
  }

  @pragma("vm:enry-point")
  static Future<bool> iosBackground(ServiceInstance service) async{
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  static void checkWellness(){
    UserHolder holder = UserHolder();
    int lastTime = 0;
    holder.addUser("Atakan Kaya", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
    List<UserModel> models = holder.giveEm();
    var values = models[0].fetchData();

    checkAndUpdateNotifications(models[0], lastTime);
  } 

  static void checkAndUpdateNotifications(UserModel model, int lastTime) async {
    var data = await model.fetchData();

    if (data.isNotEmpty) {
      if (data[0] == 1
       //&& lastTime != 1
       ) {
        lastTime = 1;
        Noti().showNotification(body: "Back. You are fine.", title: "BSP");
      } else if (lastTime == 1) {
        // Do nothing
      } else {
        lastTime = 0;
        //startBackgroundTask();
        Noti().showNotification(body: "Back. Emergency!", title: "BSP");
      }
    }
  }
}
