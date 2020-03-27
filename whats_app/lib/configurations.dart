import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configurations extends StatefulWidget {
  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  var _auth = FirebaseAuth.instance;
  var _storage = FirebaseStorage.instance;
  var _db = Firestore.instance;
  var _idLoggedUser = "";
  var _imageUrl = "";
  var _uploadingImage = false;
  var _controllerName = TextEditingController();
  File _image;

  Future _recoverImage(String imageOrigin) async {
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

    setState(() {
      _image = selectedImage;
      if (_image != null) {
        _uploadingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    var root = _storage.ref();
    var file = root.child("profile").child("$_idLoggedUser.jpg");

    var task = file.putFile(_image);
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
    _updateUrlImageFirestore(url);

    setState(() {
      _imageUrl = url;
    });
  }

  _updateUrlImageFirestore(String url) {
    var updateData = {"imageUrl": url};

    _db.collection("users").document(_idLoggedUser).updateData(updateData);
  }

  _updateNameFirestore() {
    var name = _controllerName.text;
    var updateData = {"name": name};

    _db.collection("users").document(_idLoggedUser).updateData(updateData);
  }

  _recoverUser() async {
    var loggedUser = await _auth.currentUser();
    _idLoggedUser = loggedUser.uid;

    var snapshot = await _db.document(_idLoggedUser).get();
    var data = snapshot.data;
    _controllerName.text = data["name"];

    if (data["imageUrl"] != null) {
      _imageUrl = data["imageUrl"];
    }
  }

  @override
  void initState() {
    super.initState();
    _recoverUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: _uploadingImage
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          value: 0.25,
                        )
                      : Container(),
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        _imageUrl != null ? NetworkImage(_imageUrl) : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: () {
                        _recoverImage("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: () {
                        _recoverImage("gallery");
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide()),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: _updateNameFirestore,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
