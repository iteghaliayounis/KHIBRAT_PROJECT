import 'package:flutter/material.dart';
import '../../../core/theme/khubrat_colors.dart';

class OvertimeHoursStepper extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const OvertimeHoursStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.inputBorder, width: 1.4),
      ),
      child: Row(
        children: [
          _StepperButton(icon: Icons.add, onTap: onIncrement, color: palette.title),
          Expanded(
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: palette.textPrimary,
                ),
              ),
            ),
          ),
          _StepperButton(icon: Icons.remove, onTap: onDecrement, color: palette.title),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _StepperButton({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
