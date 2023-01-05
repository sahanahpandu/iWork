import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date {
  static String getDetailedTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd MMMM yyyy', 'ms');
    return formatter.format(now);
  }

  static String getTheDate3(passDate, reqFormat, stateId) {
    // print('Date: $passDate');
    String theDate = "";
    late DateTime convertTheDate;

    if (passDate.runtimeType == DateTime) {
      convertTheDate = passDate;
    } else if (passDate.runtimeType == String) {
      convertTheDate = DateTime.parse(passDate);
    }

    theDate = DateFormat(
            reqFormat, (stateId != null || stateId != "") ? stateId : null)
        .format(convertTheDate);

    return theDate;
  }

  static String getTheDate(passDate, passFormat, reqFormat, stateId) {
    // print('Date: $passDate');

    String theDate = "";
    late DateTime convertTheDate;

    //to check and convert passDate to DateTime datatype
    //if the passDate is DateTime no need to pass passFormat
    if (passDate.runtimeType == DateTime) {
      convertTheDate = passDate;
    } else if (passDate.runtimeType == String) {
      convertTheDate = DateFormat(passFormat).parse(passDate);
    }

    //to get the request format
    theDate = DateFormat(
            reqFormat, (stateId != null || stateId != "") ? stateId : null)
        .format(convertTheDate);

    return theDate;
  }

  static TimeOfDay getTheTimeOfDay(passTime, reqFormat, stateId) {
    TimeOfDay theTime;

    DateTime convertTime = DateFormat(
            reqFormat, (stateId != null || stateId != "") ? stateId : null)
        .parse(passTime);

    theTime = TimeOfDay.fromDateTime(convertTime);

    return theTime;
  }
}
