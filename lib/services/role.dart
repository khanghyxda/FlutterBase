import 'package:sapp/utils/network.dart';

class RoleService {
  static Future getList() {
    return Network.callApi('/role/getlist');
  }
}
