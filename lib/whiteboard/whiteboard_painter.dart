import 'package:flutter/material.dart';

import 'point_data.dart'; // Import the PointData class

class WhiteboardPainter extends CustomPainter {
  final List<PointData> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      // Ensure both points are valid and belong to the same stroke
      if (points[i].point != Offset.zero &&
          points[i + 1].point != Offset.zero) {
        if (points[i].strokeId == points[i + 1].strokeId) {
          // Connect only sequential points within the same stroke
          canvas.drawLine(points[i].point, points[i + 1].point, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
