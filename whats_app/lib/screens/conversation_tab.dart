import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/model/conversation.dart';
import 'package:whats_app/model/user.dart';

class ConversationTab extends StatefulWidget {
  @override
  _ConversationTabState createState() => _ConversationTabState();
}

class _ConversationTabState extends State<ConversationTab> {
  var _db = Firestore.instance;
  var _auth = FirebaseAuth.instance;
  var _idLoggedUser = "";
  var _conversationsList = List<Conversation>();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _recoverUser() async {
    var loggedUser = await _auth.currentUser();
    _idLoggedUser = loggedUser.uid;

    _addConversationListener();
  }

  void _addConversationListener() {
    _db
        .collection("conversations")
        .document(_idLoggedUser)
        .collection("last_conversation")
        .snapshots()
        .listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _recoverUser();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar mensagens");
            } else {
              QuerySnapshot data = snapshot.data;
              if (data.documents.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma conversa ainda!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return Container(
                child: ListView.builder(
                  itemCount: _conversationsList.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> conversations = data.documents.toList();
                    DocumentSnapshot conversation = conversations[index];
                    var user = User(conversation["name"], conversation["email"],
                        conversation["imageUrl"]);
                    user.userId = conversation["receiverUserId"];

                    var imageUrl = conversation["imageUrl"];
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
                        backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl) : null,
                      ),
                      title: Text(
                        conversation["name"].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          conversation["messageType"] == "text"
                              ? Text(
                            conversation["message"],
                            style: TextStyle(
                                color: Colors.grey, fontSize: 13),
                          )
                              : Icon(Icons.image),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            break;
        }
      },
    );
  }
}
