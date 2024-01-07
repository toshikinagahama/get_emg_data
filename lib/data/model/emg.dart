import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/foundation/model_weights.dart';
import 'package:get_emg_data/util/logger.dart';
import 'package:get_emg_data/util/func.dart';
import 'package:get_emg_data/util/spline.dart';

class Ppg {
  int cnt = 0;
  int cntLastDetectPeak = 0; //前回ピーク検出カウント
  int offsetStable = 0; //安定したところのresamplingHRListのindex
  double rri = 100; //rri
  double rriLast = 100; //前回rri
  double th = 0.0;
  double errorVal = 0.0;
  int numFFTsample = 128; //FFTのサンプル(2×サンプル秒)
  bool isStable = false; //安定したかどうか
  bool isZeroReturn = false;
  bool isDetectPeak = false;
  double diffLast = 0.0;
  List<double> rawPPG = [];
  List<double> rawPPG2 = []; //移動平均
  List<double> iirPPG = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> ssfDiffPPG = [];
  List<double> filteredPPGList = [];
  List<double> filteredDiff2PPGList = [];
  List<double> aeDiff2PPGList = [];
  List<double> resamplingHRList = [];
  double bestRespInterval = 0.0;
  List<double> fftList = [];
  List<double> aIIR = [
    1.0,
    -3.76716674,
    5.33613989,
    -3.3695339,
    0.80059223
  ]; //フィルタ係数(100Hz 0.5-4, 0.3-8, 3-10)
  List<double> bIIR = [0.00555516, 0.0, -0.01111033, 0.0, 0.00555516]; //フィルタ係数
  List<double> TPList = [];
  List<double> VLFList = [];
  List<double> LFList = [];
  List<double> HFList = [];
  List<double> LF_normList = [];
  List<double> HF_normList = [];
  List<double> LF_HFList = [];
  List<double> CVList = [];
  List<double> RRIList = [];
  List<double> RRIDiffList = [];
  List<double> RMSSDList = [];
  //
  void init() {
    rawPPG.clear();
    rawPPG2.clear();
    iirPPG = [0.0, 0.0, 0.0, 0.0, 0.0];
    ssfDiffPPG.clear();
    resamplingHRList.clear();
    filteredPPGList.clear();
    filteredDiff2PPGList.clear();
    fftList.clear();
    TPList.clear();
    VLFList.clear();
    LFList.clear();
    HFList.clear();
    LF_normList.clear();
    HF_normList.clear();
    LF_HFList.clear();
    CVList.clear();
    RRIList.clear();
    RRIDiffList.clear();
    RMSSDList.clear();
    diffLast = 0.0;
    rri = 0;
    rriLast = 0;
    cnt = 0;
    cntLastDetectPeak = 0;
    th = 0.0;
    isZeroReturn = false;
    isDetectPeak = false;
    isStable = false;
    isStable = false;
  }

