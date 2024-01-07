/// Example of a stacked area chart.
import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";

//センサーのデータを描画するクラス
class SensorChartArea2 extends StatelessWidget {
  double _counter = 0.0;
  List<FlSpot>? _dataList1;
  List<FlSpot>? _dataList2;
  List<FlSpot>? _guideLineList;
  double? _minX;
  double? _maxX;
  double? _minY;
  double? _maxY;
  static const zeroDuration = Duration(microseconds: 0);

  SensorChartArea2(List<FlSpot> dataList1, List<FlSpot> dataList2, double? minX,
      double? maxX, double? minY, double? maxY) {
    _dataList1 = dataList1;
    _dataList2 = dataList2;
    _minX = minX;
    _maxX = maxX;
    _minY = minY;
    _maxY = maxY;
    _guideLineList = [
      FlSpot(_dataList1!.length.toDouble(), _minY!.toDouble()),
      FlSpot(_dataList1!.length.toDouble(), _maxY!.toDouble())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          flex: 1,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: _dataList2,
                  isCurved: false,
                  barWidth: 20,
                  color: Color.fromARGB(40, 74, 74, 74),
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
                LineChartBarData(
                  spots: _dataList1,
                  isCurved: false,
                  barWidth: 2,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
                _guideLineList?[0].x != 0
                    ? LineChartBarData(
                        spots: _guideLineList,
                        isCurved: false,
                        barWidth: 1,
                        dashArray: [2, 2],
                        color: const Color.fromARGB(255, 98, 98, 98),
                        dotData: FlDotData(
                          show: false,
                        ),
                      )
                    : LineChartBarData(
                        spots: _guideLineList,
                        isCurved: false,
                        barWidth: 1,
                        color: const Color.fromARGB(0, 98, 98, 98),
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
              ],
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                // bottomTitles: AxisTitles(
                //     axisNameWidget: const Text(
                //       "Time[s]", // タイトル名
                //       style: TextStyle(
                //         color: Color.fromARGB(255, 160, 160, 160),
                //       ),
                //     ),
                //     sideTitles: SideTitles(
                //         showTitles: true,
                //         getTitlesWidget: (double value, TitleMeta meta) {
                //           return Text(
                //             value.toInt().toString(),
                //             style: const TextStyle(
                //                 color: Color.fromARGB(255, 160, 160, 160)),
                //           );
                //         },
                //         interval: 1)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: false,
                drawVerticalLine: false,
              ),
              // グラフの外枠線
              borderData: FlBorderData(
                show: false, // 外枠線の有無
              ),
            ),
            swapAnimationDuration: zeroDuration,
          )),
    ]);
  }
}
