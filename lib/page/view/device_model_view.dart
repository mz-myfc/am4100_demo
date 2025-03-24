import 'package:am4000_demo/utils/parse.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/ble.dart';
import '../../utils/helper.dart';
import '../../utils/notifier.dart';

/*
 * @Description Device Model View
 * @Author ZL
 * @Date：2025-03-21 17:39:43
 */
class DeviceModelView extends StatelessWidget {
  const DeviceModelView({super.key});

  @override
  Widget build(BuildContext context) => Consumer<Helper>(
        builder: (context, helper) => Column(
          children: [
            _Item(title: S.current.ear_temp, value: helper.parse.earTemp),
            const SizedBox(height: 15),
            _Item(title: S.current.body_temp, value: helper.parse.bodyTemp),
            const SizedBox(height: 15),
            _Item(title: S.current.ambient_temp, value: helper.parse.ambTemp),
            const SizedBox(height: 15),
            _Item(title: S.current.object_temp, value: helper.parse.objTemp),
            const SizedBox(height: 15),
            _Item(title: S.current.status_one, value: helper.parse.statusOne),
            const SizedBox(height: 15),
            _Item(title: S.current.status_two, value: helper.parse.statusTwo),
            const SizedBox(height: 15),
            _Item(title: S.current.status_three, value: helper.parse.statusThree),
            const SizedBox(height: 10),
            Flex(
              direction: Axis.horizontal,
              children: [
                _Btn(
                  title: S.current.temp_calibration,
                  data: helper.parse.info['0'],
                  radius: const [10, 0, 10, 0],
                  onTap: () => handlerOnTap(helper, 0),
                ),
                Container(width: 1, color: Colors.white),
                _Btn(
                  title: S.current.ear_temp_mode,
                  data: helper.parse.info['1'],
                  radius: const [0, 0, 0, 0],
                  onTap: () => handlerOnTap(helper, 1),
                ),
                Container(width: 1, color: Colors.white),
                _Btn(
                  title: S.current.object_temp_mode,
                  data: helper.parse.info['2'],
                  radius: const [0, 10, 0, 10],
                  onTap: () => handlerOnTap(helper, 2),
                ),
              ],
            ),
          ],
        ),
      );

  void handlerOnTap(Helper helper, int type) {
    helper.parse.info.updateAll((key, value) => [Colors.deepPurple.shade300, false]);
    switch (type) {
      case 0:
        helper.parse.info['0'] = [Colors.red, true];
        Ble.b.writeHex(Parse.p.earTemperatureCalibration);
        break;
      case 1:
        helper.parse.info['1'] = [Colors.red, true];
        Ble.b.writeHex(Parse.p.earTemperatureMode);
        break;
      case 2:
        helper.parse.info['2'] = [Colors.red, true];
        Ble.b.writeHex(Parse.p.temperatureMode);
        break;
    }
    helper.refresh(); 
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(title),
          const Spacer(),
          Text(value),
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
              Text(data[1] ? '▼' : '', style: _style(color: Colors.red)),
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
                  style: _style(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
}

TextStyle _style({Color? color, double? fontSize}) =>
    TextStyle(fontSize: fontSize ?? 15, color: color ?? Colors.black);
