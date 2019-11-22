import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:math';

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    fillCanvas(canvas, size, Colors.deepPurple);
    //drawSunSky(canvas, size);
    //divideScreen(canvas, size, Colors.green);
    //drawPie(canvas, size);
    drawBox(canvas, size, Colors.redAccent, 100, 500, 250, 150);
    drawShape(canvas, size, Colors.blue);
    drawLyn(canvas, size, Colors.black, 100, 100, 200, 200);
    drawCircle(canvas, size, Colors.cyanAccent, 100, 500, 100);
  }

  void drawBox(Canvas canvas, Size size, Color color, double tlx, double tly,
      double w, double h) {
    final paint = Paint();
    paint.color = color;
    final rect = Rect.fromLTWH(tlx, tly, w, h);
    canvas.drawRect(
      rect,
      paint,
    );
  }

  void drawLyn(Canvas canvas, Size size, Color color, double sx, double sy,
      double ex, double ey) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
  }

  void drawShape(Canvas canvas, Size size, Color color) {
    final paint = Paint()..color = color;
    var path = Path();

    path.moveTo(150, 150);
    path.lineTo(300, 100);
    path.lineTo(300, 300);
    path.lineTo(100, 400);
    path.lineTo(150, 150);
    // close the path to form a bounded shape
    //path.close();
    canvas.drawPath(path, paint);
  }

  void drawSunSky(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 0.2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  void fillCanvas(Canvas canvas, Size size, Color color) {
    final paint = Paint()..color = color;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
  }

  void drawPie(Canvas canvas, Size size) {
    double wheelSize = 100;
    double nbElem = 6;
    double radius = (2 * pi) / nbElem;

    canvas.drawPath(
        getWheelPath(wheelSize, 0, radius), getColoredPaint(Colors.red));
    canvas.drawPath(getWheelPath(wheelSize, radius, radius),
        getColoredPaint(Colors.purple));
    canvas.drawPath(getWheelPath(wheelSize, radius * 2, radius),
        getColoredPaint(Colors.blue));
    canvas.drawPath(getWheelPath(wheelSize, radius * 3, radius),
        getColoredPaint(Colors.green));
    canvas.drawPath(getWheelPath(wheelSize, radius * 4, radius),
        getColoredPaint(Colors.yellow));
    canvas.drawPath(getWheelPath(wheelSize, radius * 5, radius),
        getColoredPaint(Colors.orange));
  }

  void divideScreen(Canvas canvas, Size size, Color color) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
  }

  void drawCircle(Canvas canvas, Size size, Color color, double offx,
      double offy, double radius) {
    final paint = Paint();
    paint.color = color;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(offx, offy);
    // draw the circle with center having radius 75.0
    canvas.drawCircle(center, radius, paint);
  }

  Paint getColoredPaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    return paint;
  }

  Path getWheelPath(double wheelSize, double fromRadius, double toRadius) {
    return new Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
              radius: wheelSize, center: Offset(wheelSize, wheelSize)),
          fromRadius,
          toRadius,
          false)
      ..close();
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
