import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pop/pop.dart';
import 'ble.dart';

/*
 * @description Permission
 * @author zl
 * @date 2024/9/24 10:51
 */
class PermissionHelper {
  static final PermissionHelper helper = PermissionHelper._();

  PermissionHelper._();

  /*
   * check permissions
   */
  void scanBluetooth({required BuildContext context}) async {
    BleStatus bleStatus = Ble.helper.bleStatus;
    if (Platform.isIOS) {
      await Permission.bluetooth.request();
      if (context.mounted && bleStatus == BleStatus.ready) {
        await Ble.helper.startScan();
      }
    } else {
      await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();
      if (context.mounted) {
        switch (bleStatus) {
          case BleStatus.ready: //bluetooth ready
            await Ble.helper.startScan();
            break;
          case BleStatus.unauthorized:
            _openPermission(context: context, type: 'app_location');
            break;
          case BleStatus.locationServicesDisabled:
            _openPermission(context: context, type: 'location');
            break;
          case BleStatus.poweredOff:
            _openPermission(context: context, type: 'bluetooth');
            break;
          case BleStatus.unsupported:
          case BleStatus.unknown:
            Pop.helper.toast(msg: 'Check Bluetooth');
            break;
        }
      }
    }
  }

  ///request permission
  void _openPermission({
    required BuildContext context,
    required String type,
  }) {
    switch (type) {
      case 'app_location':
        Permission.location.request().then((value) {
          if (value.isDenied || value.isPermanentlyDenied) {
            Pop.helper.dismiss();
            openAppSettings();
          } else {
            Ble.helper.startScan();
          }
        });
        break;
      case 'location':
        Pop.helper.dismiss();
        openLocation();
        break;
      case 'bluetooth':
        Pop.helper.dismiss();
        openBluetooth();
        break;
    }
  }

  void openLocation() => AppSettings.openAppSettings(type: AppSettingsType.location);

  void openAppSettings() => AppSettings.openAppSettings();

  void openBluetooth() => AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
}
