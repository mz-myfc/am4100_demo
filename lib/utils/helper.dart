import 'package:flutter/material.dart';

import 'ble.dart';
import 'parse.dart';

/*
 * @Description Helper
 * @Author ZL
 * @Date：2025-03-06 14:03:25
 */
class Helper extends ChangeNotifier {
  static final Helper h = Helper._();

  Helper._();

  Parse parse = Parse.p;
  Ble ble = Ble.b;

  void refresh() => notifyListeners();

  // Processing data
  String processValue(dynamic v) {
    if (v is List) {
      var first = v.isNotEmpty && v[0] >= 0 ? '${v[0]}' : '--';
      var last = v.length >= 2 && v[1] >= 0 ? '${v[1]}' : '--';
      return '$first / $last';
    }
    return v >= 0 ? '$v' : '--';
  }

  // Processing device name
  String processDeviceName(String name) {
    if (name.codeUnits.contains(0)) {
      return name.split('').where((e) => e.codeUnitAt(0) != 0).join();
    }
    return name;
  }
}
