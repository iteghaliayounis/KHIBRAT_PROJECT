import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';

class SalaryEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const SalaryEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: palette.hint),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class SalarySkeleton extends StatefulWidget {
  const SalarySkeleton({super.key});

  @override
  State<SalarySkeleton> createState() => _SalarySkeletonState();
}

class _SalarySkeletonState extends State<SalarySkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
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
      builder: (_, _) {
        final t = 0.35 + (_controller.value * 0.35);
        final palette = context.khubrat;
        final from = palette.isDark ? palette.surface : const Color(0xFFE8EDF5);
        final to = palette.isDark ? palette.inputFill : Colors.white;
        return Column(
          children: List.generate(3, (i) {
            return Container(
              margin: EdgeInsets.only(bottom: i == 2 ? 0 : 12),
              height: i == 0 ? 140 : 92,
              decoration: BoxDecoration(
                color: Color.lerp(from, to, t),
                borderRadius: BorderRadius.circular(18),
              ),
            );
          }),
        );
      },
    );
  }
}

class SalarySectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailing;

  const SalarySectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: palette.inputFill,
            shape: BoxShape.circle,
            border: Border.all(color: palette.chipBorder),
          ),
          child: Icon(icon, size: 16, color: palette.title),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: AppTextStyles.h3.copyWith(color: palette.title)),
        ),
        if (trailing != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: palette.inputFill,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.chipBorder),
            ),
            child: Text(
              trailing!,
              style: AppTextStyles.bodySmall.copyWith(color: palette.textSecondary),
            ),
          ),
      ],
    );
  }
}
