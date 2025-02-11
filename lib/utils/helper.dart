import 'dart:async';

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'parse.dart';

/*
 * @description Helper
 * @author zl
 * @date 2024/9/24 10:54
 */
class Helper extends ChangeNotifier {
  static final Helper h = Helper._();

  Helper._();

  Timer? timer;

  String earTemp = '--'; //Ear Temperature
  String bodyTemp = '--'; //Body Temperature
  String ambientTemp = '--'; //Ambient Temperature
  String objectTemp = '--'; //Object Temperature
  String s1 = '--'; //Wait for 37 °C calibration
  String s2 = '--'; //Wait for 42 °C calibration
  String s3 = '--'; //Calibration Complete

  Map<String, dynamic> info = {
    '0': [Colors.deepPurple.shade300, false],
    '1': [Colors.deepPurple.shade300, false],
    '2': [Colors.deepPurple.shade300, false],
  };

  //initialize
  void clean() {
    Parse.instance.init();
    earTemp = '--';
    bodyTemp = '--';
    ambientTemp = '--';
    objectTemp = '--';
    s1 = '--';
    s2 = '--';
    s3 = '--';

    info = {
      '0': [Colors.deepPurple.shade300, false],
      '1': [Colors.deepPurple.shade300, false],
      '2': [Colors.deepPurple.shade300, false],
    };
    Helper.h.stopTimer();
    refresh();
  }

  //Updated UI
  void refresh() => notifyListeners();

  void readData(int type, List<num> array) {
    if (array.isNotEmpty) {
      switch (type) {
        case 0x05:
          if (array[0] == 0x40) {
            earTemp = '${array[1]}.${array[2]}';
          } else if (array[0] == 0x00) {
            bodyTemp = '${array[1]}.${array[2]}';
          }
          break;
        case 0x06:
          if (array[0] == 0x40) {
            ambientTemp = '${array[1]}.${array[2]}';
          } else if (array[0] == 0x20) {
            objectTemp = '${array[1]}.${array[2]}';
          } else if (array[0] == 0xDD) {
            s1 = S.current.thirty_seven_wait;
          } else if (array[0] == 0xEE) {
            s1 = S.current.thirty_seven_complete;
            s2 = S.current.forty_two_wait;
          } else if (array[0] == 0xFF) {
            s2 = S.current.forty_two_complete;
            s3 = S.current.calibration_complete;
          }
          break;
      }
    }
  }

  void startTimer() {
    clean();
    stopTimer();
    timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      refresh();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }
}

extension Format on num {
  String get asFixed => this > 0 ? toStringAsFixed(1) : '--';
}
