// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Cmd {
  static Uuid SERVICE_UUID                = Uuid.parse("49535343-FE7D-4AE5-8FA9-9FAFD205E455"); //service uuid
  static Uuid CHARACTERISTIC_UUID_SEND    = Uuid.parse("49535343-1E4D-4BD9-BA61-23C647249616"); //device send to phone
  static Uuid CHARACTERISTIC_UUID_RECEIVE = Uuid.parse("49535343-8841-43F4-A8D4-ECBE34729BB3"); //phone write to device

  static List<int> EAR_TEMPERATURE_CALIBRATION = [0x55, 0xAA, 0x04, 0x60, 0x10, 0x8B]; //ear temperature calibration 0x10
  static List<int> EAR_TEMPERATURE_MODE        = [0x55, 0xAA, 0x04, 0x60, 0x00, 0x9B]; //ear temperature mode 0x00(default)
  static List<int> TEMPERATURE_MODE            = [0x55, 0xAA, 0x04, 0x60, 0x01, 0x9A]; //object temperature mode 0x01
}