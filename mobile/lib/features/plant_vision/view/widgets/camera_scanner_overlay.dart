import 'package:flutter/material.dart';

class CameraScannerOverlay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CameraScannerPainter(),
      size: Size(180, 180),
    );
  }
}

class CameraScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double cornerLength = 30;
    double radius = 15;

    Path path = Path();

    path.moveTo(0, radius + cornerLength);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(radius + cornerLength, 0);

    path.moveTo(size.width - radius - cornerLength, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, radius + cornerLength);

    path.moveTo(0, size.height - radius - cornerLength);
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(radius + cornerLength, size.height);

    path.moveTo(size.width - radius - cornerLength, size.height);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - radius,
    );
    path.lineTo(size.width, size.height - radius - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
