import 'package:flutter/material.dart';

class DrawPoint {
  Offset position;
  Color color;
  double strokeWidth;
  bool isEraser;

  DrawPoint({
    required this.position,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': position.dx,
      'y': position.dy,
      'color': color.value,
      'strokeWidth': strokeWidth,
      'isEraser': isEraser,
    };
  }

  static DrawPoint fromJson(Map<String, dynamic> json) {
    return DrawPoint(
      position: Offset(json['x'], json['y']),
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'],
      isEraser: json['isEraser'],
    );
  }
}
