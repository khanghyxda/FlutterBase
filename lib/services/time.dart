import 'dart:async';
import 'package:sapp/utils/network.dart';

class TimeService {
  static Future getNow() {
    return Network.callApi('/time/now');
  }
}
