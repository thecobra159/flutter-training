import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/screens/contacts_tab.dart';
import 'package:whats_app/screens/conversation_tab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var _auth = FirebaseAuth.instance;
  var _tabController;
  var _menuItems = [
    "Configurações",
    "Deslogar",
  ];

  _logIn() {
    var user = _auth.currentUser();

    if(user == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void initState() {
    super.initState();
    _logIn();
    _tabController = new TabController(length: 2, vsync: this);
  }

  _selectedItemMenu(String selectedItem) {
    switch (selectedItem) {
      case "Configurações":
        Navigator.pushNamed(context, "/configurations");
        break;
      case "Deslogar":
        _logOut();
        break;
    }
  }

  _logOut() async {
    await _auth.signOut();

    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        elevation: Platform.isIOS ? 0 : 4,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Platform.isIOS ? Colors.grey[400] : Colors.white,
          indicatorWeight: 5,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(text: "Conversas"),
            Tab(text: "Contatos"),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _selectedItemMenu,
            itemBuilder: (context) {
              return _menuItems.map((String item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ConversationTab(),
          ContactsTab(),
        ],
      ),
    );
  }
}
