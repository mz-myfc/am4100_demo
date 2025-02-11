import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'generated/l10n.dart';
import 'utils/ble/ble.dart';
import 'utils/ble/cmd.dart';
import 'utils/ble/permission.dart';
import 'utils/helper.dart';
import 'utils/notice.dart';
import 'utils/pop/pop.dart';

/*
 * @description Home Page
 * @author zl
 * @date 2024/9/24 10:33
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int lastExitTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () async {
      await WakelockPlus.enable();
      await Ble.helper.bleState();
      Helper.h.startTimer();
    });
    super.initState();
  }

  void handlerOnTap(Helper helper, int type) {
    helper.info.updateAll((key, value) => [Colors.deepPurple.shade300, false]);
    switch (type) {
      case 0:
        helper.info['0'] = [Colors.red, true];
        Ble.helper.writeHex(Cmd.EAR_TEMPERATURE_CALIBRATION);
        break;
      case 1:
        helper.info['1'] = [Colors.red, true];
        Ble.helper.writeHex(Cmd.EAR_TEMPERATURE_MODE);
        break;
      case 2:
        helper.info['2'] = [Colors.red, true];
        Ble.helper.writeHex(Cmd.TEMPERATURE_MODE);
        break;
    }
    helper.refresh();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('AM4100', style: _style()),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.bluetooth),
                onPressed: () {
                  Helper.h.startTimer();
                  PermissionHelper.helper.scanBluetooth(context: context);
                },
              ),
            ],
          ),
          body: ChangeNotifierProvider(
            data: Helper.h,
            child: Consumer<Helper>(
              builder: (context, helper) => Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _Item(title: S.current.ear_temp, value: helper.earTemp),
                    const SizedBox(height: 15),
                    _Item(title: S.current.body_temp, value: helper.bodyTemp),
                    const SizedBox(height: 15),
                    _Item(title: S.current.ambient_temp, value: helper.ambientTemp),
                    const SizedBox(height: 15),
                    _Item(title: S.current.object_temp, value: helper.objectTemp),
                    const SizedBox(height: 15),
                    _Item(title: S.current.status_one, value: helper.s1),
                    const SizedBox(height: 15),
                    _Item(title: S.current.status_two, value: helper.s2),
                    const SizedBox(height: 15),
                    _Item(title: S.current.status_three, value: helper.s3),
                    const SizedBox(height: 50),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        _Btn(
                          title: S.current.temp_calibration,
                          data: helper.info['0'],
                          radius: const [10, 0, 10, 0],
                          onTap: () => handlerOnTap(helper, 0),
                        ),
                        Container(width: 1, color: Colors.white),
                        _Btn(
                          title: S.current.ear_temp_mode,
                          data: helper.info['1'],
                          radius: const [0, 0, 0, 0],
                          onTap: () => handlerOnTap(helper, 1),
                        ),
                        Container(width: 1, color: Colors.white),
                        _Btn(
                          title: S.current.object_temp_mode,
                          data: helper.info['2'],
                          radius: const [0, 10, 0, 10],
                          onTap: () => handlerOnTap(helper, 2),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text('v1.0', style: _style(Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
        onPopInvokedWithResult: (_, v) {
          int nowExitTime = DateTime.now().millisecondsSinceEpoch;
          if (nowExitTime - lastExitTime > 2000) {
            lastExitTime = nowExitTime;
            Pop.helper.toast(msg: S.current.exit_app);
          } else {
            Helper.h.clean();
            WakelockPlus.disable();
            //Exit APP
            if (Platform.isAndroid) {
              SystemNavigator.pop(); //android
            } else if (Platform.isIOS) {
              exit(0); //iOS
            }
          }
        },
      );
}

class _Item extends StatelessWidget {
  const _Item({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(title, style: _style()),
          const Spacer(),
          Text(value, style: _style()),
        ],
      );
}

class _Btn extends StatelessWidget {
  const _Btn({
    required this.title,
    required this.data,
    required this.radius,
    this.onTap,
  });

  final String title;
  final List<dynamic> data;
  final List<double> radius;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onTap,
          child: Column(
            children: [
              Text(data[1] ? '▼' : '', style: _style(Colors.red)),
              Container(
                alignment: Alignment.center,
                height: 45,
                decoration: BoxDecoration(
                  color: data[0],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius[0]),
                    topRight: Radius.circular(radius[1]),
                    bottomLeft: Radius.circular(radius[2]),
                    bottomRight: Radius.circular(radius[3]),
                  ),
                ),
                child: Text(
                  title,
                  style: _style(Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
}

TextStyle _style([Color? c]) =>
    TextStyle(fontSize: 15, color: c ?? Colors.black);
