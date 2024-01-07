import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get_emg_data/provider/model_providers.dart';
import 'package:get_emg_data/util/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PairingButton extends ConsumerWidget {
  const PairingButton(
      {required bool this.isConnected, required int this.level, Key? key})
      : super(key: key);
  final bool isConnected;
  final int level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String s = "+";
    if (level >= 0) {
      s = level.toString();
    }
    return TextButton(
      child: CircularPercentIndicator(
        radius: 20.0,
        lineWidth: 3.0,
        percent: 1.0,
        center: Text(s,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
        progressColor: Colors.white,
      ),
      onPressed: () async {
        logger.i("search device");
        if (!isConnected) {
          ref
              .read(bleProvider.notifier)
              .getDeviceNameList()
              .then((deviceNameList) => {
                    showDialog(
                      context: context,
                      builder: (childContext) {
                        return SimpleDialog(
                          title: const Text("Select Device"),
                          children: deviceNameList
                              .map(
                                (String deviceName) => SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: "connecting...");
                                    ref
                                        .read(bleProvider.notifier)
                                        .connect(deviceName);
                                    Navigator.pop(context);
                                  },
                                  child: Text(deviceName),
                                ),
                              )
                              .toList(),
                        );
                      },
                    )
                  });
        } else {
          ref.read(bleProvider.notifier).disconnect();
        }
      },
    );
  }
}
