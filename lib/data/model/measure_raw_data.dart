import 'dart:math';

import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/data/model/emg.dart';

//生データのクラス
class MeasureRawData {
  List<double> timeList = [];
  List<double> EMGList = [];
  List<double> ZList = []; //経路1のZリスト
  Ppg ppg = Ppg();

  String csvTextData = "";
  int cnt = 0;
  DateTime now = DateTime.now();

  void update(List<int> value) {
    List<int> rawEMG = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<int> rawIMP = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> rawRs = [0.0, 0.0, 0.0];
    List<double> rawXs = [0.0, 0.0, 0.0];
    cnt = value[2] | value[3] << 8 | value[4] << 16 | value[5] << 24;
    rawEMG[9] = value[6] | value[7] << 8;
    rawEMG[8] = value[8] | value[9] << 8;
    rawEMG[7] = value[10] | value[11] << 8;
    rawEMG[6] = value[12] | value[13] << 8;
    rawEMG[5] = value[14] | value[15] << 8;
    rawEMG[4] = value[16] | value[17] << 8;
    rawEMG[3] = value[18] | value[19] << 8;
    rawEMG[2] = value[20] | value[21] << 8;
    rawEMG[1] = value[22] | value[23] << 8;
    rawEMG[0] = value[24] | value[25] << 8;
    //Imp
    rawIMP[9] = value[26] | value[27] << 8;
    rawIMP[8] = value[28] | value[29] << 8;
    rawIMP[7] = value[30] | value[31] << 8;
    rawIMP[6] = value[32] | value[33] << 8;
    rawIMP[5] = value[34] | value[35] << 8;
    rawIMP[4] = value[36] | value[37] << 8;
    rawIMP[3] = value[38] | value[39] << 8;
    rawIMP[2] = value[40] | value[41] << 8;
    rawIMP[1] = value[42] | value[43] << 8;
    rawIMP[0] = value[44] | value[45] << 8;

    csvTextData += '${cnt - 9},${rawEMG[9]},${rawIMP[9]}\n';
    csvTextData += '${cnt - 8},${rawEMG[8]},${rawIMP[8]}\n';
    csvTextData += '${cnt - 7},${rawEMG[7]},${rawIMP[7]}\n';
    csvTextData += '${cnt - 6},${rawEMG[6]},${rawIMP[6]}\n';
    csvTextData += '${cnt - 5},${rawEMG[5]},${rawIMP[5]}\n';
    csvTextData += '${cnt - 4},${rawEMG[4]},${rawIMP[4]}\n';
    csvTextData += '${cnt - 3},${rawEMG[3]},${rawIMP[3]}\n';
    csvTextData += '${cnt - 2},${rawEMG[2]},${rawIMP[2]}\n';
    csvTextData += '${cnt - 1},${rawEMG[1]},${rawIMP[1]}\n';
    csvTextData += '${cnt - 0},${rawEMG[0]},${rawIMP[0]}\n';
    timeList.add((cnt) / 500.0);
    EMGList.add(rawEMG[9].toDouble());
    EMGList.add(rawEMG[8].toDouble());
    EMGList.add(rawEMG[7].toDouble());
    EMGList.add(rawEMG[6].toDouble());
    EMGList.add(rawEMG[5].toDouble());
    EMGList.add(rawEMG[4].toDouble());
    EMGList.add(rawEMG[3].toDouble());
    EMGList.add(rawEMG[2].toDouble());
    EMGList.add(rawEMG[1].toDouble());
    EMGList.add(rawEMG[0].toDouble());
    ZList.add(rawIMP[9].toDouble());
    ZList.add(rawIMP[8].toDouble());
    ZList.add(rawIMP[7].toDouble());
    ZList.add(rawIMP[6].toDouble());
    ZList.add(rawIMP[5].toDouble());
    ZList.add(rawIMP[4].toDouble());
    ZList.add(rawIMP[3].toDouble());
    ZList.add(rawIMP[2].toDouble());
    ZList.add(rawIMP[1].toDouble());
    ZList.add(rawIMP[0].toDouble());
    if (cnt > 0) {}
  }

  //データの初期化
  void initialize() {
    csvTextData = "cnt,EMG,Z\n";
    now = DateTime.now();
    cnt = 0;
    timeList.clear();
    EMGList.clear();
    ZList.clear();
    ppg.init();
  }
}
