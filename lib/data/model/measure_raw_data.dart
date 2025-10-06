import 'dart:math';

import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/data/model/emg.dart';

//生データのクラス
class MeasureRawData {
  List<double> timeList = [];
  List<double> EMGList = [];
  List<double> Z1List = []; //経路1のZリスト
  List<double> Z2List = []; //経路2のZリスト
  List<double> Z3List = []; //経路3のZリスト
  Ppg ppg = Ppg();

  String csvTextData = "";
  int cnt = 0;
  DateTime now = DateTime.now();

  void update(List<int> value) {
    List<int> rawEMG = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> rawRs = [0.0, 0.0, 0.0];
    List<double> rawXs = [0.0, 0.0, 0.0];
    cnt = value[2] | value[3] << 8 | value[4] << 16 | value[5] << 24;
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
    //Imp
    if ((value[26] | value[27] << 8) != 0) {
      rawRs[0] = (value[26] | value[27] << 8) / 10.0;
      if (rawRs[0] > 3276.7) rawRs[0] -= 6553.6;
      rawXs[0] = (value[28] | value[29] << 8) / 10.0;
      if (rawXs[0] > 3276.7) rawXs[0] -= 6553.6;
      rawRs[1] = (value[30] | value[31] << 8) / 10.0;
      if (rawRs[1] > 3276.7) rawRs[1] -= 6553.6;
      rawXs[1] = (value[32] | value[33] << 8) / 10.0;
      if (rawXs[1] > 3276.7) rawXs[1] -= 6553.6;
      rawRs[2] = (value[34] | value[35] << 8) / 10.0;
      if (rawRs[2] > 3276.7) rawRs[2] -= 6553.6;
      rawXs[2] = (value[36] | value[37] << 8) / 10.0;
      if (rawXs[2] > 3276.7) rawXs[2] -= 6553.6;
      Z1List.add(sqrt(rawRs[0] * rawRs[0] + rawXs[0] * rawXs[0]));
      Z2List.add(sqrt(rawRs[1] * rawRs[1] + rawXs[1] * rawXs[1]));
      Z3List.add(sqrt(rawRs[2] * rawRs[2] + rawXs[2] * rawXs[2]));

      print(
          "R: ${rawRs[0].toStringAsFixed(1)}, ${rawRs[1].toStringAsFixed(1)}, ${rawRs[2].toStringAsFixed(1)}");
      print(
          "X: ${rawXs[0].toStringAsFixed(1)}, ${rawXs[1].toStringAsFixed(1)}, ${rawXs[2].toStringAsFixed(1)}");
    } else {
      if (Z1List.length > 0) {
        Z1List.add(Z1List[Z1List.length - 1]);
        Z2List.add(Z2List[Z2List.length - 1]);
        Z3List.add(Z3List[Z3List.length - 1]);
      } else {
        Z1List.add(sqrt(rawRs[0] * rawRs[0] + rawXs[0] * rawXs[0]));
        Z2List.add(sqrt(rawRs[1] * rawRs[1] + rawXs[1] * rawXs[1]));
        Z3List.add(sqrt(rawRs[2] * rawRs[2] + rawXs[2] * rawXs[2]));
      }
    }

    csvTextData += '${cnt - 9},${rawEMG[9]}\n';
    csvTextData += '${cnt - 8},${rawEMG[8]}\n';
    csvTextData += '${cnt - 7},${rawEMG[7]}\n';
    csvTextData += '${cnt - 6},${rawEMG[6]}\n';
    csvTextData += '${cnt - 5},${rawEMG[5]}\n';
    csvTextData += '${cnt - 4},${rawEMG[4]}\n';
    csvTextData += '${cnt - 3},${rawEMG[3]}\n';
    csvTextData += '${cnt - 2},${rawEMG[2]}\n';
    csvTextData += '${cnt - 1},${rawEMG[1]}\n';
    csvTextData +=
        '${cnt - 0},${rawEMG[0]},${rawRs[0].toStringAsFixed(1)},${rawXs[0].toStringAsFixed(1)},${rawRs[1].toStringAsFixed(1)},${rawXs[1].toStringAsFixed(1)},${rawRs[2].toStringAsFixed(1)},${rawXs[2].toStringAsFixed(1)}\n';
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
