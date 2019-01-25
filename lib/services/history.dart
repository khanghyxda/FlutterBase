import 'dart:async';
import 'package:sapp/utils/network.dart';

class HistoryService {

  static Future search(data) {
    return Network.callApi('/history/search', data);
  }

  static Future getInfo(rentId) {
    var data = {};
    data['rentId'] = rentId;
    return Network.callApi('/history/getinfo', data);
  }

  static Future update(data) {
    return Network.callApi('/history/update', data);
  }
}
