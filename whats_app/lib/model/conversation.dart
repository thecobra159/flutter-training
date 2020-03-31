import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String _idSender;
  String _idReceiver;
  String _name;
  String _message;
  String _picPath;
  String _typeMessage;

  Conversation.emptyConstructor();

  Conversation(this._name, this._message, this._picPath);

  save() async {
    Firestore db = Firestore.instance;
    await db
        .collection("conversations")
        .document(this.idSender)
        .collection("last_conversation")
        .document(this.idReceiver)
        .setData(this.toMap());
  }

  String get picPath => _picPath;

  String get message => _message;

  String get name => _name;

  String get typeMessage => _typeMessage;

  set typeMessage(String value) {
    _typeMessage = value;
  }

  String get idReceiver => _idReceiver;

  set idReceiver(String value) {
    _idReceiver = value;
  }

  String get idSender => _idSender;

  set idSender(String value) {
    _idSender = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": this._idSender,
      "receiverUserId": this._idReceiver,
      "name": this._name,
      "message": this._message,
      "imageUrl": this._picPath,
      "typeMessage": this._typeMessage,
    };
  }
}
