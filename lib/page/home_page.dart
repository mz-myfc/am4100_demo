import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../utils/ble.dart';
import '../utils/helper.dart';
import '../utils/notifier.dart';
import '../utils/permission.dart';
import 'view/device_info.dart';
import 'view/device_model_view.dart';
import 'view/real_value.dart';
import 'wave/wave_view.dart';

/*
 * @Description HomePage
 * @Author ZL
 * @Date：2025-03-06 13:10:41
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('AM4100'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.bluetooth),
              onPressed: () async {
                await PermissionHelper.ph.scanBle();
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider(
          data: Helper.h,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                DeviceInfo(),
                SizedBox(height: 10),
                RealValue(),
                WaveView(),
                SizedBox(height: 10),
                DeviceModelView(),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    WakelockPlus.disable();
    Ble.b.disconnect();
    super.dispose();
  }

  // Initialization
  void _init() {
    Future.delayed(const Duration(seconds: 1), () async {
      await WakelockPlus.enable();
      await Ble.b.bleState();
    });
  }
}
