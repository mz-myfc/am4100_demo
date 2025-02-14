import 'dart:async';

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'parse.dart';
import 'wave/wave_line.dart';

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

  num value = 0;

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
    if (array.isEmpty) return;
    switch (type) {
      case 0x01:
        _ecgWave(array[0]); // ECG waveform
        break;
      case 0x02:
        _hrResp(array); //heart rate & respiration rate
        break;
      case 0x03:
        _nibp(array); //blood pressure
        break;
      case 0x04:
        _spo2Pr(array); // Blood oxygen & pulse rate
        break;
      case 0x05:
        _temp(array); // Temperature
        break;
      case 0x06:
        _status(array); // Status information
        break;
      case 0xFE:
        _spo2Wave(array[0]); // Blood oxygen waveform
        break;
      case 0xFF:
        _respWave(array[0]); // Respiration rate waveform
        break;
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
    DrawLine.instance.init();
  }

  //heart rate & Respiration rate
  void _hrResp(List<num> array) {
    var status = array[0].toInt() & 0x02;
    var hr = 0; //ECG
    var resp = 0; //RESP
    switch (array.length) {
      case 5:
        hr = status != 0 ? 0 : array[1].toInt();
        resp = status != 0 ? 0 : array[2].toInt();
        break;
      case 6:
        hr = status != 0 ? 0 : ((array[5].toInt() << 8) + array[1].toInt());
        resp = status != 0 ? 0 : array[2].toInt();
        break;
    }
    print('hr: $hr | resp: $resp');
  }

  //Blood pressure
  void _nibp(List<num> array) {
    var state = (array[0].toInt() & (32 | 16 | 8 | 4)) >> 2;
    var sys = 0;
    var dia = 0;
    var map = 0.0;
    if (state == 0 || state == 7) {
      sys = array[2].toInt();
      map = array[3].toDouble();
      dia = array[4].toInt();
    }
    print('sys: $sys | dia: $dia | map: $map');
  }

  //Blood oxygen and pulse rate
  void _spo2Pr(List<num> array) {
    var spo2 = array[0] == 0 ? array[1] : 0;
    var pr = 0;
    switch (array.length) {
      case 3:
        pr = array[2].toInt() == 255 ? 0 : array[2].toInt();
        break;
      case 4:
        pr = array[2].toInt() | (array[3].toInt() << 8);
        if (pr == 0xFF00) pr = 0;
        break;
      default:
        pr = 0;
        break;
    }
    print('spo2: $spo2 | pr: $pr');
  }

  // Temperature
  void _temp(List<num> array) {
    if (array[0] == 0x40) {
      earTemp = '${array[1]}.${array[2]}';
    } else if (array[0] == 0x00) {
      bodyTemp = '${array[1]}.${array[2]}';
    }
  }

  // Status information
  void _status(List<num> array) {
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
  }

  // ECG waveform
  void _ecgWave(num value) {
    //Refer to _spo2Wave
  }

  // Blood oxygen waveform
  void _spo2Wave(num value) {
    DrawLine.instance.drawWave(value);
    refresh();
  }

  // Respiration rate waveform
  void _respWave(num value) {
    //Refer to _spo2Wave
  }
}
