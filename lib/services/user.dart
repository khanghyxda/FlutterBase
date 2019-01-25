import 'dart:async';
import 'package:sapp/utils/network.dart';

class UserService {
  static Future login(username, password) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    data['keepLogin'] = true;
    data['isMobile'] = true;
    return Network.callApi('/user/login', data);
  }

  static Future register(data) {
    return Network.callApi('/user/register', data);
  }

  static Future forgotPassword(data) {
    return Network.callApi('/user/forgotpassword', data);
  }

  static Future getInfo() {
    return Network.callApi('/user/getinfo');
  }

  static Future changePassword(data) {
    return Network.callApi('/user/changepassword', data);
  }
}
