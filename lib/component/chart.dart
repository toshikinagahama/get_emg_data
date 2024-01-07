/// Example of a stacked area chart.
import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";

//センサーのデータを描画するクラス
class SensorChartArea extends StatelessWidget {
  List<FlSpot>? _dataList;
  Color _color = Colors.white;
  double? _minX;
  double? _maxX;
  double? _minY;
  double? _maxY;
  static const zeroDuration = Duration(microseconds: 0);

  SensorChartArea(List<double> xs, List<double> ys, Color color, double? minX,
      double? maxX, double? minY, double? maxY) {
    _dataList = [];
    if (xs.length > 0) {
      for (int i = 0; i < xs.length; i++) {
        _dataList?.add(FlSpot(xs[i], ys[i]));
      }
    } else {
      _dataList?.add(FlSpot(0, 0));
    }
    _color = color;
    _minX = minX;
    _maxX = maxX;
    _minY = minY;
    _maxY = maxY;
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
                  spots: _dataList,
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
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 160, 160, 160),
                                fontSize: 6),
                          );
                        })),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toStringAsFixed(1),
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
