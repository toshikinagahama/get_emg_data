/// Example of a stacked area chart.
import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";

class SimpleSensorChartArea extends StatelessWidget {
  double _counter = 0.0;
  Color _color = Colors.white;
  bool _isShowLLabel = false;
  bool _isShowBLabel = false;
  List<FlSpot> _dataList1 = [];
  static const zeroDuration = Duration(microseconds: 0);

  SimpleSensorChartArea(List<double> dataList1, Color color, bool isShowLLabel,
      bool isShowBLabel) {
    for (int i = 0; i < dataList1.length; i++) {
      _dataList1.add(FlSpot((i).toDouble(), dataList1[i]));
      //_dataList1.add(FlSpot((i / 25).toDouble(), dataList1[i]));
    }
    _color = color;
    _isShowLLabel = isShowLLabel;
    _isShowBLabel = isShowBLabel;
    //print(_dataList1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          flex: 1,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _dataList1,
                  isCurved: false,
                  barWidth: 2,
                  color: _color,
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: _isShowLLabel,
                        reservedSize: 40.0,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            (value).toStringAsFixed(1),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 14),
                          );
                        })),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: _isShowBLabel,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toString(),
                            //(value / 63.0 * 2.0).toStringAsFixed(2),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 160, 160, 160),
                                fontSize: 6),
                          );
                        })),
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
