import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'assistant_palette.dart';

class LuxuryGradientBorder extends StatefulWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final bool glow;

  const LuxuryGradientBorder({
    super.key,
    required this.child,
    this.radius = 18,
    this.borderWidth = 2.2,
    this.glow = true,
  });

  @override
  State<LuxuryGradientBorder> createState() => _LuxuryGradientBorderState();
}

class _LuxuryGradientBorderState extends State<LuxuryGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: SweepGradient(
              transform: GradientRotation(_controller.value * math.pi * 2),
              colors: const [
                AssistantPalette.gold,
                AssistantPalette.navy,
                AssistantPalette.goldDeep,
                Color(0xFF42A5F5),
                AssistantPalette.gold,
              ],
            ),
            boxShadow: widget.glow
                ? [
                    BoxShadow(
                      color: AssistantPalette.gold.withOpacity(0.28),
                      blurRadius: 14,
                      spreadRadius: 0.4,
                    ),
                    BoxShadow(
                      color: AssistantPalette.navy.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(widget.borderWidth),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SoundWavesIndicator extends StatefulWidget {
  final bool isDark;

  const SoundWavesIndicator({super.key, required this.isDark});

  @override
  State<SoundWavesIndicator> createState() => _SoundWavesIndicatorState();
}

class _SoundWavesIndicatorState extends State<SoundWavesIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  static const _colors = [
    AssistantPalette.gold,
    AssistantPalette.navy,
    Color(0xFF42A5F5),
    AssistantPalette.goldDeep,
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );
      Future<void>.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_controllers[i].value);
            final height = 6.0 + (t * 16);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: 4.5,
              height: height,
              decoration: BoxDecoration(
                color: _colors[i],
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        );
      }),
    );
  }
}

class MessageBubbleIn extends StatelessWidget {
  final Widget child;

  const MessageBubbleIn({super.key, required this.child});

  static const Curve curve = Cubic(0.22, 1.2, 0.36, 1);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: curve,
      builder: (context, value, child) {
        final scale = 0.92 + (value * 0.10) - (value > 0.85 ? (value - 0.85) * 0.133 : 0);
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - value)),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class SendPulseButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;

  const SendPulseButton({
    super.key,
    required this.onPressed,
    required this.enabled,
    this.loading = false,
  });

  @override
  State<SendPulseButton> createState() => _SendPulseButtonState();
}

class _SendPulseButtonState extends State<SendPulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    if (!widget.enabled || widget.loading) return;
    await _pulse.forward(from: 0);
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final t = _pulse.value;
          double scale = 1;
          if (t < 0.35) {
            scale = 1 - (t / 0.35) * 0.14;
          } else if (t < 0.7) {
            scale = 0.86 + ((t - 0.35) / 0.35) * 0.22;
          } else {
            scale = 1.08 - ((t - 0.7) / 0.3) * 0.08;
          }
          return Transform.scale(scale: scale, child: child);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.enabled ? 1 : 0.45,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AssistantPalette.navy,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AssistantPalette.navy.withOpacity(0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
}
