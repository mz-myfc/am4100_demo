import 'package:flutter/material.dart';

import '../../utils/helper.dart';
import '../../utils/notifier.dart';

/*
 * @Description Real Value
 * @Author ZL
 * @Date：2025-03-06 14:06:21
 */
class RealValue extends StatelessWidget {
  const RealValue({super.key});

  @override
  Widget build(BuildContext context) => Consumer<Helper>(
        builder: (context, helper) => Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: MyBox(
                    title: 'SpO₂',
                    value: helper.parse.spo2,
                    unit: '%',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyBox(
                    title: 'PR',
                    value: helper.parse.pr,
                    unit: 'bpm',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: MyBox(
                    title: 'HR',
                    value: helper.parse.hr,
                    unit: 'bpm',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyBox(
                    title: 'BP',
                    value: [helper.parse.sys, helper.parse.dia],
                    unit: 'mmHg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: MyBox(
                    title: 'Temp',
                    value: helper.parse.temp,
                    unit: '°C',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyBox(
                    title: 'Resp',
                    value: helper.parse.resp,
                    unit: 'brpm',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class MyBox extends StatelessWidget {
  const MyBox({
    super.key,
    required this.title,
    required this.value,
    this.unit = '',
  });
  final String title;
  final dynamic value;
  final String unit;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.deepPurple.shade50,
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 3, left: 3, child: Text(title)),
            Text(Helper.h.processValue(value)),
            Positioned(right: 3, bottom: 3, child: Text(unit)),
          ],
        ),
      );
}
