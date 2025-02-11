import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/*
 * @description Bluetooth devices
 * @author zl
 * @date 2024/9/24 10:33
 */
class BleDevice {
  late DiscoveredDevice device;
  late int rssi;
  late bool isConnected;

  BleDevice(this.device, this.rssi, this.isConnected);
}