  void update(List<double> ppgs) {
    int N1 = 30;
    int N2 = 10;
    //print("ppg update");
    //if (isStable == false) return; //安定してないなら測定しない（安定判定はインピーダンス）
    for (int i = 0; i < ppgs.length; i++) {
      rawPPG.add(ppgs[i]);
      if (rawPPG.length == 500 + 1) rawPPG.removeAt(0);
      if (rawPPG.length >= N1) {
        //移動平均
        double mean = 0.0;
        for (int i = 0; i < N1; i++) {
          mean += rawPPG[rawPPG.length - 1 - i];
        }
        mean /= 20.0;
        rawPPG2.add(mean);
        if (rawPPG2.length == 500 + 1) rawPPG2.removeAt(0);
        if (rawPPG2.length >= 5) {
          if (iirPPG[4] * iirPPG[4] > 2500000000) {
            for (int i = 0; i < 5; i++) {
              iirPPG[i] = 0.0;
            }
          }
          for (int i = 0; i < 4; i++) {
            iirPPG[i] = iirPPG[i + 1];
          }
          iirPPG[4] = 0.0;
          double tmp = iir(5, aIIR, bIIR, [
            rawPPG2[0],
            rawPPG2[1],
            rawPPG2[2],
            rawPPG2[3],
            rawPPG2[4]
          ], [
            iirPPG[0],
            iirPPG[1],
            iirPPG[2],
            iirPPG[3],
            iirPPG[4],
          ]);
          iirPPG[4] = tmp;
          double diff = iirPPG[4] - iirPPG[3]; //Diff
          if (ssfDiffPPG.length >= 2) {
            filteredDiff2PPGList.add(diff - diffLast);
            if (filteredDiff2PPGList.length >= 100 + 1) {
              filteredDiff2PPGList.removeAt(0);
            }
          }
          diffLast = diff;
          if (diff >= 0) diff = 0.0; //SSF
          ssfDiffPPG.add(diff);
          if (ssfDiffPPG.length == N2 + 1) ssfDiffPPG.removeAt(0);
          if (ssfDiffPPG.length == N2) {
            filteredPPGList
                .add(ssfDiffPPG.reduce((a, b) => a + b) / ssfDiffPPG.length);
            if (filteredPPGList.length >= 100 * 5 + 1) {
              filteredPPGList.removeAt(0);
            } //5秒間
            if (filteredPPGList.length >= 200) {
              getHR(); //脈拍数取得
              if (!isStable) {
                if (resamplingHRList.length > 3) {
                  var maxValue = resamplingHRList
                      .sublist(resamplingHRList.length - 3,
                          resamplingHRList.length - 1)
                      .reduce(max);
                  var minValue = resamplingHRList
                      .sublist(resamplingHRList.length - 3,
                          resamplingHRList.length - 1)
                      .reduce(min);
                  //print(
                  //    "[HR] MAX: ${maxValue.toStringAsFixed(1)}, MIN: ${minValue.toStringAsFixed(1)}, MAX-MIN: ${(maxValue - minValue).toStringAsFixed(1)}, error: ${errorVal.toStringAsFixed(1)}");
                  if (0.001 <= maxValue - minValue &&
                      maxValue - minValue <= 10.0) {
                    isStable = true;
                    offsetStable = resamplingHRList.length - 1;
                  }
                }
              }
              if (resamplingHRList.length >= numFFTsample) {
                //fftList = getFFT(resamplingHRList); //周波数解析
                int nlags = 32;
                List<double> l = [];
                final mean = resamplingHRList.reduce((a, b) => a + b) /
                    resamplingHRList.length;

                for (int i = 0; i < resamplingHRList.length; i++) {
                  l.add(resamplingHRList[i] - mean);
                }
                double sd = 0.0;
                for (int i = 0; i < resamplingHRList.length; i++) {
                  sd += (resamplingHRList[i] - mean) *
                      (resamplingHRList[i] - mean);
                }
                sd /= sqrt(resamplingHRList.length);
                CVList.add(sd / mean);
                if (CVList.length == 120) CVList.removeAt(0);

                List<double> r = autocorr(l, nlags + 1);
                List<double> ar = levinsonDurbin(r, nlags);
                //print(ar);
                List<double> tmpArray = List.filled(numFFTsample, 0.0);
                for (int i = 0; i < ar.length; i++) {
                  //足りないところはゼロパッティング
                  tmpArray[i] = ar[i];
                }
                fftList = getFFT(tmpArray); //周波数解析
                //共鳴周波数表示
                //0.075 -0.108Hzの範囲で最大のもの。心拍変動増大に最適な呼吸は圧反射感度を高めるか?(第 2 報)―LF 成分のピーク周波数にもとづいたペース呼吸の効果―
                //0.0       , 0.01574803, 0.03149606, 0.04724409, 0.06299213
                //0.07874016, 0.09448819, 0.11023622, 0.12598425, 0.14173228
                //0.15748031, 0.17322835, 0.18897638, 0.20472441
                //周波数をスプライン補間する
                //64点
                //List<double> x = [
                //  0.0,
                //  0.03225806,
                //  0.06451613,
                //  0.09677419,
                //  0.12903226,
                //  0.16129032,
                //  0.19354839
                //];
                //List<double> y = [
                //  fftList[0],
                //  fftList[1],
                //  fftList[2],
                //  fftList[3],
                //  fftList[4],
                //  fftList[5],
                //  fftList[6],
                //];
                //Spline spline = Spline(x, y);
                //double tmpMax = 0;
                //int tmpMaxIndex = 0;
                //for (int i = 0; i < 34; i++) {
                //  //0.075 - 0.108
                //  double x1 = 0.075 + i * 0.001;
                //  double y1 = spline.compute(x, y, x1);
                //  if (tmpMax < y1) {
                //    tmpMax = y1;
                //    tmpMaxIndex = i;
                //  }
                //}
                //128点の場合
                //[0.         0.01574803 0.03149606 0.04724409 0.06299213 0.07874016
                //0.09448819 0.11023622 0.12598425 0.14173228 0.15748031 0.17322835
                //0.18897638 0.20472441 0.22047244 0.23622047 0.2519685  0.26771654
                //0.28346457 0.2992126  0.31496063 0.33070866 0.34645669 0.36220472
                //0.37795276 0.39370079 0.40944882 0.42519685 0.44094488 0.45669291
                //0.47244094 0.48818898 0.50393701 0.51968504 0.53543307 0.5511811
                //0.56692913 0.58267717 0.5984252  0.61417323 0.62992126 0.64566929
                //0.66141732 0.67716535 0.69291339 0.70866142 0.72440945 0.74015748
                //0.75590551 0.77165354 0.78740157 0.80314961 0.81889764 0.83464567
                //0.8503937  0.86614173 0.88188976 0.8976378  0.91338583 0.92913386
                //0.94488189 0.96062992 0.97637795 0.99212598 1.00787402 1.02362205
                //1.03937008 1.05511811 1.07086614 1.08661417 1.1023622  1.11811024
                //1.13385827 1.1496063  1.16535433 1.18110236 1.19685039 1.21259843
                //1.22834646 1.24409449 1.25984252 1.27559055 1.29133858 1.30708661
                //1.32283465 1.33858268 1.35433071 1.37007874 1.38582677 1.4015748
                //1.41732283 1.43307087 1.4488189  1.46456693 1.48031496 1.49606299
                //1.51181102 1.52755906 1.54330709 1.55905512 1.57480315 1.59055118
                //1.60629921 1.62204724 1.63779528 1.65354331 1.66929134 1.68503937
                //1.7007874  1.71653543 1.73228346 1.7480315  1.76377953 1.77952756
                //1.79527559 1.81102362 1.82677165 1.84251969 1.85826772 1.87401575
                //1.88976378 1.90551181 1.92125984 1.93700787 1.95275591 1.96850394
                //1.98425197 2.0 ]
                //0.0       , 0.01574803, 0.03149606, 0.04724409, 0.06299213
                //0.07874016, 0.09448819, 0.11023622, 0.12598425, 0.14173228
                //0.15748031, 0.17322835, 0.18897638, 0.20472441
                List<int> VLFRange = [1, 2]; //VFの範囲
                List<int> LFRange = [3, 9]; //LFの範囲
                List<int> HFRange = [10, 25]; //HFの範囲
                //LFHF等の計算
                double val = 0.0;
                for (int i = VLFRange[0]; i <= VLFRange[1]; i++) {
                  val += fftList[i];
                }
                VLFList.add(val);
                val = 0.0;
                for (int i = LFRange[0]; i <= LFRange[1]; i++) {
                  val += fftList[i];
                }
                LFList.add(val);
                val = 0.0;
                for (int i = HFRange[0]; i <= HFRange[1]; i++) {
                  val += fftList[i];
                }
                HFList.add(val);
                val = 0.0;
                for (int i = 0; i <= HFRange[1]; i++) {
                  val += fftList[i];
                }
                TPList.add(val);
                LF_normList.add((LFList[LFList.length - 1]) /
                    (TPList[TPList.length - 1] - VLFList[VLFList.length - 1]) *
                    100);
                HF_normList.add((HFList[HFList.length - 1]) /
                    (TPList[TPList.length - 1] - VLFList[VLFList.length - 1]) *
                    100);
                LF_HFList.add(
                    LFList[LFList.length - 1] / HFList[HFList.length - 1]);
                if (TPList.length == 120) TPList.removeAt(0);
                if (VLFList.length == 120) VLFList.removeAt(0);
                if (LFList.length == 120) LFList.removeAt(0);
                if (HFList.length == 120) HFList.removeAt(0);
                if (LF_normList.length == 120) LF_normList.removeAt(0);
                if (HF_normList.length == 120) HF_normList.removeAt(0);

                List<double> x = [
                  0.0,
                  0.01574803,
                  0.03149606,
                  0.04724409,
                  0.06299213,
                  0.07874016,
                  0.09448819,
                  0.11023622,
                  0.12598425,
                  0.14173228
                ];
                List<double> y = [
                  fftList[0],
                  fftList[1],
                  fftList[2],
                  fftList[3],
                  fftList[4],
                  fftList[5],
                  fftList[6],
                  fftList[7],
                  fftList[8],
                  fftList[9],
                ];
                Spline spline = Spline(x, y);
                double tmpMax = 0;
                int tmpMaxIndex = 0;
                for (int i = 0; i < 34; i++) {
                  //0.075 - 0.108
                  double x1 = 0.075 + i * 0.001;
                  double y1 = spline.compute(x, y, x1);
                  if (tmpMax < y1) {
                    tmpMax = y1;
                    tmpMaxIndex = i;
                  }
                }
                //print(
                //    "最適呼吸周波数: ${((1.0) / (0.075 + tmpMaxIndex.toDouble() * 0.001)).toStringAsFixed(2)}");
                bestRespInterval =
                    (100.0 ~/ (0.075 + tmpMaxIndex * 0.001)).toDouble() / 100.0;
              }
            }
          }
        }
      }
      cnt++;
    } //微分、SSF、移動平均
  }

