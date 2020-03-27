import 'package:flutter/material.dart';

import 'model/user.dart';

class Messages extends StatefulWidget {
  final User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _controllerMessage = TextEditingController();
  var listMessages = ["Olá", "Turupom?", "Coca", "Sprite"];

  _sendMessage() {}

  _sendPhoto() {}

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextField(
                controller: _controllerMessage,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide()),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _sendPhoto,
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075e54),
            child: Icon(Icons.send, color: Colors.white),
            mini: true,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
        itemCount: listMessages.length,
        itemBuilder: (context, index) {
          var alignment = Alignment.centerRight;
          var color = Color(0xffd2ffa5);
          if (index % 2 == 0) {
            alignment = Alignment.centerLeft;
            color = Colors.white;
          }

          return Align(
            alignment: alignment,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Text(
                  listMessages[index],
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                listView,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
