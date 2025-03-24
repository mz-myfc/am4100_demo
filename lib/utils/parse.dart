import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../page/wave/wave_line.dart';
import 'helper.dart';

/*
 * @Description Parse
 * @Author ZL
 * @Date：2025-03-19 16:15:42
 */
class Parse {
  static Parse p = Parse._();
  Parse._();

  int spo2 = -1; // Blood oxygen saturation
  int pr = -1; // Pulse rate
  int hr = -1; // Heart rate
  int sys = -1; // Systolic pressure
  double map = -1.0; // Mean arterial pressure
  int dia = -1; // Diastolic pressure
  double temp = -1; // Body temperature
  int resp = -1; // Respiratory rate

  String earTemp = '--'; // Ear temperature
  String bodyTemp = '--'; // Body temperature
  String ambTemp = '--'; // Ambient temperature
  String objTemp = '--'; // Object temperature
  String statusOne = '--'; // Status one (Wait for 37 °C calibration)
  String statusTwo = '--'; // Status two (Wait for 42 °C calibration)
  String statusThree = '--'; // Status three (Calibration Complete)

  Map<String, dynamic> info = {
    '0': [Colors.deepPurple.shade300, false],
    '1': [Colors.deepPurple.shade300, false],
    '2': [Colors.deepPurple.shade300, false],
  };

  List<int> earTemperatureCalibration = [0x55, 0xAA, 0x04, 0x60, 0x10, 0x8B]; //ear temperature calibration 0x10
  List<int> earTemperatureMode        = [0x55, 0xAA, 0x04, 0x60, 0x00, 0x9B]; //ear temperature mode 0x00(default)
  List<int> temperatureMode           = [0x55, 0xAA, 0x04, 0x60, 0x01, 0x9A]; //object temperature mode 0x01

  List<int> buffArray = []; // Buffer Array
  void clear() {
    buffArray = [];
    spo2 = -1;
    pr = -1;
    hr = -1;
    sys = -1;
    map = -1.0;
    dia = -1;
    temp = -1;
    resp = -1;

    earTemp = '--';
    bodyTemp = '--';
    ambTemp = '--';
    objTemp = '--';
    statusOne = '--';
    statusTwo = '--';
    statusThree = '--';

    info = {
      '0': [Colors.deepPurple.shade300, false],
      '1': [Colors.deepPurple.shade300, false],
      '2': [Colors.deepPurple.shade300, false],
    };

    DrawLine.instance.resetSize(); 
  }

  // Parse the data from the array
  void parse(List<int> array) {
    buffArray += array;
    var index = 0; // Index of the buffer array
    var validIndex = 0; // Valid data index
    var maxIndex = buffArray.length - 7; // Maximum index of the buffer array
    while (index <= maxIndex) {
      if (buffArray[index] != 0x55 || buffArray[index + 1] != 0xAA) {
        index += 1;
        validIndex = index;
        continue;
      }
      var length = buffArray[index + 2]; // Length of the data
      var type = buffArray[index + 3]; // Type of the data
      var dataCount = length - 3; // Data count
      var packageLength = length + 2; // Package length
      // If no valid data is obtained, skip the two data
      if (dataCount <= 0) {
        index += 2;
        validIndex = index;
        continue;
      }
      // If the remaining data length is less than the data length of the current group, no processing is required in this loop
      if (index + packageLength > buffArray.length) {
        validIndex = index;
        break;
      }
      var checkSum = buffArray[index + 4 + dataCount] & 0xFF; // Checksum
      var sum = 0; // Sum of the data
      List<num> dataArray = []; // Data array
      for (var i = 0; i < dataCount; i++) {
        var value = buffArray[index + 4 + i] & 0xFF;
        sum += value;
        dataArray.add(value);
      }
      var realSum = (~(length + type + sum)) & 0xFF; // Real sum
      if (checkSum != realSum) {
        index += 2;
        validIndex = index;
        continue;
      }

      readData(type, dataArray); // Read the data

      index += packageLength;
      validIndex = index;
      continue;
    }
    buffArray = buffArray.sublist(validIndex); // Update the buffer array
  }

  // Read the data
  void readData(int type, List<num> array) {
    if (array.isEmpty) return;
    switch (type) {
      case 0x01:
        ecgWave(array[0]); // ECG wave
        break;
      case 0x02:
        hrResp(array); // Heart rate and respiratory rate
        break;
      case 0x03:
        nibp(array); // Blood pressure
        break;
      case 0x04:
        spo2Pr(array); // Blood oxygen saturation and pulse rate
        break;
      case 0x05:
        tempData(array); // Temperature
        break;
      case 0x06:
        status(array); // Status
        break;
      case 0xFE:
        spo2Wave(array[0]); // Blood oxygen saturation wave
        break;
      case 0xFF:
        respWave(array[0]); // Respiratory rate wave
        break;
    }
    Helper.h.refresh();
  }

  // Heart rate and respiratory rate
  void hrResp(List<num> array) {
    var status = array[0].toInt() & 0x02;
    var hr = -1;
    var resp = -1;
    switch (array.length) {
      case 5:
        hr = status == 0 ? array[1].toInt() : -1;
        resp = status == 0 ? array[2].toInt() : -1;
        break;
      case 6:
        hr = status == 0 ? (array[5].toInt() << 8) | array[1].toInt() : -1;
        resp = status == 0 ? array[2].toInt() : -1;
        break;
    }
    this.hr = hr;
    this.resp = resp;
  }

  // Blood pressure
  void nibp(List<num> array) {
    var status = (array[0].toInt() & (32 | 16 | 8 | 4)) >> 2;
    var sys = -1;
    var map = -1.0;
    var dia = -1;
    if (status == 0 || status == 7) {
      sys = array[2].toInt();
      map = array[3].toDouble();
      dia = array[4].toInt();
    }
    this.sys = sys;
    this.map = map;
    this.dia = dia;
  }

  // Blood oxygen saturation and pulse rate
  void spo2Pr(List<num> array) {
    var spo2 = array[0] == 0 ? array[1].toInt() : -1;
    if (spo2 == 127) spo2 = -1;
    var pr = -1;
    switch (array.length) {
      case 3:
        pr = array[2].toInt() != 255 ? array[2].toInt() : -1;
        break;
      case 4:
        pr = array[2].toInt() | (array[3].toInt() << 8);
        if (pr == 0xFF00) pr = -1;
        break;
    }
    this.spo2 = spo2;
    this.pr = pr;
  }

  // Temperature
  void tempData(List<num> array) {
    if (array[0] == 0x40) {
      earTemp = '${array[1]}.${array[2]}';
    } else if (array[0] == 0x00) {
      bodyTemp = '${array[1]}.${array[2]}';
    }
  }

  // Status
  void status(List<num> array) {
    if (array[0] == 0x40) {
      ambTemp = '${array[1]}.${array[2]}';
    } else if (array[0] == 0x20) {
      objTemp = '${array[1]}.${array[2]}';
    } else if (array[0] == 0xDD) {
      statusOne = S.current.thirty_seven_wait;
    } else if (array[0] == 0xEE) {
      statusOne = S.current.thirty_seven_complete;
      statusTwo = S.current.forty_two_wait;
    } else if (array[0] == 0xFF) {
      statusTwo = S.current.forty_two_complete;
      statusThree = S.current.calibration_complete;
    }
  }

  // ECG wave
  void ecgWave(num array) {}

  // Blood oxygen saturation wave
  void spo2Wave(num array) {
    DrawLine.instance.drawWave(array);
  }

  // Respiratory rate wave
  void respWave(num array) {}
}
