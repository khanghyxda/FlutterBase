import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DT {
  static String timeToSecond = 'dd/MM/yyyy HH:mm:ss';

  static String timeToMinute = 'dd/MM/yyyy HH:mm';

  static String formatDatetime = 'dd/MM/yyyy HH:mm';

  static String formatDate = 'dd/MM/yyyy';

  static String formatTime = 'HH:mm';

  static toTime(String str) {
    var formatter = new DateFormat(timeToSecond);
    return formatter.parse(str);
  }

  static DateTime stringToDate(String str, String format) {
    var formatter = new DateFormat(format);
    return formatter.parse(str);
  }

  static String getTextBefore(now, timeBefore) {
    DateTime momentNow = toTime(now);
    DateTime momentTimeBefore = DateTime.parse(timeBefore);
    Duration duration = momentNow.difference(momentTimeBefore);
    if (duration.inMilliseconds < 0) {
      return '';
    }
    if (duration.inDays >= 1) {
      return duration.inDays.floor().toString() + ' ngày trước';
    }
    if (duration.inHours >= 1) {
      return duration.inHours.floor().toString() + ' giờ trước';
    } else {
      return duration.inMinutes.floor().toString() + ' phút trước';
    }
  }

  static String getTextDuration(now, timeBefore) {
    DateTime momentNow = toTime(now);
    DateTime momentTimeBefore = DateTime.parse(timeBefore);
    Duration duration = momentNow.difference(momentTimeBefore);
    if (duration.inMilliseconds < 0) {
      return '';
    }
    if (duration.inDays >= 1) {
      return duration.inDays.floor().toString() +
          ' Ngày ' +
          getDurationHours(duration).toString() +
          ' Giờ';
    }
    if (duration.inHours >= 1) {
      return duration.inHours.floor().toString() +
          ' Giờ ' +
          getDurationMinutes(duration).toString() +
          ' Phút';
    } else {
      return duration.inMinutes.floor().toString() + ' Phút';
    }
  }

  static int getDurationMinutes(Duration duration) {
    return duration.inMinutes - (60 * duration.inHours.floor());
  }

  static int getDurationHours(Duration duration) {
    return duration.inHours - (24 * duration.inDays.floor());
  }

  static String toText(String str, String format) {
    return DT.dateToString(DateTime.parse(str), format);
  }

  static String svToText(String str, String format) {
    return DT.dateToString(DT.stringToDate(str, timeToSecond), format);
  }

  static String dateToString(DateTime date, String format) {
    return new DateFormat(format).format(date);
  }

  static String getPath(String str, String fmDate, String fmGet) {
    DateTime date = stringToDate(str, fmDate);
    return DateFormat(fmGet).format(date);
  }

  static int getHour(String str) {
    return int.parse(getPath(str, formatDatetime, 'H'));
  }

  static int getMinute(String str) {
    return int.parse(getPath(str, formatDatetime, 'm'));
  }

  static String getTime(String str) {
    DateTime date = stringToDate(str, formatDatetime);
    String formattedDate = DateFormat(formatTime).format(date);
    return formattedDate;
  }

  static String getDate(String str) {
    DateTime date = stringToDate(str, formatDatetime);
    String formattedDate = DateFormat(formatDate).format(date);
    return formattedDate;
  }

  static DateTime toDate(String str) {
    var formatter = new DateFormat(formatDatetime);
    return formatter.parse(str);
  }

  static String replaceDate(String oldStr, DateTime date) {
    print(getTime(oldStr));
    print(getDate(oldStr));
    String strReturn = dateToString(date, formatDate) + ' ' + getTime(oldStr);
    return strReturn;
  }

  static String replaceTime(String oldStr, TimeOfDay time) {
    String strReturn = getDate(oldStr) +
        " " +
        time.hour.toString().padLeft(2, '0') +
        ':' +
        time.minute.toString().padLeft(2, '0');
    return strReturn;
  }

  static Duration getDuration(String startTime, String endTime) {
    DateTime start = stringToDate(startTime, formatDatetime);
    DateTime end = stringToDate(endTime, formatDatetime);
    return end.difference(start);
  }

  static String getDurationStr(String startTime, String endTime) {
    Duration duration = getDuration(startTime, endTime);
    if (duration.inMilliseconds < 0) {
      return '';
    }
    if (duration.inDays >= 1) {
      return duration.inDays.floor().toString() +
          ' Ngày ' +
          durationGetHours(duration).toString() +
          ' Giờ';
    } else {
      return duration.inHours.floor().toString() +
          ' Giờ ' +
          durationGetMinutes(duration).toString() +
          ' Phút';
    }
  }

  static int durationGetHours(Duration duration) {
    return (duration.inHours % 24).floor();
  }

  static int durationGetMinutes(Duration duration) {
    return (duration.inMinutes % 60).floor();
  }
}
