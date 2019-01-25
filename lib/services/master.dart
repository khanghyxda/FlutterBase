import 'package:sapp/utils/network.dart';

class MasterService {
  static Future getInfo() {
    return Network.callApi('/master/getinfo');
  }

  static Future getUser() {
    return Network.callApi('/master/getuser');
  }
}