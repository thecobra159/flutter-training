class Conversation {
  String _name;
  String _message;
  String _picPath;

  Conversation(this._name, this._message, this._picPath);

  String get picPath => _picPath;

  String get message => _message;

  String get name => _name;
}