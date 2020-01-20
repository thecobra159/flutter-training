import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'JoyPad.dart';

void main() async {
  // rotate screen to left
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);

  // full screen
  await SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle bluetooth',
      home: JoyPad(),
      theme: ThemeData.dark(),
    );
  }
}
