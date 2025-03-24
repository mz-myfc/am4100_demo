import 'dart:async';
import 'dart:io';

import 'package:am4000_demo/utils/helper.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'load.dart';
import 'parse.dart';

/*
 * @Description Bluetooth
 * @Author ZL
 * @Date：2025-03-19 17:21:28
 */
class Ble {
  static Ble b = Ble._();
  Ble._();

  Uuid serviceUuid = Uuid.parse("49535343-FE7D-4AE5-8FA9-9FAFD205E455"); //seviceuuid
  Uuid characteristicUuidSend = Uuid.parse("49535343-1E4D-4BD9-BA61-23C647249616"); //device send to phone
  Uuid characteristicUuidReceive = Uuid.parse("49535343-8841-43F4-A8D4-ECBE34729BB3"); //phone write to device

  final ble = FlutterReactiveBle(); // Bluetooth instance
  BleStatus bleStatus = BleStatus.unknown; // Bluetooth status

  StreamSubscription<DiscoveredDevice>? scanSubscription; // Scan stream
  StreamSubscription<ConnectionStateUpdate>? connSubscription; // Connected device stream
  List<DiscoveredDevice> myDeviceArray = []; // Device list
  DiscoveredDevice? currentDevice; // Current device

  int startTime = DateTime.now().millisecondsSinceEpoch; // Start time
}

extension BluetoothExtension on Ble {
  Future<void> bleState() async {
    ble.statusStream.listen((status) => bleStatus = status);
    ble.connectedDeviceStream.listen((e) {
      if (e.connectionState == DeviceConnectionState.disconnected) {
        disconnect();
        Load.l.dismiss();
      }
    });
  }

  // Scan
  Future<void> scan() async {
    myDeviceArray = [];
    Load.l.showDevicePop(); // Show device list
    await stopScan(); // Stop scanning
    Future.delayed(const Duration(seconds: 1), () {
      scanSubscription = ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) => deviceList(device),
        onError: (e) => disconnect(),
      );
    }); // Stop scanning after 10 seconds
  }

  // Device list
  Future<void> deviceList(DiscoveredDevice device) async {
    if (device.name.isEmpty) return;
    var index = myDeviceArray.indexWhere((e) => e.id == device.id);
    if (index >= 0) {
      myDeviceArray[index] = device;
    } else {
      myDeviceArray.add(device);
    }
    // If the device is not connected, connect to it
    if (DateTime.now().millisecondsSinceEpoch - startTime >= 10000) {
      startTime = DateTime.now().millisecondsSinceEpoch;
      stopScan();
    }
    myDeviceArray.sort((a, b) => b.rssi.compareTo(a.rssi));
    Helper.h.refresh();
  }

  // Connect to device
  Future<void> connect(DiscoveredDevice device) async {
    await disconnect();
    connSubscription = ble.connectToDevice(
      id: device.id,
      servicesWithCharacteristicsToDiscover: {
        serviceUuid: [characteristicUuidSend, characteristicUuidReceive]
      },
    ).listen(
      (state) => connListener(state, device),
      onError: (_) => disconnect(),
    );
  }

  // Connection status
  Future<void> connListener(
      ConnectionStateUpdate state, DiscoveredDevice device) async {
    switch (state.connectionState) {
      case DeviceConnectionState.connecting:
        Load.l.loadAnimation();
        break;
      case DeviceConnectionState.connected:
        Load.l.dismiss();
        Parse.p.clear();
        currentDevice = device;
        await dataListener(device);
        Helper.h.refresh();
        break;
      case DeviceConnectionState.disconnected:
        currentDevice = device;
        Parse.p.clear();
        await disconnect();
        Load.l.dismiss();
        break; 
      case DeviceConnectionState.disconnecting:
        break;
    }
  }

  // Data stream
  Future<void> dataListener(DiscoveredDevice device) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuidSend,
      deviceId: device.id,
    );
    ble
        .subscribeToCharacteristic(characteristic)
        .listen((data) => Parse.p.parse(data), onError: (_) => disconnect());
  }

  // Disconnect
  Future<void> disconnect() async {
    try {
      if (Platform.isAndroid && currentDevice != null) {
        await ble.clearGattCache(currentDevice!.id);
      }
    } catch (_) {}
    await stopScan();
    currentDevice = null;
    Helper.h.refresh();
  }

  // Stop scanning
  Future<void> stopScan() async {
    await scanSubscription?.cancel();
    scanSubscription = null;
  }

  //send hex
  void writeHex(List<int> cmd) async { 
    if (currentDevice != null) { 
      final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuidReceive,
        deviceId: currentDevice!.id,
      );
      await ble.writeCharacteristicWithoutResponse(characteristic, value: cmd);
    }
  }
}
