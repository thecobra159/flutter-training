import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube/CustomSearchDelegate.dart';
import 'package:youtube/Screens/Initial.dart';
import 'package:youtube/Screens/Lib.dart';
import 'package:youtube/Screens/Subscriptions.dart';
import 'package:youtube/Screens/WhatsHot.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _actualIndex = 0;
  var result = "";
  @override
  Widget build(BuildContext context) {
    var screens = [
      Initial(result),
      WhatsHot(),
      Subscription(),
      Lib()
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        backgroundColor: Colors.white,
        title: Image.asset(
            "images/youtube.png",
          width: 98,
          height: 22,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              print("ação: videocam");
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String res = await showSearch(context: context, delegate: CustomSearchDelegate());
              setState(() {
                result = res;
              });
              print("ação: pesquisa");
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              print("ação: conta");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: screens[_actualIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _actualIndex,
        onTap: (index) {
          setState(() {
            _actualIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            title: Text("Início"),
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            title: Text("Em alta"),
            icon: Icon(Icons.whatshot)
          ),
          BottomNavigationBarItem(
            title: Text("Inscrições"),
            icon: Icon(Icons.subscriptions)
          ),
          BottomNavigationBarItem(
            title: Text("Biblioteca"),
            icon: Icon(Icons.folder)
          ),
        ],
      ),
    );
  }
}
