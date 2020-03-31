import 'package:flutter/material.dart';
import 'package:whats_app/configurations.dart';
import 'package:whats_app/home.dart';
import 'package:whats_app/messages.dart';
import 'package:whats_app/signup.dart';

import 'login.dart';

class RouteGenerator {

  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/signup":
        return MaterialPageRoute(builder: (_) => SignUp());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/configurations":
        return MaterialPageRoute(builder: (_) => Configurations());
      case "/messages":
        return MaterialPageRoute(builder: (_) => Messages(args));
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada!"),
          ),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );
  }
}
