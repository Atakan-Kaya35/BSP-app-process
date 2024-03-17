

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

// new with chnages 
  void startBackgroundTask() {
    final SendPort? send = IsolateNameServer.lookupPortByName('isolate');
    send!.send(null);
  }
}


class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    _stream = _streamController.stream;
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      // Emit a unique value (timestamp) every 5 seconds
      _streamController.add(DateTime.now().millisecondsSinceEpoch);
    });
  }

}