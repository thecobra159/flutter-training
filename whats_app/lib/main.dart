import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app/route_generator.dart';
import 'package:whats_app/screens/splash_screen.dart';

final ThemeData iosTheme = ThemeData(
  primaryColor: Colors.grey[300],
  accentColor: Color(0xff25d366),
);

final ThemeData defaultTheme = ThemeData(
  primaryColor: Color(0xff075e54),
  accentColor: Color(0xff25d366),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: WhatsSplashScreen(),
    theme: Platform.isIOS ? iosTheme : defaultTheme,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
