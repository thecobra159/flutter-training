import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:whats_app/login.dart';

class WhatsSplashScreen extends StatefulWidget {
  @override
  _WhatsSplashScreenState createState() => _WhatsSplashScreenState();
}

class _WhatsSplashScreenState extends State<WhatsSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          backgroundColor: Color(0xff075E54),
          navigateAfterSeconds: Login(),
          loaderColor: Colors.transparent,
        ),
        Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 200,
            height: 200,
          ),
        ),
      ],
    );
  }
}
