import 'dart:async';
import 'package:sapp/utils/network.dart';

class InventoryService {
  static Future getStatus() {
    return Network.callApi('/inventory/getstatus');
  }
}
