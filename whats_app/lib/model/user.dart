class User {
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

  Map<String, dynamic> toMap() {
    return {
      "name": this._name,
      "email": this._email,
    };
  }
}
