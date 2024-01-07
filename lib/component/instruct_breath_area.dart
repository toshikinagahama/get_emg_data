import 'dart:math';
import 'package:flutter/material.dart';

class InstructBreathPainter extends CustomPainter {
  InstructBreathPainter(
      {required this.t,
      required this.total,
      required this.color,
      required this.mode});
  final double t;
  final double total;
  final Color color;
  final String mode;

  @override
  void paint(Canvas canvas, Size size) {
    switch (mode) {
      case "wave":
        drawWave(canvas, size);
        break;
      case "continuous_circle":
        drawContinuousCircle(canvas, size);
        break;
      case "level_circle":
        drawLevelCircle(canvas, size);
        break;
      case "continuous_vertical_bar":
        drawContinuousVerticalBar(canvas, size);
        break;
      case "continuous_horizontal_bar":
        drawContinuousHorizontalBar(canvas, size);
        break;
      case "level_vertical_bar":
        drawLevelVerticalBar(canvas, size);
        break;
      case "level_horizontal_bar":
        drawLevelHorizontalBar(canvas, size);
        break;
      default:
        drawContinuousCircle(canvas, size);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  //波形
  void drawWave(Canvas canvas, Size size) {
    //
    Paint paint = Paint();
    Path path = Path();
    double h = size.height * 0.8;
    double w = size.width * 0.9;
    double leftOffset = size.width * 0.1 / 2;
    double bottomOffset = h / 10.0;
    int num = 200;
    double numWave = 3;

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    if (total < numWave / 2) {
      paint = Paint()
        ..color = Color.fromARGB(150, 162, 162, 162)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      List<Offset> points = [];
      //for (var i = 0; i < num * total; i++) {
      for (var i = 0; i < num * numWave; i++) {
        points.add(
          Offset(
            i / (num * numWave) * w + leftOffset,
            (cos(2.0 * pi * i / num)) * h / 5 + size.height / 2,
          ),
        );
      }
      path = Path()..addPolygon(points, false);
      canvas.drawPath(path, paint);
      paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      points = [];
      //for (var i = 0; i < num * total; i++) {
      for (var i = 0; i < num * total; i++) {
        points.add(
          Offset(
            i / (num * numWave) * w + leftOffset,
            (cos(2.0 * pi * i / num)) * h / 5 + size.height / 2,
          ),
        );
      }
      path = Path()..addPolygon(points, false);
      canvas.drawPath(path, paint);
    } else {
      //波形を流す
      paint = Paint()
        ..color = Color.fromARGB(80, 131, 131, 131)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      List<Offset> points = [];
      //for (var i = 0; i < num * total; i++) {
      for (var i = 0; i < num * numWave; i++) {
        points.add(
          Offset(
            i / (num * numWave) * w + leftOffset,
            (cos(2.0 * pi * (i / num + total - numWave / 2))) * h / 5 +
                size.height / 2,
          ),
        );
      }
      path = Path()..addPolygon(points, false);
      canvas.drawPath(path, paint);
      paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      points = [];
      //for (var i = 0; i < num * total; i++) {
      for (var i = 0; i < num * numWave / 2; i++) {
        points.add(
          Offset(
            i / (num * numWave) * w + leftOffset,
            (cos(2.0 * pi * (i / num + total - numWave / 2))) * h / 5 +
                size.height / 2,
          ),
        );
      }
      path = Path()..addPolygon(points, false);
      canvas.drawPath(path, paint);
    }
  }

  //線形バー（縦）
  void drawContinuousVerticalBar(Canvas canvas, Size size) {
    //
    Paint paint = Paint();
    Path path = Path();
    double h = size.height * 0.8;
    double w = size.width / 8;
    double bottomOffset = h / 10.0;

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 四角（外線）
    paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    path = Path();
    path.moveTo(size.width / 2 - w / 2, size.height - bottomOffset - 0.0);
    path.lineTo(size.width / 2 - w / 2, size.height - bottomOffset - h);
    path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - h);
    path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - 0.0);
    path.close();
    canvas.drawPath(path, paint);

    // 四角（塗りつぶし）
    paint = Paint();
    path = Path();
    paint.color = color;
    path.moveTo(size.width / 2 - w / 2, size.height - bottomOffset - 0.0);
    path.lineTo(size.width / 2 - w / 2, size.height - bottomOffset - h * t);
    path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - h * t);
    path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - 0.0);
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawContinuousHorizontalBar(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();
    double h = size.height / 8;
    double w = size.width * 0.9;
    double leftOffset = w / 10.0;

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 四角（外線）
    paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    path = Path();
    path.moveTo(leftOffset + 0.0, size.height / 2 - h / 2);
    path.lineTo(leftOffset + w, size.height / 2 - h / 2);
    path.lineTo(leftOffset + w, size.height / 2 + h / 2);
    path.lineTo(leftOffset + 0.0, size.height / 2 + h / 2);

    path.close();
    canvas.drawPath(path, paint);

    // 四角（塗りつぶし）
    paint = Paint();
    path = Path();
    paint.color = color;
    path.moveTo(leftOffset + 0.0, size.height / 2 - h / 2);
    path.lineTo(leftOffset + w * t, size.height / 2 - h / 2);
    path.lineTo(leftOffset + w * t, size.height / 2 + h / 2);
    path.lineTo(leftOffset + 0.0, size.height / 2 + h / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  //段階バー（縦）
  void drawLevelVerticalBar(Canvas canvas, Size size) {
    //
    int numLevel = 7; //何段階か
    int margin = 10; //マージン
    Paint paint = Paint();
    Path path = Path();
    double h = size.height * 0.8;
    double w = size.width / 8;
    double bottomOffset = h / 10.0;
    double h1 = (h - margin * 6) / 7; //一つのブロックの高さ

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 四角（外線）
    for (int i = 0; i < numLevel; i++) {
      paint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      path = Path();
      double tmp = i - 1;
      double offset = h1 * i + tmp * margin;

      path.moveTo(size.width / 2 - w / 2, size.height - bottomOffset - offset);
      path.lineTo(
          size.width / 2 - w / 2, size.height - bottomOffset - offset - h1);
      path.lineTo(
          size.width / 2 + w / 2, size.height - bottomOffset - offset - h1);
      path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - offset);
      path.close();
      canvas.drawPath(path, paint);
    }

    // 四角（塗りつぶし）
    for (int i = 0; i < (t * 7).round(); i++) {
      paint = Paint();
      path = Path();
      paint.color = color;
      double tmp = i - 1;
      double offset = h1 * i + tmp * margin;
      path.moveTo(size.width / 2 - w / 2, size.height - bottomOffset - offset);
      path.lineTo(
          size.width / 2 - w / 2, size.height - bottomOffset - offset - h1);
      path.lineTo(
          size.width / 2 + w / 2, size.height - bottomOffset - offset - h1);
      path.lineTo(size.width / 2 + w / 2, size.height - bottomOffset - offset);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  //段階バー（横）
  void drawLevelHorizontalBar(Canvas canvas, Size size) {
    //
    int numLevel = 7; //何段階か
    int margin = 10; //マージン
    Paint paint = Paint();
    Path path = Path();
    double h = size.height / 8;
    double w = size.width * 0.9;
    double leftOffset = w / 10.0;
    double w1 = (w - margin * 6) / 7; //一つのブロックの高さ

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 四角（外線）
    for (int i = 0; i < numLevel; i++) {
      paint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      path = Path();
      double tmp = i - 1;
      double offset = w1 * i + tmp * margin;

      path.moveTo(leftOffset + offset, size.height / 2 - h / 2);
      path.lineTo(leftOffset + offset + w1, size.height / 2 - h / 2);
      path.lineTo(leftOffset + offset + w1, size.height / 2 + h / 2);
      path.lineTo(leftOffset + offset, size.height / 2 + h / 2);
      path.close();
      canvas.drawPath(path, paint);
    }

    // 四角（塗りつぶし）
    for (int i = 0; i < (t * 7).round(); i++) {
      paint = Paint();
      path = Path();
      paint.color = color;
      double tmp = i - 1;
      double offset = w1 * i + tmp * margin;
      path.moveTo(leftOffset + offset, size.height / 2 - h / 2);
      path.lineTo(leftOffset + offset + w1, size.height / 2 - h / 2);
      path.lineTo(leftOffset + offset + w1, size.height / 2 + h / 2);
      path.lineTo(leftOffset + offset, size.height / 2 + h / 2);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  //円線形
  void drawContinuousCircle(Canvas canvas, Size size) {
    //print(size);
    final double r = size.width / 2 * 0.9;
    Paint paint = Paint();
    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), r, paint);
    paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), r * t, paint);
  }

  //円段階
  void drawLevelCircle(Canvas canvas, Size size) {
    int numLevel = 7; //何段階か
    int margin = 5; //マージン
    Paint paint = Paint();
    double r = size.width / 2 * 0.9;
    double r1 = (r - margin * 6) / 7; //一つのブロックの高さ

    paint.color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 四角（外線）
    for (int i = 0; i < numLevel; i++) {
      if (i < (t * 7).round()) {
        paint = Paint()..color = color;
      } else {
        paint = Paint()..color = const Color.fromARGB(80, 131, 131, 131);
      }
      if (i == 0) {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(size.width / 2, size.height / 2), r1 / 2, paint);
      } else {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = r1;
        canvas.drawCircle(
            Offset(size.width / 2, size.height / 2), (r1 + margin) * i, paint);
      }
    }
  }
}

class InstructBreathArea extends StatelessWidget {
  const InstructBreathArea(
      {required this.t,
      required this.total,
      required this.color,
      required this.mode,
      Key? key})
      : super(key: key);
  final double t;
  final double total;
  final String mode;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          InstructBreathPainter(t: t, total: total, color: color, mode: mode),
    );
  }
}
