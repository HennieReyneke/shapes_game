import 'package:flutter/material.dart';
import 'dart:math' as m;
import 'dart:ui';
import 'point.dart';
import 'consts.dart';
import 'audio.dart';
import 'package:vibration/vibration.dart';

class Surface extends CustomPainter {
  List<Point> points = <Point>[]; // Points on all lines
  List<Offset> pList = <Offset>[]; // Touch-points
  List<Offset> offsets = <Offset>[]; // Shape corner points
  Offset p0, p1, p2, p3, p4, p5, p6;
  int touchCnt = 0;
  Audio audio;
  AnimationController controller;
  double aniVal;
  int shape = 0; // Shape number
  int shapeDone = -1;

  Surface(
      List<Offset> _pList,
      Audio audio,
      AnimationController controller,
      double aniVal,
      int shape,
      bool shapeChanged,
      Function resetShapeChanged,
      Function clearPList) {
    if (shapeChanged) {
      shapeDone = -1;
      resetShapeChanged();
      touchCnt = 0;
      clearPList();
      points = <Point>[];
      offsets = <Offset>[];
    }
    this.shape = shape;
    this.pList = _pList;
    this.audio = audio;
    this.controller = controller;
    this.aniVal = aniVal;
  }

  @override
  void paint(Canvas canvas, Size size) {
    fillCanvas(canvas, size, Colors.yellow);
    //placePoints(canvas, size, Colors.black, 8);
    //drawLyn(canvas, size, Colors.purple, 8, 10, 10, 350, 50);
    //drawBox(canvas, size, Colors.redAccent, 8, 50, 50, 300, 200);
    //drawCircle(canvas, size, Colors.cyanAccent, 8, 150, 300, 100);
    //drawEllipse(canvas, size, Colors.green, 8, 50, 400, 300, 500);
    //drawPad(canvas, size, Colors.blue, 8);
    //drawArc(canvas, size, Colors.pink, 8, 50, 300, 350, 500);
    //placeText(canvas, size, Colors.deepPurple, 30, 300, 'Hello world', 100, 300);
    //drawStuk(canvas, size, Colors.redAccent, appStrokeWidth,
    //  points[p.index - 1].offset, p.offset);
    //fillPoly(canvas, size, Colors.blue);
    //if (offsets != null) offsets.clear();
    switch (shape) {
      case 0:
        p0 = Offset(200, 100);
        p1 = Offset(350, 500);
        p2 = Offset(50, 500);
        offsets = <Offset>[p0, p1, p2];
        break;
      case 1:
        p0 = Offset(50, 150);
        p1 = Offset(350, 150);
        p2 = Offset(350, 550);
        p3 = Offset(50, 550);
        offsets = <Offset>[p0, p1, p2, p3];
        break;
      case 2:
        p0 = Offset(50, 50);
        p1 = Offset(350, 250);
        p2 = Offset(250, 650);
        p3 = Offset(50, 500);
        p4 = Offset(100, 350);
        p5 = Offset(250, 300);
        p6 = Offset(100, 250);
        offsets = <Offset>[p0, p1, p2, p3, p4, p5, p6];
        break;
    }
    drawPoly(canvas, size, Colors.pinkAccent, appStrokeWidth, offsets);
    if (aniVal <= 0.2) {
      fillPoly(canvas, size,
          Color.fromARGB((255 * 5 * aniVal).toInt(), 255, 255, 255), offsets);
    } else if (0.2 < aniVal && aniVal <= 0.4) {
      fillPoly(
          canvas,
          size,
          Color.fromARGB(
              (255 * 5 * aniVal - 255 * 5 * 0.2).toInt(), 0, 255, 255),
          offsets);
    } else if (0.4 < aniVal && aniVal <= 0.6) {
      fillPoly(
          canvas,
          size,
          Color.fromARGB(
              (255 * 5 * aniVal - 255 * 5 * 0.4).toInt(), 255, 0, 255),
          offsets);
    } else if (0.6 < aniVal && aniVal <= 0.8) {
      fillPoly(
          canvas,
          size,
          Color.fromARGB(
              (255 * 5 * aniVal - 255 * 5 * 0.4).toInt(), 255, 255, 0),
          offsets);
    } else if (0.8 < aniVal && aniVal <= 1) {
      fillPoly(
          canvas,
          size,
          Color.fromARGB((255 * 5 * aniVal - 255 * 5 * 0.8).toInt(), 255, 0, 0),
          offsets);
    }
    checkPoints(canvas, size);
  }