  void getHR() {
    double v0 = filteredPPGList[filteredPPGList.length - 1];
    double v1 = filteredPPGList[filteredPPGList.length - 2];
    double v2 = filteredPPGList[filteredPPGList.length - 3];
    double v3 = filteredPPGList[filteredPPGList.length - 4];
    double v4 = filteredPPGList[filteredPPGList.length - 5];
    if (cnt - cntLastDetectPeak >= 200) {
      //2秒超えてたらリセット
      th = 0;
      isZeroReturn = true;
      isDetectPeak = false;
    }
    if (isZeroReturn == true) {
      if (v0 < th * 0.4) {
        if (isDetectPeak == false) {
          if (cnt - cntLastDetectPeak >= 20) {
            if (v4 >= v3 && v3 >= v2 && v2 <= v1 && v1 <= v0) {
              //体動検知をいずれしたい。
              errorVal = getError();
              //errorVal = 0; //体動検知は処理が重いので一旦なし。
              if (errorVal <= 100) {
                isDetectPeak = true;
                rri = (cnt - cntLastDetectPeak).toDouble();
                if (rri > 1) {
                  if (rri >= 150) {
                    //40bpm以下
                    rri = rriLast;
                  }
                  RRIList.add(rri * 10); //msに合わせる
                  RRIDiffList.add((rri - rriLast) * 10);
                  if (RRIList.length >= 30) {
                    double tmp = 0.0;
                    for (int i = RRIDiffList.length - 30;
                        i < RRIDiffList.length;
                        i++) {
                      tmp += RRIDiffList[i] * RRIDiffList[i];
                    }
                    tmp /= 29.0;
                    tmp = sqrt(tmp);
                    RMSSDList.add(tmp);
                  }
                  // if (33 <= rriLast && rriLast <= 150) {
                  //   if (rriLast - rri >= 150) {
                  //     //ピーク抜け
                  //     rri = rriLast;
                  //   }
                  // }
                  //print(6000.0 / rri);
                  if (cntLastDetectPeak != 0 && cntLastDetectPeak != cnt) {
                    for (int i = cntLastDetectPeak; i < cnt; i++) {
                      if (i % 50 == 0) {
                        //2Hzでresampling
                        double a = (rri - rriLast) /
                            (cnt - cntLastDetectPeak); //線形補間の傾き
                        double rriResampling = a * (i - cnt) + rri;
                        if (rriResampling != 0.0) {
                          resamplingHRList.add(6000.0 / rriResampling);
                        } else {
                          resamplingHRList.add(0.0);
                        }
                        if (resamplingHRList.length == numFFTsample + 1) {
                          resamplingHRList.removeAt(0);
                        }
                      }
                    }
                    //print(resamplingHRList);
                  }
                  rriLast = rri;
                }
              }
              cntLastDetectPeak = cnt;
              isZeroReturn = false;
            }
          }
        }
      }
    } else {
      if (v0 >= -0.0001) {
        th = 0;
        for (int i = 0; i < 200; i++) {
          if (th > filteredPPGList[filteredPPGList.length - 1 - i]) {
            th = filteredPPGList[filteredPPGList.length - 1 - i];
          }
        }
        isZeroReturn = true;
        isDetectPeak = false;
      }
    }
  }

