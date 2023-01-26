import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomTimePainter extends CustomPainter {
  CustomTimePainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;
    canvas.drawPaint(paint);

    final top = ui.lerpDouble(0, size.height, animation.value)!;
    Rect rect = Rect.fromLTRB(0, top, size.width, size.height);
    Path path = Path()..addRect(rect);

    canvas.drawPath(path, paint..color = color);
  }

  @override
  bool shouldRepaint(CustomTimePainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
