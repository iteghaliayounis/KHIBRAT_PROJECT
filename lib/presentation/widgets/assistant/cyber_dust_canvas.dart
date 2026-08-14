import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'assistant_palette.dart';

class CyberDustCanvas extends StatefulWidget {
  final bool isDark;

  const CyberDustCanvas({super.key, required this.isDark});

  @override
  State<CyberDustCanvas> createState() => _CyberDustCanvasState();
}

class _CyberDustParticle {
  Offset position;
  Offset velocity;
  double radius;
  double opacity;

  _CyberDustParticle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.opacity,
  });
}

class _CyberDustCanvasState extends State<CyberDustCanvas>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final math.Random _random = math.Random(42);
  final List<_CyberDustParticle> _particles = [];
  Size _size = Size.zero;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _ensureParticles(Size size) {
    if (_size == size && _particles.length == 30) return;
    _size = size;
    if (_particles.isEmpty) {
      for (var i = 0; i < 30; i++) {
        _particles.add(_spawn(size));
      }
    }
  }

  _CyberDustParticle _spawn(Size size) {
    return _CyberDustParticle(
      position: Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      ),
      velocity: Offset(
        (_random.nextDouble() * 18) - 9,
        (_random.nextDouble() * 16) - 8,
      ),
      radius: 1.1 + _random.nextDouble() * 1.8,
      opacity: 0.18 + _random.nextDouble() * 0.35,
    );
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _size == Size.zero) return;
    final dt = _lastElapsed == Duration.zero
        ? 1 / 60
        : (elapsed - _lastElapsed).inMicroseconds / 1000000;
    _lastElapsed = elapsed;
    final clamped = dt.clamp(0.0, 0.033);

    for (final p in _particles) {
      var next = p.position + p.velocity * clamped;
      var vx = p.velocity.dx;
      var vy = p.velocity.dy;

      if (next.dx <= 0 || next.dx >= _size.width) {
        vx = -vx;
        next = Offset(next.dx.clamp(0, _size.width), next.dy);
      }
      if (next.dy <= 0 || next.dy >= _size.height) {
        vy = -vy;
        next = Offset(next.dx, next.dy.clamp(0, _size.height));
      }

      p.position = next;
      p.velocity = Offset(vx, vy);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          _ensureParticles(Size(constraints.maxWidth, constraints.maxHeight));
          return CustomPaint(
            painter: _CyberDustPainter(
              particles: _particles,
              isDark: widget.isDark,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CyberDustPainter extends CustomPainter {
  final List<_CyberDustParticle> particles;
  final bool isDark;

  _CyberDustPainter({required this.particles, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      paint.color = (isDark ? Colors.white : AssistantPalette.dust)
          .withOpacity(p.opacity);
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CyberDustPainter oldDelegate) => true;
}
