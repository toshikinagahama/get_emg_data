import 'package:get_emg_data/util/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_emg_data/foundation/model_weights.dart';
import 'dart:math';

//64点のデータ
//List<double> hamming = [
//  0.08,
//  0.08228584,
//  0.08912066,
//  0.10043651,
//  0.11612094,
//  0.13601808,
//  0.15993016,
//  0.18761956,
//  0.21881106,
//  0.25319469,
//  0.29042872,
//  0.3301431,
//  0.37194313,
//  0.41541338,
//  0.46012184,
//  0.50562416,
//  0.55146812,
//  0.5971981,
//  0.64235963,
//  0.68650386,
//  0.72919207,
//  0.77,
//  0.80852209,
//  0.84437549,
//  0.87720386,
//  0.90668095,
//  0.93251381,
//  0.95444568,
//  0.97225861,
//  0.98577555,
//  0.99486218,
//  0.99942818,
//  0.99942818,
//  0.99486218,
//  0.98577555,
//  0.97225861,
//  0.95444568,
//  0.93251381,
//  0.90668095,
//  0.87720386,
//  0.84437549,
//  0.80852209,
//  0.77,
//  0.72919207,
//  0.68650386,
//  0.64235963,
//  0.5971981,
//  0.55146812,
//  0.50562416,
//  0.46012184,
//  0.41541338,
//  0.37194313,
//  0.3301431,
//  0.29042872,
//  0.25319469,
//  0.21881106,
//  0.18761956,
//  0.15993016,
//  0.13601808,
//  0.11612094,
//  0.10043651,
//  0.08912066,
//  0.08228584,
//  0.08
//];
//
//List<double> sintbl = [
//  0.000000,
//  0.098017,
//  0.195090,
//  0.290285,
//  0.382683,
//  0.471397,
//  0.555570,
//  0.634393,
//  0.707107,
//  0.773010,
//  0.831470,
//  0.881921,
//  0.923880,
//  0.956940,
//  0.980785,
//  0.995185,
//  1.000000,
//  0.995185,
//  0.980785,
//  0.956940,
//  0.923880,
//  0.881921,
//  0.831470,
//  0.773010,
//  0.707107,
//  0.634393,
//  0.555570,
//  0.471397,
//  0.382683,
//  0.290285,
//  0.195090,
//  0.098017,
//  -0.000000,
//  -0.098017,
//  -0.195090,
//  -0.290285,
//  -0.382683,
//  -0.471397,
//  -0.555570,
//  -0.634393,
//  -0.707107,
//  -0.773010,
//  -0.831470,
//  -0.881921,
//  -0.923880,
//  -0.956940,
//  -0.980785,
//  -0.995185,
//  -1.000000,
//  -0.995185,
//  -0.980785,
//  -0.956940,
//  -0.923880,
//  -0.881921,
//  -0.831470,
//  -0.773010,
//  -0.707107,
//  -0.634393,
//  -0.555570,
//  -0.471397,
//  -0.382683,
//  -0.290285,
//  -0.195090,
//  -0.098017,
//  0.000000,
//  0.098017,
//  0.195090,
//  0.290285,
//  0.382683,
//  0.471397,
//  0.555570,
//  0.634393,
//  0.707107,
//  0.773010,
//  0.831470,
//  0.881921,
//  0.923880,
//  0.956940,
//  0.980785,
//  0.995185
//];
//List<int> bitrev = [
//  0,
//  32,
//  16,
//  48,
//  8,
//  40,
//  24,
//  56,
//  4,
//  36,
//  20,
//  52,
//  12,
//  44,
//  28,
//  60,
//  2,
//  34,
//  18,
//  50,
//  10,
//  42,
//  26,
//  58,
//  6,
//  38,
//  22,
//  54,
//  14,
//  46,
//  30,
//  62,
//  1,
//  33,
//  17,
//  49,
//  9,
//  41,
//  25,
//  57,
//  5,
//  37,
//  21,
//  53,
//  13,
//  45,
//  29,
//  61,
//  3,
//  35,
//  19,
//  51,
//  11,
//  43,
//  27,
//  59,
//  7,
//  39,
//  23,
//  55,
//  15,
//  47,
//  31,
//  63
//];

