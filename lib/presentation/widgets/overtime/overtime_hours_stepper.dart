import 'package:flutter/material.dart';

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
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF0F172A), width: 1.4),
      ),
      child: Row(
        children: [
          _StepperButton(icon: Icons.add, onTap: onIncrement),
          Expanded(
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _StepperButton(icon: Icons.remove, onTap: onDecrement),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, size: 16, color: Colors.grey.shade600),
      ),
    );
  }
}
