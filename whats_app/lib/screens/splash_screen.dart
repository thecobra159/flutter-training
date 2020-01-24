import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:whats_app/login.dart';

class WhatsSplashScreen extends StatefulWidget {
  @override
  _WhatsSplashScreenState createState() => _WhatsSplashScreenState();
}

class _WhatsSplashScreenState extends State<WhatsSplashScreen> {
  var auth = FirebaseAuth.instance;

  Future _isLoggedUser() async {
    var userLogged = await auth.currentUser();
    if (userLogged != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoggedUser();
  }

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