  void checkPoints(Canvas canvas, Size size) {
    if (pList == null || pList.length == 0) {
      return;
    }
    for (Offset o in pList) {
      for (Point p in points) {
        if (!p.touched &&
            o.dx <= p.x + dev &&
            o.dx >= p.x - dev &&
            o.dy <= p.y + dev &&
            o.dy >= p.y - dev) {
          p.touched = true;
          touchCnt++;
          if (p.index + 1 < points.length) {
            drawStuk(canvas, size, Colors.cyanAccent, appStrokeWidth, p.offset,
                points[p.index + 1].offset);
          }
        }
      }
    }
    if (shapeDone == shape) return;
    for (Point p in points) {
      if (!p.touched) return;
    }
    // Figure trace completed:
    shapeDone = shape;
    audio.start();
    controller.forward();
    List<int> pat = <int>[];
    for (int i = 0; i < 20; i++) {
      pat.add(100);
      pat.add(100);
    }
    Vibration.vibrate(pattern: pat, intensities: [255, 255]);
  }

  void drawPoly(Canvas canvas, Size size, Color color, double strokeWidth,
      List<Offset> offsets) {
    points = <Point>[];
    double len, d, vx, vy, px, py;
    int index = 0;
    int next;

    for (int i = 0; i < offsets.length; i++) {
      if (i == offsets.length - 1) {
        next = 0;
      } else {
        next = i + 1;
      }
      len = m.pow(
          (m.pow(offsets[next].dx - offsets[i].dx, 2) +
              m.pow(offsets[next].dy - offsets[i].dy, 2)),
          0.5); // Length of line
      d = len / lynDivCnt; // Distance between points
      px = offsets[i].dx; // Current point's x
      py = offsets[i].dy; // Current point's y
      vx = (offsets[next].dx - px) / lynDivCnt; // x distance to next point
      vy = (offsets[next].dy - py) / lynDivCnt; // y distance to next point
      for (double n = 0; n <= len + divErrMargin; n += d) {
        points.add(Point(px, py, index));
        index++;
        px += vx;
        py += vy;
      }
    }
    final path = Path()..addPolygon(offsets, true);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
    //placePoints(canvas, size, Colors.white, 8, points);
  }

  void fillPoly(Canvas canvas, Size size, Color color, List<Offset> offsets) {
    final path = Path()..addPolygon(offsets, true);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  void fillCanvas(Canvas canvas, Size size, Color color) {
    final paint = Paint()..color = color;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  void placePoints(Canvas canvas, Size size, Color color, double strokeWidth,
      List<Point> pList) {
    final pointMode = PointMode.points;
    List<Offset> pts = [];
    for (Point p in pList) {
      pts.add(p.offset);
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, pts, paint);
  }

  static void drawStuk(Canvas canvas, Size size, Color color,
      double strokeWidth, Offset offsetBegin, Offset offsetEnd) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawLine(offsetBegin, offsetEnd, paint);
  }

  void drawLyn(Canvas canvas, Size size, Color color, double strokeWidth,
      double sx, double sy, double ex, double ey) {
    final p1 = Offset(sx, sy);
    final p2 = Offset(ex, ey);
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawLine(p1, p2, paint);
  }

  void drawBox(Canvas canvas, Size size, Color color, double strokeWidth,
      double left, double top, double right, double bottom) {
    final rect = Rect.fromLTRB(left, top, right, bottom);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRect(rect, paint);
  }

  void drawCircle(Canvas canvas, Size size, Color color, double strokeWidth,
      double offx, double offy, double radius) {
    final center = Offset(offx, offy);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, paint);
  }

  void drawEllipse(Canvas canvas, Size size, Color color, double strokeWidth,
      double left, double top, double right, double bottom) {
    final rect = Rect.fromLTRB(left, top, right, bottom);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawOval(rect, paint);
  }

  void drawPad(Canvas canvas, Size size, Color color, double strokeWidth) {
    final path = Path()
      ..moveTo(50, 500)
      ..lineTo(300, 600)
      ..quadraticBezierTo(400, 0, 200, 300)
      ..lineTo(50, 500);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
  }

  void drawArc(Canvas canvas, Size size, Color color, double strokeWidth,
      double left, double top, double right, double bottom) {
    final rect = Rect.fromLTRB(left, top, right, bottom);
    final startAngle = -m.pi / 2;
    final sweepAngle = m.pi;
    final useCenter = false;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  void placeText(Canvas canvas, Size size, Color color, double fontSize,
      double width, String text, double offx, double offy) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );
    final offset = Offset(offx, offy);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(Surface other) {
    return !(other.pList == pList &&
        other.aniVal == aniVal &&
        other.shape == shape);
  }
}