  void getIIRData() {
    {
      if (iirPPG[4] * iirPPG[4] > 2500000000) {
        for (int i = 0; i < 5; i++) {
          iirPPG[i] = 0.0;
        }
      }
      for (int i = 0; i < 4; i++) {
        iirPPG[i] = iirPPG[i + 1];
      }
      iirPPG[4] = 0.0;
      List<double> tmpRaw = [
        rawPPG2[0],
        rawPPG2[1],
        rawPPG2[2],
        rawPPG2[3],
        rawPPG2[4]
      ];
      List<double> tmpY = [
        iirPPG[0],
        iirPPG[1],
        iirPPG[2],
        iirPPG[3],
        iirPPG[4],
      ];
      double tmp = iir(5, aIIR, bIIR, tmpRaw, tmpY);
      iirPPG[4] = tmp;
    }
  }

  double getError() {
    double res = 0.0;
    int N = 100;
    //エラー値
    List<double> input = [];
    final mean = filteredDiff2PPGList.reduce((a, b) => a + b) /
        filteredDiff2PPGList.length;
    final std = sqrt(filteredDiff2PPGList.map((current) {
          var difference = current - mean;
          return pow(difference, 2);
        }).reduce((previous, current) => previous + current) /
        filteredDiff2PPGList.length);
    for (int i = 0; i < filteredDiff2PPGList.length; i++) {
      input.add((filteredDiff2PPGList[i] - mean) / std);
    }
    List<double> tmp1 = [0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 5; i++) {
      for (int ii = 0; ii < N; ii++) {
        tmp1[i] += input[ii] * ModelWeights.ppgModel1DeepWeights11[ii][i];
      }
      tmp1[i] += ModelWeights.ppgModel1DeepWeights12[i];
    }
    List<double> tmp2 = List.filled(100, 0.0);
    for (int i = 0; i < N; i++) {
      for (int ii = 0; ii < 5; ii++) {
        tmp2[i] += tmp1[ii] * ModelWeights.ppgModel1DeepWeights21[ii][i];
      }
      tmp2[i] += ModelWeights.ppgModel1DeepWeights22[i];
    }
    for (int i = 0; i < N; i++) {
      res += (tmp2[i] - input[i]).abs();
    }
    //print(input);
    //print(tmp2);
    aeDiff2PPGList = tmp2;
    return res;
  }
}
