import 'dart:async';
import "dart:convert";
import 'dart:math';
import 'package:flutter/foundation.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/util/func.dart';
import 'package:get_emg_data/data/model/emg.dart';

//生データのクラス
class MeasureRawData {
  List<double> timeList = [];
  List<double> EMGList = [];
  Ppg ppg = Ppg();

  String csvTextData = "";
  int cnt = 0;
  DateTime now = DateTime.now();

  void update(List<int> value) {
    List<int> rawEMG = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    cnt = value[2] | value[3] << 8 | value[4] << 16 | value[5] << 24;
    //logger.i(cnt);
    rawEMG[0] = value[6] | value[7] << 8;
    rawEMG[1] = value[8] | value[9] << 8;
    rawEMG[2] = value[10] | value[11] << 8;
    rawEMG[3] = value[12] | value[13] << 8;
    rawEMG[4] = value[14] | value[15] << 8;
    rawEMG[5] = value[16] | value[17] << 8;
    rawEMG[6] = value[18] | value[19] << 8;
    rawEMG[7] = value[20] | value[21] << 8;
    rawEMG[8] = value[22] | value[23] << 8;
    rawEMG[9] = value[24] | value[25] << 8;

    csvTextData += '${cnt - 9},${rawEMG[9]}\n';
    csvTextData += '${cnt - 8},${rawEMG[8]}\n';
    csvTextData += '${cnt - 7},${rawEMG[7]}\n';
    csvTextData += '${cnt - 6},${rawEMG[6]}\n';
    csvTextData += '${cnt - 5},${rawEMG[5]}\n';
    csvTextData += '${cnt - 4},${rawEMG[4]}\n';
    csvTextData += '${cnt - 3},${rawEMG[3]}\n';
    csvTextData += '${cnt - 2},${rawEMG[2]}\n';
    csvTextData += '${cnt - 1},${rawEMG[1]}\n';
    csvTextData += '${cnt - 0},${rawEMG[0]}\n';
    timeList.add((cnt) / 500.0);
    EMGList.add(rawEMG[0].toDouble());
    if (cnt > 0) {
      //ppg.update([
      //  PPGsList[PPGsList.length - 2][0],
      //  PPGsList[PPGsList.length - 2][1],
      //  PPGsList[PPGsList.length - 1][0],
      //  PPGsList[PPGsList.length - 1][1]
      //]);
    }
  }

  //データの初期化
  void initialize() {
    csvTextData = "cnt,EMG\n";
    now = DateTime.now();
    cnt = 0;
    timeList.clear();
    EMGList.clear();
    ppg.init();
  }
}
