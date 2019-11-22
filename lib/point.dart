import 'package:flutter/material.dart';

class Point {
  final double x;
  final double y;
  Offset offset;
  bool touched;
  int index;

  Point(this.x, this.y, this.index)
      : offset = Offset(x, y),
        touched = false;
}
