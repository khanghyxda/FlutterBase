import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:sapp/utils/color.dart';

emptyToNull(value) {
  if (value == '') {
    return null;
  }
  return value;
}

arrayToObj(arr, key) {
  var obj = {};
  arr.forEach((element) {
    obj[element[key]] = element;
  });
  return obj;
}

int sortPriority(dynamic o1, dynamic o2) {
  var n1 = o1['priority'] != null ? o1['priority'] : 0;
  var n2 = o2['priority'] != null ? o2['priority'] : 0;

  if (n1 > n2) {
    return 1;
  }

  if (n1 < n2) {
    return -1;
  }

  return 0;
}

int sortRent(dynamic o1, dynamic o2) {
  var n1 = o1['roomInfo'] == null || o1['roomInfo']['priority'] == null
      ? 0
      : o1['roomInfo']['priority'];
  var n2 = o2['roomInfo'] == null || o2['roomInfo']['priority'] == null
      ? 0
      : o2['roomInfo']['priority'];

  if (n1 > n2) {
    return 1;
  }

  if (n1 < n2) {
    return -1;
  }

  return 0;
}

contains(name, search) {
  if (search == null || search == '') {
    return true;
  }
  if (name.toString().toLowerCase().contains(search.toString().toLowerCase())) {
    return true;
  }
  return false;
}

getPropertyString(obj, key, property, [defaultValue = 'Không có thông tin']) {
  if (key == null || obj[key] == null || obj[key][property] == null) {
    return defaultValue;
  } else {
    return obj[key][property];
  }
}

getPropertyInt(obj, key, property, [defaultValue = 0]) {
  if (key == null || obj[key] == null || obj[key][property] == null) {
    return defaultValue;
  } else {
    return obj[key][property];
  }
}

validListMoney(List<TextEditingController> list) {
  list.forEach((element) {
    validMoney(element);
  });
}

validMoney(TextEditingController controller) {
  try {
    var value = int.tryParse(controller.text);
    if (value == null) {
      controller.text = 0.toString();
    }
  } catch (e) {
    controller.text = 0.toString();
  }
}

clone(object) {
  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();
  return _decoder.convert(_encoder.convert(object));
}

getMenuMoney(rentMenus) {
  var sum = 0;
  rentMenus.forEach((menu) {
    sum += menu['quantity'] * menu['price'];
  });
  return sum;
}

nullToEmpty(input) {
  if (input == null) {
    return "";
  }
  return input;
}

Widget getIconType(type, [size = 18.0]) {
  if (type == 1) {
    return Icon(
      Icons.access_time,
      color: AppColors.primary,
      size: size,
    );
  } else if (type == 2) {
    return Icon(
      Icons.brightness_3,
      color: Colors.black,
      size: size,
    );
  } else {
    return Icon(
      Icons.wb_sunny,
      color: Colors.yellow,
      size: size,
    );
  }
}

final fMoney = new NumberFormat("#,##0");
