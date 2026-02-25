import 'package:flutter/services.dart';
import 'package:get_emg_data/component/app_scaffold.dart';
import 'package:get_emg_data/foundation/app_text_theme.dart';
import 'package:get_emg_data/util/logger.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get_emg_data/component/chart.dart';
import 'package:get_emg_data/util/func.dart';
import 'package:get_emg_data/provider/model_providers.dart';
import 'package:get_emg_data/component/app_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get_emg_data/provider/database_provider.dart';
import 'package:get_emg_data/foundation/database_const.dart';
import 'dart:io'; //ファイル出力用ライブラリ
import 'package:path_provider/path_provider.dart'; //アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class RawDataMeasurePage extends HookConsumerWidget {
  const RawDataMeasurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstAxis = useState(0);
    final secondAxis = useState(0);
    final firstMoveNum = useState(0);
    final secondMoveNum = useState(0);
    final tag1 = useState('-');
    final tag2 = useState('-');
    final tag3 = useState('-');
    final tag4 = useState('-');
    List<int> moveNumList = List.generate(100, (i) => i);
    double w = MediaQuery.of(context).size.width;
    int batteryLevel = ref.watch(bleProvider.select((ble) => ble.batteryLevel));
    int cnt =
        ref.watch(bleProvider.select((value) => value.measureRawData.cnt));
    List<double> timeList =
        ref.watch(bleProvider.select((value) => value.measureRawData.timeList));
    List<double> EMGList =
        ref.watch(bleProvider.select((value) => value.measureRawData.EMGList));
    List<double> Z1List =
        ref.watch(bleProvider.select((value) => value.measureRawData.Z1List));
    List<double> Z2List =
        ref.watch(bleProvider.select((value) => value.measureRawData.Z2List));
    List<double> Z3List =
        ref.watch(bleProvider.select((value) => value.measureRawData.Z3List));
    Color batteryColor = const Color.fromRGBO(255, 255, 255, 1.0);
    if (batteryLevel < 30) {
      batteryColor = const Color.fromRGBO(255, 0, 0, 1.0);
    }
    List<double> _x1 = [];
    List<double> _x2 = [];
    List<double> _y1 = [];
    List<double> _y2 = [];
    List<double> firstData;
    List<double> secondData;
    switch (firstAxis.value) {
      case 0:
        firstData = EMGList;
        break;
      case 1:
        firstData = Z1List;
        break;
      case 2:
        firstData = Z2List;
        break;
      case 3:
        firstData = Z3List;
        break;
      default:
        firstData = EMGList;
        break;
    }
    switch (secondAxis.value) {
      case 0:
        secondData = EMGList;
        break;
      case 1:
        secondData = Z1List;
        break;
      case 2:
        secondData = Z2List;
        break;
      case 3:
        secondData = Z3List;
        break;
      default:
        secondData = EMGList;
        break;
    }
    if (timeList.length >= 250) {
      _x1 = timeList.sublist(timeList.length - 250);
      _y1 = firstData.sublist(firstData.length - 250);
      _x2 = timeList.sublist(timeList.length - 250);
      _y2 = secondData.sublist(secondData.length - 250);
    } else {
      _x1 = timeList;
      _y1 = firstData;
      _x2 = timeList;
      _y2 = secondData;
    }
    //if (firstData.length > firstMoveNum.value + 5) {
    //  int s = firstData.length - 150 - 4 * firstMoveNum.value;
    //  if (s < 0) s = 0;
    //  if (s >= firstMoveNum.value + 5) {
    //    for (int i = s + firstMoveNum.value; i < firstData.length; i++) {
    //      //5秒
    //      _x1.add(timeList[i]);
    //      double mean = 0.0;
    //      for (int j = 0; j < firstMoveNum.value + 1; j++) {
    //        mean += firstData[i - j];
    //      }
    //      mean /= (firstMoveNum.value.toDouble() + 1.0);
    //      _y1.add(mean);
    //    }
    //  }
    //}
    //if (secondData.length > secondMoveNum.value + 5) {
    //  int s = secondData.length - 150 - 4 * secondMoveNum.value;
    //  if (s < 0) s = 0;
    //  if (s >= secondMoveNum.value + 5) {
    //    for (int i = s + secondMoveNum.value; i < secondData.length; i++) {
    //      //5秒
    //      _x2.add(timeList[i]);
    //      double mean = 0.0;
    //      for (int j = 0; j < secondMoveNum.value + 1; j++) {
    //        mean += secondData[i - j];
    //      }
    //      mean /= (secondMoveNum.value.toDouble() + 1.0);
    //      _y2.add(mean);
    //    }
    //  }
    //}
    //logger.i(_x1);
    //logger.i(_y1);
    //logger.i(_x2);
    //logger.i(_y2);

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppScaffold(
            appBar: AppBar(
              title: const Text(""),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Center(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: batteryLevel <= 0
                            ? TextButton(
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 3.0,
                                  percent: 1.0,
                                  center: const Text("+",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0)),
                                  progressColor: Colors.white,
                                ),
                                onPressed: () async {
                                  logger.i("try to connect");
                                  List<String> deviceNameList = await ref
                                      .read(bleProvider.notifier)
                                      .getDeviceNameList();
                                  print(deviceNameList);
                                  showDialog(
                                    context: context,
                                    builder: (childContext) {
                                      return SimpleDialog(
                                        title: const Text("Select Device"),
                                        children: deviceNameList
                                            .map(
                                              (String deviceName) =>
                                                  SimpleDialogOption(
                                                padding: EdgeInsets.all(20),
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg: "connecting...");
                                                  ref
                                                      .read(
                                                          bleProvider.notifier)
                                                      .connect(deviceName);
                                                  ref.read(databaseProvider).update(
                                                      "m_system_param",
                                                      {
                                                        DatabaseConst.system
                                                            .value: deviceName
                                                      },
                                                      "${DatabaseConst.system.name}='peripheral_name'");
                                                  Navigator.pop(context);
                                                },
                                                child: Text(deviceName),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                  );
                                  //ref.read(bleProvider.notifier).connect();
                                },
                              )
                            : TextButton(
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 3.0,
                                  percent: batteryLevel / 100.0,
                                  center: Text("$batteryLevel%",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  progressColor: batteryColor,
                                ),
                                onPressed: () {
                                  logger.i("disconnect");
                                  ref.read(bleProvider.notifier).disconnect();
                                },
                              )))
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        '生データ計測',
                        style: AppText.h6,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppButton(
                        text: "Save",
                        onPressed: () async {
                          var format = DateFormat('yyyy-MM-dd-HH-mm-ss');
                          String filename =
                              "hamaemg_${format.format(ref.read(bleProvider.notifier).measureRawData.now)}.csv";
                          saveFile(
                              ref
                                  .read(bleProvider.notifier)
                                  .measureRawData
                                  .csvTextData,
                              filename);
                          Fluttertoast.showToast(msg: "save data");
                        },
                        width: w * 0.3,
                      ),
                    ],
                  ),
                  ExpansionTile(
                      title: Text('設定', style: AppText.h6),
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('第1軸', style: AppText.body14),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        111, 132, 255, 1), //<-- SEE HERE
                                  ),
                                  child: DropdownButton<int?>(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 0,
                                          child: Text('ECG'),
                                        ),
                                        DropdownMenuItem(
                                          value: 1,
                                          child: Text('Z1'),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: Text('Z2'),
                                        ),
                                        DropdownMenuItem(
                                          value: 3,
                                          child: Text('Z3'),
                                        ),
                                      ],
                                      onChanged: (int? value) {
                                        firstAxis.value = value!;
                                      },
                                      value: firstAxis.value)),
                              Container(
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white, //<-- SEE HERE
                                  ),
                                  child: DropdownButton<int>(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: moveNumList
                                          .map((int num) => DropdownMenuItem(
                                              value: num,
                                              child: Text(num.toString())))
                                          .toList(),
                                      onChanged: (int? value) {
                                        firstMoveNum.value = value!;
                                      },
                                      value: firstMoveNum.value)),
                              const SizedBox(
                                width: 30,
                              ),
                              Text('第2軸', style: AppText.body14),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                        255, 255, 125, 125), //<-- SEE HERE
                                  ),
                                  child: DropdownButton<int?>(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 0,
                                          child: Text('ECG'),
                                        ),
                                        DropdownMenuItem(
                                          value: 1,
                                          child: Text('Z1'),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: Text('Z2'),
                                        ),
                                        DropdownMenuItem(
                                          value: 3,
                                          child: Text('Z3'),
                                        ),
                                      ],
                                      onChanged: (int? value) {
                                        secondAxis.value = value!;
                                      },
                                      value: secondAxis.value)),
                              Container(
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white, //<-- SEE HERE
                                  ),
                                  child: DropdownButton<int>(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: moveNumList
                                          .map((int num) => DropdownMenuItem(
                                              value: num,
                                              child: Text(num.toString())))
                                          .toList(),
                                      onChanged: (int? value) {
                                        secondMoveNum.value = value!;
                                      },
                                      value: secondMoveNum.value)),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "t1",
                                style: AppText.body14,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                  child: TextField(
                                enabled: true,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (e) {
                                  tag1.value = e;
                                },
                              )),
                              const SizedBox(width: 10),
                              Text(
                                "t2",
                                style: AppText.body14,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                  child: TextField(
                                enabled: true,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (e) {
                                  tag2.value = e;
                                },
                              )),
                              const SizedBox(width: 10),
                              Text(
                                "t3",
                                style: AppText.body14,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                  child: TextField(
                                enabled: true,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (e) {
                                  tag3.value = e;
                                },
                              )),
                              const SizedBox(width: 10),
                              Text(
                                "t4",
                                style: AppText.body14,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                  child: TextField(
                                enabled: true,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (e) {
                                  tag4.value = e;
                                },
                              )),
                            ]),
                      ]),
                  Text(
                    "${(cnt.toDouble() / 500.0).toStringAsFixed(2)}[s]",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: double.infinity,
                                height: 150,
                                padding: EdgeInsets.all(12),
                                child: SensorChartArea(
                                    _x1,
                                    _y1,
                                    Color.fromARGB(255, 4, 85, 225),
                                    null,
                                    null,
                                    null,
                                    null)),
                            Container(
                                width: double.infinity,
                                height: 150,
                                padding: EdgeInsets.all(12),
                                child: SensorChartArea(_x2, _y2, Colors.red,
                                    null, null, null, null)),
                          ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        text: "Start(ECG only)",
                        onPressed: () {
                          ref.read(bleProvider.notifier).startMeasEcg();
                        },
                        width: w * 0.2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AppButton(
                        text: "Start",
                        onPressed: () {
                          ref.read(bleProvider.notifier).startMeasImp();
                        },
                        width: w * 0.2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AppButton(
                        text: "Stop",
                        onPressed: () async {
                          ref.read(bleProvider.notifier).stopMeas();
                          logger.i(ref
                              .read(bleProvider.notifier)
                              .measureRawData
                              .cnt);
                        },
                        width: w * 0.2,
                      ),
                    ],
                  )
                ]))));
  }
}
