import 'package:flutter/material.dart';

/// Painter custom-built to draw the exact 3-node connected network icon from the design.
class NetworkHubIconPainter extends CustomPainter {
  final Color color;

  NetworkHubIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Triangle vertices (3 nodes)
    final topPoint = Offset(size.width * 0.5, size.height * 0.22);
    final bottomLeft = Offset(size.width * 0.22, size.height * 0.75);
    final bottomRight = Offset(size.width * 0.78, size.height * 0.75);

    // Draw connecting lines
    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..close();

    canvas.drawPath(path, paint);

    // Draw filled node circles at each vertex
    final double nodeRadius = size.width * 0.13;
    canvas.drawCircle(topPoint, nodeRadius, fillPaint);
    canvas.drawCircle(bottomLeft, nodeRadius, fillPaint);
    canvas.drawCircle(bottomRight, nodeRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetworkHubIcon extends StatelessWidget {
  final double size;
  final Color color;

  const NetworkHubIcon({
    super.key,
    this.size = 42.0,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: NetworkHubIconPainter(color: color),
      ),
    );
  }
}