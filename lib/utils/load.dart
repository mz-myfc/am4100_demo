import 'dart:math';

import 'package:am4000_demo/utils/ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../generated/l10n.dart';
import 'helper.dart';
import 'notifier.dart';

/*
 * @Description 
 * @Author ZL
 * @Date：2025-03-19 16:36:47
 */
class Load {
  static Load l = Load._();
  Load._();

  void dismiss() async => await SmartDialog.dismiss();

  ///Toast
  void toast({String msg = ''}) async {
    dismiss();
    await SmartDialog.showToast('',
        builder: (_) => ToastPop(msg: msg), displayType: SmartToastType.last);
  }

  ///Custom loading animations
  void loadAnimation({String? msg}) async {
    dismiss();
    await SmartDialog.show(
      builder: (_) => LoadAnimation(msg: msg),
    ).timeout(const Duration(seconds: 10), onTimeout: dismiss);
  }

  //Popup
  void show({required String msg, VoidCallback? onTap}) async {
    dismiss();
    await SmartDialog.show(
      builder: (_) => Popup(msg: msg, onTap: onTap),
    );
  }

  void showDevicePop() async {
    dismiss();
    await SmartDialog.show(
      builder: (_) => ChangeNotifierProvider(
        data: Helper.h,
        child: Consumer<Helper>(
          builder: (context, helper) => Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(S.current.device_list),
                      Positioned(
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: dismiss,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.separated(
                    itemCount: helper.ble.myDeviceArray.length,
                    itemBuilder: (context, index) {
                      var device = helper.ble.myDeviceArray[index];
                      return ListTile(
                        title: Text(Helper.h.processDeviceName(device.name)),
                        subtitle: Row(
                          children: [
                            Text("${device.id} Rssi: ${device.rssi}"),
                            const Spacer(),
                            Text(S.current.connect),
                          ],
                        ),
                        onTap: () async {
                          dismiss();
                          await Ble.b.connect(device);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 0.5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom toast
class ToastPop extends StatelessWidget {
  const ToastPop({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 50),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}

// Custom loading animations
class LoadAnimation extends StatefulWidget {
  const LoadAnimation({super.key, this.msg});
  final String? msg;

  @override
  State<StatefulWidget> createState() => _LoadAnimationState();
}

class _LoadAnimationState extends State<LoadAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              alignment: Alignment.center,
              turns: _controller,
              child: Image.asset(
                'assets/images/loading.png',
                height: 50,
                width: 50,
                color: Colors.black12,
              ),
            ),
            const SizedBox(height: 15),
            Text(widget.msg ?? '', style: const TextStyle(color: Colors.grey))
          ],
        ),
      );

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}

class Popup extends StatelessWidget {
  const Popup({super.key, required this.msg, this.onTap});
  final String msg;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 180,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(S.current.tips),
            const Spacer(),
            Text(msg),
            const Spacer(),
            Divider(height: 0.5, color: Colors.grey.shade300),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Load.l.dismiss(),
                    child: Text(S.current.cancel),
                  ),
                ),
                Container(height: 15, width: 1, color: Colors.grey),
                Expanded(
                  child: TextButton(
                    onPressed: onTap,
                    child: Text(S.current.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
