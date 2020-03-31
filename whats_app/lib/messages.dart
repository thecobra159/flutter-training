import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/model/conversation.dart';
import 'package:whats_app/model/message.dart';

import 'model/user.dart';

class Messages extends StatefulWidget {
  final User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _auth = FirebaseAuth.instance;
  var _db = Firestore.instance;
  var _storage = FirebaseStorage.instance;
  var _controllerMessage = TextEditingController();
  var _uploadingImage = false;
  var _idLoggedUser = "";
  var _idReceiverUser = "";
  final _controller = StreamController<QuerySnapshot>.broadcast();
  var _scrollController = ScrollController();

  _sendMessage() {
    var messageToSend = _controllerMessage.text;
    if (messageToSend.isNotEmpty) {
      var imageUrl = "";
      var type = "text";
      var message = Message(_idLoggedUser, messageToSend, imageUrl, type);
      _saveMessage(_idLoggedUser, _idReceiverUser, message);
      _saveMessage(_idReceiverUser, _idLoggedUser, message);
      _saveConversation(message);
    }
  }

  _saveMessage(String idSender, String idReceiver, Message message) async {
    await _db
        .collection("messages")
        .document(idSender)
        .collection(idReceiver)
        .add(message.toMap());

    _controllerMessage.clear();
  }

  _sendPhoto(String imageOrigin) async {
    File selectedImage;
    switch (imageOrigin) {
      case "camera":
        selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "gallery":
        selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }
    var root = _storage.ref();
    var imageName = DateTime.now().millisecondsSinceEpoch;
    var file =
        root.child("messages").child(_idLoggedUser).child("$imageName.jpg");

    var task = file.putFile(selectedImage);
    task.events.listen((StorageTaskEvent storageTaskEvent) {
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (storageTaskEvent.type == StorageTaskEventType.success) {
        setState(() {
          _uploadingImage = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getImageUrl(snapshot);
    });
  }

  Future _getImageUrl(StorageTaskSnapshot snapshot) async {
    var url = await snapshot.ref.getDownloadURL();

    var imageUrl = url;
    var type = "text";
    var message = Message(_idLoggedUser, "", imageUrl, type);
    _saveMessage(_idLoggedUser, _idReceiverUser, message);
    _saveMessage(_idReceiverUser, _idLoggedUser, message);
  }

  _getMessages() {
    _db
        .collection("messages")
        .document(_idLoggedUser)
        .collection(_idReceiverUser)
        .snapshots()
        .listen((data) {
      _controller.add(data);
      Timer(Duration(milliseconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  _recoverUser() async {
    var loggedUser = await _auth.currentUser();
    _idLoggedUser = loggedUser.uid;

    _idReceiverUser = widget.contact.userId;
    _getMessages();
  }

  _showImageDialog() {
    print("Entrei");
    var galleyButton = FlatButton(
      child: Text("Galeria"),
      onPressed: _sendPhoto("gallery"),
    );
    var cameraButton = FlatButton(
      child: Text("Câmera"),
      onPressed: _sendPhoto("camera"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Fonte da imagem:"),
      actions: <Widget>[
        galleyButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return alert;
        });
  }

  _saveConversation(Message message) {
    var senderConversation = Conversation(widget.contact.name, message.toString(), widget.contact.imageUrl);
    senderConversation.idSender = _idLoggedUser;
    senderConversation.idReceiver = _idReceiverUser;
    senderConversation.typeMessage = message.messageType;
    senderConversation.save();

    var receiverConversation = Conversation(widget.contact.name, message.toString(), widget.contact.imageUrl);
    receiverConversation.idSender = _idReceiverUser;
    receiverConversation.idReceiver = _idLoggedUser;
    receiverConversation.typeMessage = message.messageType;
    receiverConversation.save();
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
                  prefixIcon: _uploadingImage
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => _showImageDialog,
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

    var stream = StreamBuilder(
      stream: _controller.stream,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar mensagens"),
              );
            } else {
              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.documents.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> messages = data.documents.toList();
                      DocumentSnapshot item = messages[index];
                      var alignment = Alignment.centerRight;
                      var color = Color(0xffd2ffa5);
                      if (_idLoggedUser != item["userId"]) {
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: item["messageType"] == "text"
                                ? Text(
                                    item["message"],
                                    style: TextStyle(fontSize: 14),
                                  )
                                : Image.network(item["imageUrl"]),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
            break;
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contact.imageUrl != null
                  ? NetworkImage(widget.contact.imageUrl)
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(widget.contact.name),
            ),
          ],
        ),
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
                stream,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
