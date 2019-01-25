import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sapp/common/user.dart';

class Network {
  static Future callApi(String path, [Object obj]) {
    if (obj == null) {
      obj = new Map<String, dynamic>();
    }
    
    final JsonDecoder _decoder = new JsonDecoder();
    final JsonEncoder _encoder = new JsonEncoder();

    String url = Network.link(path);
    String body = _encoder.convert(obj);
    String bearer = 'Bearer ' + Session.token;
    return http
        .post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': bearer,
            },
            body: body)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        return _decoder.convert(res);
      } else if (statusCode == 401) {
        throw Exception('401');
      } else {
        throw Exception(res);
      }
    });
  }

  static String link(String path) {
    return baseUrl() + path;
  }

  static String baseUrl() {
    // final String urlApi = 'https://apisa.azurewebsites.net';
    final String urlApi = 'url';
    return urlApi;
  }
}

class Session {
  static dynamic token = '';

  static UserInfo userInfo;

  static bool hasRole(List<String> rolesMenu) {
    var roles = Session.userInfo.roles;
    var flag = false;
    rolesMenu.forEach((r){
      if(roles.contains(r)){
        flag = true;
      }
    });
    return flag;
  }
}
