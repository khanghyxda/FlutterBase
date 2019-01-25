import 'package:sapp/utils/network.dart';

class ReportService {
  static Future getRentTimes() {
    return Network.callApi('/report/getrenttimes');
  }

  static Future getReportDay(dayBefore) {
    var data = {};
    data['dayBefore'] = dayBefore;
    return Network.callApi('/report/day', data);
  }

  static Future getReportMonth(monthBefore) {
    var data = {};
    data['monthBefore'] = monthBefore;
    return Network.callApi('/report/month', data);
  }

  static Future getReportMenu(monthBefore, month) {
    var data = {};
    data['monthBefore'] = monthBefore;
    data['month'] = month;
    return Network.callApi('/report/menu', data);
  }

  static Future getReportRoom(monthBefore, month) {
    var data = {};
    data['monthBefore'] = monthBefore;
    data['month'] = month;
    return Network.callApi('/report/room', data);
  }

  static Future getReportFromTo(data) {
    return Network.callApi('/report/fromto', data);
  }
}