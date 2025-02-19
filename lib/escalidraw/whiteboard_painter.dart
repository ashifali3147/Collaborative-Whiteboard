import 'dart:ui';

import 'package:flutter/material.dart';
import 'model/draw_point.dart';

class WhiteboardPainter extends CustomPainter {
  final List<DrawPoint> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      Paint paint = Paint()
        ..color = point.isEraser ? Colors.white : point.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = point.strokeWidth;

      canvas.drawPoints(PointMode.points, [point.position], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
