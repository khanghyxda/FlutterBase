import 'dart:async';
import 'package:sapp/utils/network.dart';

class RoomTypeService {
  static Future getList() {
    return Network.callApi('/roomtype/getlist');
  }

  static Future create(data) {
    return Network.callApi('/roomtype/create', data);
  }

  static Future update(data) {
    return Network.callApi('/roomtype/update', data);
  }

  static Future delete(roomTypeId) {
    var data = {};
    data['roomTypeId'] = roomTypeId;
    return Network.callApi('/roomtype/delete', data);
  }
}
