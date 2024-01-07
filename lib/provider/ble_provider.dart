import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue_plus/gen/flutterblueplus.pbjson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_emg_data/data/model/measure_raw_data.dart';
import 'package:get_emg_data/provider/model_providers.dart';
import 'dart:io';
import 'package:get_emg_data/util/func.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/util/logger.dart';

class BleNotifier extends ChangeNotifier {
  BleNotifier(this.ref) : super();
  final Ref ref;
  static const batteryServiceUUID = "180f";
  static const batteryCharaRXUUID = "2a19";
  static const dataServiceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const dataRxTxCharaUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  bool isBatteryServiceFound = false;
  bool isDataServiceFound = false;
  BluetoothDevice? device;
  BluetoothCharacteristic? dataRxTxChara;
  StreamSubscription? dataRxTxCharaStream;
  StreamSubscription? batteryCharaStream;
  List<int> msgBuf = []; //パケット結合用バッファ
  bool isConnected = false;
  int batteryLevel = -1;
  bool isDevMode = false; //裏モードか
  bool isStable200ohm = false; //200オーム安定
  bool isStable800ohm = false; //200オーム安定

  MeasureRawData measureRawData = MeasureRawData();

  //disconnect
  void disconnect() {
    logger.i(device);
    if (device == null) {
      return;
    }

    isConnected = false;
    if (dataRxTxCharaStream != null) dataRxTxCharaStream!.cancel();
    dataRxTxChara = null;
    if (batteryCharaStream != null) batteryCharaStream!.cancel();
    device!.disconnect();
    device = null;
    isBatteryServiceFound = false;
    isDataServiceFound = false;
    batteryLevel = -1;
    isDevMode = false;
    isStable200ohm = false;
    isStable800ohm = false;
    Fluttertoast.showToast(msg: "disconnected!");
    notifyListeners();
  }

