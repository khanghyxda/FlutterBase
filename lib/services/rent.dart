import 'dart:async';
import 'package:sapp/utils/network.dart';

class RentService {
  static Future getUsing() {
    return Network.callApi('/rent/getusing');
  }

  static Future checkin(roomId) {
    var data = {};
    data['roomId'] = roomId;
    return Network.callApi('/rent/checkin', data);
  }

  static Future delete(rentId) {
    var data = {};
    data['rentId'] = rentId;
    return Network.callApi('/rent/delete', data);
  }

  static Future getInfo(rentId) {
    var data = {};
    data['rentId'] = rentId;
    return Network.callApi('/rent/getinfo', data);
  }

  static Future addMenu(data) {
    return Network.callApi('/rent/addmenu', data);
  }

  static Future changeRoom(data) {
    return Network.callApi('/rent/changeroom', data);
  }

  static Future update(data) {
    return Network.callApi('/rent/update', data);
  }

  static Future checkout(data) {
    return Network.callApi('/rent/checkout', data);
  }

  static Future getHistory() {
    return Network.callApi('/rent/getHistory');
  }
}
