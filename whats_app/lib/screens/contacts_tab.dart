import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/model/user.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  var _auth = FirebaseAuth.instance;
  var _db = Firestore.instance;
  var _emailLoggedUser = "";

  @override
  void initState() {
    super.initState();
    _recoverUser();
    _recoverUsers();
  }

  _recoverUser() async {
    var loggedUser = await _auth.currentUser();
    _emailLoggedUser = loggedUser.email;
  }

  Future<List<User>> _recoverUsers() async {
    QuerySnapshot snapshot = await _db.collection("users").getDocuments();

    List<User> listUsers = List();
    for (DocumentSnapshot item in snapshot.documents) {
      var data = item.data;
      if (data["email"] == _emailLoggedUser) continue;

      var user =
          User.consturctor(data["name"], data["email"], data["imageUrl"]);
      user.userId = item.documentID;
      listUsers.add(user);
    }
    return listUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<User>>(
        future: _recoverUsers(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("Carregando contatos"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  var list = snapshot.data;
                  var user = list[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          "/messages",
                          arguments: user);
                    },
                    contentPadding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                    leading: CircleAvatar(
                      maxRadius: 28,
                      backgroundColor: Colors.grey,
                      backgroundImage: user.imageUrl != null
                          ? NetworkImage(user.imageUrl)
                          : null,
                    ),
                    title: Text(
                      user.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  );
                },
              );
              break;
          }
        },
      ),
    );
  }
}