  // get device name list
  Future<List<String>> getDeviceNameList() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Use location.
    }
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });
    if (Platform.isAndroid) {
      await Permission.locationWhenInUse.request();
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;
    FlutterBluePlus.isSupported.then((isAvailable) {
      if (isAvailable) FlutterBluePlus.setLogLevel(LogLevel.debug);
    });
    List<String> deviceNameList = [];
    const timeout = Duration(milliseconds: 1000);
    FlutterBluePlus.startScan(
        timeout: timeout, androidUsesFineLocation: false); //0.5秒間スキャン
    FlutterBluePlus.scanResults.listen((results) async {
      //リストを作成
      for (ScanResult r in results) {
        //print(r.device.name);
        if (r.device.name == "") continue;
        if (deviceNameList.contains(r.device.name)) continue;
        deviceNameList.add(r.device.name);
      }
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    return deviceNameList;
  }

  // connect
  void connect(String deviceName) async {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;
    const timeout = Duration(seconds: 2);
    FlutterBluePlus.startScan(
        timeout: timeout, androidUsesFineLocation: false); //2秒間スキャン
    List<ScanResult> tmpResults = [];
    FlutterBluePlus.scanResults.listen((results) async {
      //リストを作成
      for (ScanResult r in results) {
        //logger.i(r);
        tmpResults.add(r);
      }
    });
    await Future.delayed(const Duration(seconds: 2)); //ちょっと待つ
    FlutterBluePlus.stopScan();
    //スキャン結果解析
    //リストを作成
    for (ScanResult r in tmpResults) {
      if (r.device.name == "") continue;
      logger.i(
          '${r.device.name}(Target Device is ${deviceName}) is found! rssi: ${r.rssi}, id: ${r.device.id}');
      if (r.device.name != deviceName) {
        continue;
      }
      if (device != null) {
        try {
          device!.disconnect();
        } catch (e) {
          logger.e(e.toString());
        }
      } else {
        device = r.device; //該当のものを取得
        break;
      }
    }

    if (device == null) return;

    try {
      device!.disconnect();
    } catch (e) {
      logger.e(e.toString());
    }
    await device!.connect(); //接続
    device!.state.listen((event) {
      logger.i(event.name);
      if (event.name == "disconnected") {
        disconnect();
      }
    });
    logger.i(device);
    var services = await device!.discoverServices(); //サービス取得
    if (Platform.isAndroid) {
      await device!.requestMtu(120); //MTUを変更(androidのみ)
    }
    for (var service in services) {
      logger.i(service);
      logger.i(service.uuid);
      switch (service.uuid.toString()) {
        case batteryServiceUUID: //バッテリーサービスのとき
          if (isBatteryServiceFound) break;
          isBatteryServiceFound = true;
          logger.i('battery service is found');
          for (var chara in service.characteristics) {
            if (chara.uuid.toString() == batteryCharaRXUUID) {
              logger.i('battery characteristic is found');
              await Future.delayed(const Duration(milliseconds: 500));
              try {
                await chara.setNotifyValue(true); //notifycation設定
                batteryCharaStream = chara.value.listen((value) {
                  if (value.isNotEmpty) {
                    batteryLevel = value[0];
                    notifyListeners();
                    print('battery level: ${value[0]}');
                  }
                });
              } catch (e) {
                logger.e(e.toString());
              }
            }
          }
          break;
        case dataServiceUUID: //データサービスのとき
          if (isDataServiceFound) break;
          isDataServiceFound = true;
          logger.i('data service is found');
          for (var chara in service.characteristics) {
            logger.i(chara);
            switch (chara.uuid.toString()) {
              case dataRxTxCharaUUID:
                dataRxTxChara = chara;
                await Future.delayed(const Duration(milliseconds: 200));
                try {
                  await dataRxTxChara!.setNotifyValue(true);
                  dataRxTxCharaStream =
                      dataRxTxChara!.lastValueStream.listen((value) {
                    //logger.i(value);
                    //combinePacket(value); //パケット結合
                    handleMessage(value);
                  });
                } catch (e) {
                  logger.e(e.toString());
                }
                break;
            }
          }
          break;
        default:
          break;
      }
    }
    batteryLevel = 100;
    isConnected = true;
    Fluttertoast.showToast(msg: "connected!");
    notifyListeners();
  }

  //パケット結合
  void combinePacket(List<int> value) {
    if (value.length < 4) return;
    int packetNo = (value[0] << 4) + (value[1] >> 4);
    int totalPacketNum = ((value[1] % 0x10) << 8) + value[2];
    int dataLen = value[3];
    //logger.i(
    //    "packet no = ${packetNo}, total packet num = ${totalPacketNum}, data length = ${dataLen}");
    for (int i = 0; i < dataLen; i++) {
      msgBuf.add(value[4 + i]);
    }
    String msgData = "";
    for (int i = 0; i < msgBuf.length; i++) {
      msgData += " " + msgBuf[i].toRadixString(16);
    }
    logger.i("msgData is ${msgData}");
    if (packetNo == totalPacketNum) {
      //ラストメッセージ
      handleMessage(msgBuf);
      msgBuf = []; //空にする
    }
  }

  //メッセージ処理
  void handleMessage(List<int> value) {
    //メッセージ構造： 総メッセージデータ長(2Byte)、メッセージ番号(2Byte)、データ(nByte)、チェックサム(1Byte)
    //連続測定モード
    print(value);
    if (value.length >= 2) {
      if (value.length == 26) {
        if (value[0] == 0x01 && value[1] == 0x01) {
          measureRawData.update(value);
          notifyListeners();
        }
      }
    }
  }

  //機器情報取得
  void getDeviceInfo() {}

  //測定開始
  void startMeas() async {
    measureRawData.initialize();
    //コマンド送信
    if (dataRxTxChara == null) return;
    var command = [0x01, 0x00];
    dataRxTxChara!.write(command, withoutResponse: false);
  }

  //測定終了
  void stopMeas() async {
    //コマンド送信
    try {
      for (int i = 0; i < 5; i++) {
        await Future.delayed(const Duration(milliseconds: 5)); //ちょっと待つ
        if (dataRxTxChara == null) return;
        var command = [0x01, 0x01];
        dataRxTxChara!.write(command, withoutResponse: false);
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
