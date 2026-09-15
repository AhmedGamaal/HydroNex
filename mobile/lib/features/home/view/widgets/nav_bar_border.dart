import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class NavBarBorder extends StatelessWidget {
  final Widget child;

  const NavBarBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(foregroundPainter: NavBarBorderPainter(), child: child);
  }
}

class NavBarBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const radius = 24.0;

    // عرض الـ notch
    const notchWidth = 70.0;

    // عمق الـ notch
    const notchDepth = 42.0;

    final centerX = size.width / 2;

    final leftNotch = centerX - notchWidth / 2;
    final rightNotch = centerX + notchWidth / 2;

    final path = Path();

    // =========================
    // Top Left
    // =========================

    path.moveTo(radius, 0);

    path.lineTo(leftNotch, 0);

    // =========================
    // Smooth Notch
    // =========================

    path.cubicTo(
      leftNotch + 4,
      0,
      centerX - 40,
      notchDepth,
      centerX,
      notchDepth,
    );

    path.cubicTo(centerX + 40, notchDepth, rightNotch - 4, 0, rightNotch, 0);

    // =========================
    // Top Right
    // =========================

    path.lineTo(size.width - radius, 0);

    // =========================
    // Top Right Corner
    // =========================

    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // =========================
    // Right Side
    // =========================

    path.lineTo(size.width, size.height - radius);

    // =========================
    // Bottom Right Corner
    // =========================

    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    // =========================
    // Bottom
    // =========================

    path.lineTo(radius, size.height);

    // =========================
    // Bottom Left Corner
    // =========================

    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // =========================
    // Left Side
    // =========================

    path.lineTo(0, radius);

    // =========================
    // Top Left Corner
    // =========================

    path.quadraticBezierTo(0, 0, radius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
