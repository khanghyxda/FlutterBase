import 'dart:async';
import 'package:sapp/utils/network.dart';

class RoomService {
  static Future getList() {
    return Network.callApi('/room/getlist');
  }

  static Future getWaiting() {
    return Network.callApi('/room/getwaiting');
  }

  static Future requestClean(roomId) {
    var data = {};
    data['roomId'] = roomId;
    return Network.callApi('/room/requestclean', data);
  }

  static Future cleaned(roomId) {
    var data = {};
    data['roomId'] = roomId;
    return Network.callApi('/room/cleaned', data);
  }

  static Future create(data) {
    return Network.callApi('/room/create', data);
  }

  static Future update(data) {
    return Network.callApi('/room/update', data);
  }

  static Future delete(roomId) {
    var data = {};
    data['roomId'] = roomId;
    return Network.callApi('/room/delete', data);
  }
}
