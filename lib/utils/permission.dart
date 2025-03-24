import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../generated/l10n.dart';
import 'ble.dart';
import 'load.dart';

/*
 * @Description Permission
 * @Author ZL
 * @Date：2025-03-19 16:16:25
 */

class PermissionHelper {
  static PermissionHelper ph = PermissionHelper._();
  PermissionHelper._();

  Future<void> scanBle() async {
    var bleStatus = Ble.b.bleStatus;
    if (Platform.isIOS) {
      await Permission.bluetooth.request();
      if (bleStatus == BleStatus.ready) {
        await Ble.b.scan();
      }
    } else {
      await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();
      switch (bleStatus) {
        case BleStatus.ready:
          await Ble.b.scan();
          break;
        case BleStatus.unauthorized:
          await Permission.location.request().then((value) {
            if (value.isDenied || value.isPermanentlyDenied) {
              Load.l.show(msg: S.current.app_location_msg, onTap: openAppSettings);
            }
          });
          break;
        case BleStatus.locationServicesDisabled:
          Load.l.show(msg: S.current.location_msg, onTap: openLocation);
          break;
        case BleStatus.poweredOff:
          Load.l.show(msg: S.current.bluetooth_msg, onTap: openBluetooth);
          break;
        case BleStatus.unknown:
        case BleStatus.unsupported:
          Load.l.toast(msg: S.current.bluetooth_status);
          break;
      }
    }
  }

  void openLocation() {
    Load.l.dismiss();
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  void openAppSettings() {
    Load.l.dismiss();
    AppSettings.openAppSettings();
  }

  void openBluetooth() {
    Load.l.dismiss();
    AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
  }
}
