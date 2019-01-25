import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  UserInfo(
      this.username, this.password, this.userId, this.mainUserId, this.roles);

  String username;

  String password;

  int userId;

  int mainUserId;

  List<dynamic> roles;
}

class User {
  static setUserInfo(String username, String password) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('username', username);
    _prefs.setString('password', password);
  }

  static getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('username');
  }

  static getPassword() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('password');
  }

  static removeUserInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('username');
    _prefs.remove('password');
  }
}
