import 'dart:async';
import 'package:sapp/utils/network.dart';

class RuleService {

  static Future getList() {
    return Network.callApi('/rule/getlist');
  }

  static Future create(data) {
    return Network.callApi('/rule/create', data);
  }

  static Future update(data) {
    return Network.callApi('/rule/update', data);
  }

  static Future delete(ruleId) {
    var data = {};
    data['ruleId'] = ruleId;
    return Network.callApi('/rule/delete', data);
  }
}