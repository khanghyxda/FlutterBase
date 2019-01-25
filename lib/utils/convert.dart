import 'package:intl/intl.dart';

class Convert {
  static toMoney(dynamic str) {
    final oCcy = new NumberFormat("#,###");
    try {
      return oCcy.format(int.parse(str.toString())) + "đ";
    } catch (e) {
      return "0đ";
    }
  }

  static toMoneyNormal(dynamic str) {
    final oCcy = new NumberFormat("#,###");
    try {
      return oCcy.format(int.parse(str.toString()));
    } catch (e) {
      return "0";
    }
  }
}

convertIntNull(dynamic obj) {
  return obj == null ? '' : obj.toString();
}
