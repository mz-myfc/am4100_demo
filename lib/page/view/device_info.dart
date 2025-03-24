import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/helper.dart';
import '../../utils/notifier.dart';

/*
 * @Description Device Info
 * @Author ZL
 * @Date：2025-03-21 12:56:59
 */
class DeviceInfo extends StatelessWidget {
  const DeviceInfo({super.key});

  @override
  Widget build(BuildContext context) => Consumer<Helper>(
        builder: (context, helper) => Column(
          children: [
            Row(
              children: [
                Text(S.current.device_name),
                const Spacer(),
                Text(
                  Helper.h.processDeviceName(
                      helper.ble.currentDevice?.name ?? '--'),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(S.current.device_mac),
                const Spacer(),
                Text(helper.ble.currentDevice?.id ?? '--'),
              ],
            ),
          ],
        ),
      );
}