//128点用
List<double> hamming = [
  0.08,
  0.08056285,
  0.08225002,
  0.08505738,
  0.08897806,
  0.09400246,
  0.1001183,
  0.1073106,
  0.11556177,
  0.1248516,
  0.13515738,
  0.14645387,
  0.15871343,
  0.17190607,
  0.18599949,
  0.20095922,
  0.21674863,
  0.23332909,
  0.25066003,
  0.26869903,
  0.28740195,
  0.30672302,
  0.32661496,
  0.34702909,
  0.36791545,
  0.38922293,
  0.41089938,
  0.43289177,
  0.45514627,
  0.47760842,
  0.50022325,
  0.52293542,
  0.54568935,
  0.56842936,
  0.5910998,
  0.61364519,
  0.63601036,
  0.65814057,
  0.67998167,
  0.70148022,
  0.72258359,
  0.74324016,
  0.76339936,
  0.78301186,
  0.80202967,
  0.82040626,
  0.83809664,
  0.85505753,
  0.87124742,
  0.88662669,
  0.90115771,
  0.91480492,
  0.92753491,
  0.93931655,
  0.95012099,
  0.95992179,
  0.96869497,
  0.97641907,
  0.98307517,
  0.988647,
  0.99312091,
  0.99648596,
  0.99873391,
  0.99985927,
  0.99985927,
  0.99873391,
  0.99648596,
  0.99312091,
  0.988647,
  0.98307517,
  0.97641907,
  0.96869497,
  0.95992179,
  0.95012099,
  0.93931655,
  0.92753491,
  0.91480492,
  0.90115771,
  0.88662669,
  0.87124742,
  0.85505753,
  0.83809664,
  0.82040626,
  0.80202967,
  0.78301186,
  0.76339936,
  0.74324016,
  0.72258359,
  0.70148022,
  0.67998167,
  0.65814057,
  0.63601036,
  0.61364519,
  0.5910998,
  0.56842936,
  0.54568935,
  0.52293542,
  0.50022325,
  0.47760842,
  0.45514627,
  0.43289177,
  0.41089938,
  0.38922293,
  0.36791545,
  0.34702909,
  0.32661496,
  0.30672302,
  0.28740195,
  0.26869903,
  0.25066003,
  0.23332909,
  0.21674863,
  0.20095922,
  0.18599949,
  0.17190607,
  0.15871343,
  0.14645387,
  0.13515738,
  0.1248516,
  0.11556177,
  0.1073106,
  0.1001183,
  0.09400246,
  0.08897806,
  0.08505738,
  0.08225002,
  0.08056285,
  0.08
];
List<double> sintbl = [
  0,
  0.049068,
  0.098017,
  0.14673,
  0.19509,
  0.24298,
  0.290285,
  0.33689,
  0.382683,
  0.427555,
  0.471397,
  0.514103,
  0.55557,
  0.595699,
  0.634393,
  0.671559,
  0.707107,
  0.740951,
  0.77301,
  0.803208,
  0.83147,
  0.857729,
  0.881921,
  0.903989,
  0.92388,
  0.941544,
  0.95694,
  0.970031,
  0.980785,
  0.989177,
  0.995185,
  0.998795,
  1,
  0.998795,
  0.995185,
  0.989177,
  0.980785,
  0.970031,
  0.95694,
  0.941544,
  0.92388,
  0.903989,
  0.881921,
  0.857729,
  0.83147,
  0.803208,
  0.77301,
  0.740951,
  0.707107,
  0.671559,
  0.634393,
  0.595699,
  0.55557,
  0.514103,
  0.471397,
  0.427555,
  0.382683,
  0.33689,
  0.290285,
  0.24298,
  0.19509,
  0.14673,
  0.098017,
  0.049068,
  0,
  -0.049068,
  -0.098017,
  -0.14673,
  -0.19509,
  -0.24298,
  -0.290285,
  -0.33689,
  -0.382683,
  -0.427555,
  -0.471397,
  -0.514103,
  -0.55557,
  -0.595699,
  -0.634393,
  -0.671559,
  -0.707107,
  -0.740951,
  -0.77301,
  -0.803208,
  -0.83147,
  -0.857729,
  -0.881921,
  -0.903989,
  -0.92388,
  -0.941544,
  -0.95694,
  -0.970031,
  -0.980785,
  -0.989177,
  -0.995185,
  -0.998795,
  -1,
  -0.998795,
  -0.995185,
  -0.989177,
  -0.980785,
  -0.970031,
  -0.95694,
  -0.941544,
  -0.92388,
  -0.903989,
  -0.881921,
  -0.857729,
  -0.83147,
  -0.803208,
  -0.77301,
  -0.740951,
  -0.707107,
  -0.671559,
  -0.634393,
  -0.595699,
  -0.55557,
  -0.514103,
  -0.471397,
  -0.427555,
  -0.382683,
  -0.33689,
  -0.290285,
  -0.24298,
  -0.19509,
  -0.14673,
  -0.098017,
  -0.049068,
  0,
  0.049068,
  0.098017,
  0.14673,
  0.19509,
  0.24298,
  0.290285,
  0.33689,
  0.382683,
  0.427555,
  0.471397,
  0.514103,
  0.55557,
  0.595699,
  0.634393,
  0.671559,
  0.707107,
  0.740951,
  0.77301,
  0.803208,
  0.83147,
  0.857729,
  0.881921,
  0.903989,
  0.92388,
  0.941544,
  0.95694,
  0.970031,
  0.980785,
  0.989177,
  0.995185,
  0.998795
];
List<int> bitrev = [
  0,
  64,
  32,
  96,
  16,
  80,
  48,
  112,
  8,
  72,
  40,
  104,
  24,
  88,
  56,
  120,
  4,
  68,
  36,
  100,
  20,
  84,
  52,
  116,
  12,
  76,
  44,
  108,
  28,
  92,
  60,
  124,
  2,
  66,
  34,
  98,
  18,
  82,
  50,
  114,
  10,
  74,
  42,
  106,
  26,
  90,
  58,
  122,
  6,
  70,
  38,
  102,
  22,
  86,
  54,
  118,
  14,
  78,
  46,
  110,
  30,
  94,
  62,
  126,
  1,
  65,
  33,
  97,
  17,
  81,
  49,
  113,
  9,
  73,
  41,
  105,
  25,
  89,
  57,
  121,
  5,
  69,
  37,
  101,
  21,
  85,
  53,
  117,
  13,
  77,
  45,
  109,
  29,
  93,
  61,
  125,
  3,
  67,
  35,
  99,
  19,
  83,
  51,
  115,
  11,
  75,
  43,
  107,
  27,
  91,
  59,
  123,
  7,
  71,
  39,
  103,
  23,
  87,
  55,
  119,
  15,
  79,
  47,
  111,
  31,
  95,
  63,
  127
];

