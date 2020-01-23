class User {
  String _name;
  String _email;
  String _password;

  User(this._name, this._email, this._password);

  String get password => _password;

  String get email => _email;

  String get name => _name;

  Map<String, dynamic> toMap() {
    return {
      "name": this._name,
      "email": this._email,
    };
  }
}