import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'assistant_palette.dart';

class NeuralOrb extends StatefulWidget {
  final double size;
  final bool isThinking;
  final bool mini;

  const NeuralOrb({
    super.key,
    required this.size,
    this.isThinking = false,
    this.mini = false,
  });

  @override
  State<NeuralOrb> createState() => _NeuralOrbState();
}

class _NeuralOrbState extends State<NeuralOrb> with TickerProviderStateMixin {
  late final AnimationController _flow;
  late final AnimationController _breathe;
  late final AnimationController _ringA;
  late final AnimationController _ringB;
  late final AnimationController _miniSpin;
  late final AnimationController _miniPulse;

  @override
  void initState() {
    super.initState();
    _flow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
    _ringA = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _ringB = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 11),
    )..repeat();
    _miniSpin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _miniPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _syncThinking(widget.isThinking);
  }

  @override
  void didUpdateWidget(covariant NeuralOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isThinking != widget.isThinking) {
      _syncThinking(widget.isThinking);
    }
  }

  void _syncThinking(bool thinking) {
    _breathe.duration = thinking
        ? const Duration(milliseconds: 900)
        : const Duration(milliseconds: 3400);
    if (!_breathe.isAnimating) _breathe.repeat(reverse: true);
    if (thinking) {
      if (!_miniPulse.isAnimating) _miniPulse.repeat(reverse: true);
    } else {
      _miniPulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _flow.dispose();
    _breathe.dispose();
    _ringA.dispose();
    _ringB.dispose();
    _miniSpin.dispose();
    _miniPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mini) return _buildMini();
    return AnimatedBuilder(
      animation: Listenable.merge([_flow, _breathe, _ringA, _ringB]),
      builder: (context, _) {
        final breathe = 1.0 + (_breathe.value * (widget.isThinking ? 0.08 : 0.045));
        final glowBoost = widget.isThinking ? 1.35 : 1.0;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _flow.value * math.pi * 2,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: widget.size * 0.78,
                    height: widget.size * 0.78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          const Color(0x66F5C453).withOpacity(0.55 * glowBoost),
                          const Color(0x6642A5F5).withOpacity(0.45 * glowBoost),
                          const Color(0x66FFD54F).withOpacity(0.5 * glowBoost),
                          const Color(0x660A1D47).withOpacity(0.25 * glowBoost),
                          const Color(0x66F5C453).withOpacity(0.55 * glowBoost),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: breathe,
                child: _OrbCore(
                  size: widget.size * 0.52,
                  brightness: glowBoost,
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0018)
                  ..rotateX(0.72)
                  ..rotateY(_ringA.value * math.pi * 2),
                child: CustomPaint(
                  size: Size(widget.size * 0.92, widget.size * 0.92),
                  painter: _OrbitRingPainter(
                    color: const Color(0xFF90CAF9),
                    stroke: 1.6,
                  ),
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0018)
                  ..rotateX(-0.55)
                  ..rotateY(-_ringB.value * math.pi * 2),
                child: CustomPaint(
                  size: Size(widget.size * 0.78, widget.size * 0.78),
                  painter: _OrbitRingPainter(
                    color: const Color(0xFFFFE082),
                    stroke: 1.3,
                  ),
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0016)
                  ..rotateX(1.05)
                  ..rotateZ(_ringA.value * math.pi),
                child: CustomPaint(
                  size: Size(widget.size * 0.86, widget.size * 0.86),
                  painter: _OrbitRingPainter(
                    color: const Color(0xAA42A5F5),
                    stroke: 1.1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMini() {
    return AnimatedBuilder(
      animation: Listenable.merge([_miniSpin, _miniPulse, _breathe]),
      builder: (context, _) {
        final pulse = widget.isThinking ? 1.0 + (_miniPulse.value * 0.18) : 1.0;
        final brightness = widget.isThinking ? 1.0 + (_miniPulse.value * 0.45) : 1.0;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _miniSpin.value * math.pi * 2,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: const _DottedRingPainter(),
                ),
              ),
              Transform.scale(
                scale: pulse,
                child: _OrbCore(
                  size: widget.size * 0.58,
                  brightness: brightness,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrbCore extends StatelessWidget {
  final double size;
  final double brightness;

  const _OrbCore({required this.size, required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Colors.white,
            AssistantPalette.goldSoft,
            AssistantPalette.goldDeep,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AssistantPalette.gold.withOpacity(0.55 * brightness),
            blurRadius: 22 * brightness,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFF42A5F5).withOpacity(0.22 * brightness),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  final Color color;
  final double stroke;

  _OrbitRingPainter({required this.color, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.96,
      height: size.height * 0.42,
    );
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.stroke != stroke;
}

class _DottedRingPainter extends CustomPainter {
  const _DottedRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF90CAF9)
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    const dots = 18;
    for (var i = 0; i < dots; i++) {
      final angle = (i / dots) * math.pi * 2;
      final offset = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawCircle(offset, i.isEven ? 1.5 : 1.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
