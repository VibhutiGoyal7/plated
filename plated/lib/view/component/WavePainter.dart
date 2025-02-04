import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height * 1);
    path.quadraticBezierTo(
        size.width * 0.5, size.height, size.width * 0.66, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.7, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