void saveFile(csvString, filename) async {
  await [Permission.storage].request();
  String savedPath = "";
  if (Platform.isAndroid) {
    savedPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  } else {
    final dir = await getApplicationDocumentsDirectory();
    savedPath = dir.path;
  }
  //Directory? dir = await getApplicationDocumentsDirectory();
  String logPath = '${savedPath}/${filename}';
  File textfilePath = File(logPath);
  await textfilePath.writeAsString(csvString);
  logger.i("csvfile is saved in ${logPath.toString()}");
}

double iir(int size, List<double> a, List<double> b, List<double> raw,
    List<double> y) {
  double res = 0.0;
  for (int i = 0; i < size; i++) {
    res += b[i] * raw[size - 1 - i] - a[i] * y[size - 1 - i];
  }
  return res;
}

List<double> autocorr(List<double> x, int nlags) {
  int N = x.length;
  List<double> r = List.filled(nlags, 0.0);
  for (int i = 0; i < nlags; i++) {
    for (int n = 0; n < N - i; n++) {
      r[i] += x[n] * x[n + i];
    }
  }
  return r;
}

List<double> levinsonDurbin(List<double> r, int lpcOrder) {
  List<double> a = List.filled(lpcOrder + 1, 0.0);
  List<double> e = List.filled(lpcOrder + 1, 0.0);

  a[0] = 1.0;
  a[1] = -r[1] / r[0];
  e[1] = r[0] + r[1] * a[1];
  double lam = -r[1] / r[0];

  for (int k = 1; k < lpcOrder; k++) {
    lam = 0.0;
    for (int j = 0; j < k + 1; j++) {
      lam -= a[j] * r[k + 1 - j];
    }
    lam /= e[k];
    List<double> U = [1.0];
    List<double> V = [0.0];
    for (int i = 1; i < k + 1; i++) {
      U.add(a[i]);
    }
    for (int i = k; i > 0; i--) {
      V.add(a[i]);
    }
    U.add(0);
    V.add(1);
    for (int i = 0; i < U.length; i++) {
      a[i] = U[i] + lam * V[i];
    }
    e[k + 1] = e[k] * (1.0 - lam * lam);
  }
  return a;
}

