class Message {
  String _userId;
  String _message;
  String _imageUrl;
  String _messageType;

  Message(this._userId, this._message, this._imageUrl, this._messageType);

  String get messageType => _messageType;

  String get imageUrl => _imageUrl;

  String get message => _message;

  String get userId => _userId;

  Map<String, dynamic> toMap() {
    return {
      "userId": this._userId,
      "message": this._message,
      "imageUrl": this._imageUrl,
      "messageType": this._messageType,
    };
  }
}
