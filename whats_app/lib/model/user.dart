class User {
  String _userId;
  String _name;
  String _email;
  String _password;
  String _imageUrl;

  User(this._name, this._email, this._password);

  User.consturctor(this._name, this._email, this._imageUrl);

  String get password => _password;

  String get email => _email;

  String get name => _name;

  String get imageUrl => _imageUrl;

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this._name,
      "email": this._email,
    };
  }
}