List<double> getFFT(List<double> x) {
  //0.5Hz, 128点（64秒）でFFTをかける。Hamming窓
  //int n = 64;
  int n = 128;
  int i, j, k, ik, h, d, k2, n4, inverse;
  double t, s, c, dx, dy;
  inverse = 0;
  n4 = n ~/ 4;
  List<double> y = List.filled(n, 0.0);

  //double xMean = x.reduce((a, b) => a + b) / x.length;
  //for (i = 0; i < n; i++) {
  /* hamming */
  //x[i] -= xMean;
  //x[i] *= hamming[i];
  //}
  //ビット反転
  for (i = 0; i < n; i++) {
    j = bitrev[i];
    if (i < j) {
      t = x[i];
      x[i] = x[j];
      x[j] = t;
      t = y[i];
      y[i] = y[j];
      y[j] = t;
    }
  }
  for (k = 1; k < n; k = k2) {
    h = 0;
    k2 = k + k;
    d = n ~/ k2;
    for (j = 0; j < k; j++) {
      c = sintbl[h + n4];
      if (inverse != 0) {
        s = -sintbl[h];
      } else {
        s = sintbl[h];
      }
      for (i = j; i < n; i += k2) {
        ik = i + k;
        dx = s * y[ik] + c * x[ik];
        dy = c * y[ik] - s * x[ik];
        x[ik] = x[i] - dx;
        x[i] += dx;
        y[ik] = y[i] - dy;
        y[i] += dy;
      }
      h += d;
    }
  }
  if (inverse == 0) {
    for (i = 0; i < n; i++) {
      x[i] /= n;
      y[i] /= n;
    }
  }
  List<double> fftList = List.filled(n ~/ 4, 0.0, growable: true);
  for (int i = 0; i < (n ~/ 4); i++) {
    // 0.5Hzまで
    fftList[i] = 1.0 / sqrt(x[i] * x[i] + y[i] * y[i]);
  }
  //print(fftList);
  return fftList;
}

//インピオートエンコーダーフィルタ
List<double> getImpModel1FiteredData(List<double> raw, List<double> ori) {
  List<double> filtered = List.of(ori);
  List<double> tmp1 =
      List.filled(ModelWeights.impModel1DeepWeights2.length, 0.0);
  List<double> tmp2 =
      List.filled(ModelWeights.impModel1DeepWeights1.length, 0.0);

  for (int i = 0; i < ModelWeights.impModel1DeepWeights1.length; i++) {
    for (int j = 0; j < ModelWeights.impModel1DeepWeights1[i].length; j++) {
      tmp1[j] += raw[i] * ModelWeights.impModel1DeepWeights1[i][j];
    }
  }
  for (int i = 0; i < ModelWeights.impModel1DeepWeights2.length; i++) {
    tmp1[i] += ModelWeights.impModel1DeepWeights2[i];
  }
  for (int i = 0; i < ModelWeights.impModel1DeepWeights3[0].length; i++) {
    tmp2[i] = 0.0;
    for (int j = 0; j < ModelWeights.impModel1DeepWeights3.length; j++) {
      tmp2[i] += tmp1[j] * ModelWeights.impModel1DeepWeights3[j][i];
    }
    tmp2[i] += ModelWeights.impModel1DeepWeights4[i];
  }
  for (int i = 0; i < 2; i++) {
    filtered[i] = filtered[i + 1];
  }
  filtered[2] = tmp2[49];
  return filtered;
}

//送信パケット取得
List<List<int>> getSendPacket(List<int> msgNo, List<int> data) {
  List<List<int>> packets = [];
  //全体メッセージ
  List<int> message = [];
  message.add((msgNo.length + data.length + 1) ~/ 0x100); //総データ長1byte
  message.add((msgNo.length + data.length + 1) % 0x100); //総データ長1byte
  message.add(msgNo[0]); //メッセージ番号1byte
  message.add(msgNo[1]); //メッセージ番号1byte
  for (int i = 0; i < data.length; i++) {
    message.add(data[i]);
  }
  //チェックサム計算
  int checksum = 0x00;
  for (int i = 0; i < message.length; i++) {
    checksum += message[i];
    checksum %= 0x100;
  }
  checksum ^= 0xff;
  message.add(checksum);
  //1-16 -> 0, 17-32 -> 1, 33-48 -> 2
  int packetNum = (message.length - 1) ~/ 16;
  //logger.i(packetNum);
  for (int i = 0; i < packetNum + 1; i++) {
    List<int> packet = [];
    //1パケットで送信可能
    packet.add(i ~/
        0x10); //パケット番号 i = 20(0x014)、総パケット数22(0x016)なら、0x014 -> 0x01, 0x40, 0x16
    packet
        .add(i % 0x10 + packetNum ~/ 0x100); //バケット番号(0.5byte) + 総パケット数(0.5byte)
    packet.add(packetNum % 0x100); //パケット数
    int totalMessageLen = message.length - i * 16;
    if (totalMessageLen > 16) totalMessageLen = 16;
    packet.add(totalMessageLen % 0x100); //全体メッセージ長さ
    for (int j = i * 16; j < totalMessageLen; j++) {
      packet.add(message[j]);
    }
    packets.add(packet);
  }
  return packets;
}
