import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../../data/models/overtime_preview_model.dart';

class OvertimePreviewCard extends StatelessWidget {
  final String title; // "الزيادة على اليوم" / "الزيادة على الساعة"
  final OvertimePreviewModel? preview;
  final bool isLoading;
  final String? subtitle; // مثلاً "3.5 × ساعة/SYP 5,000"
  final Color? amountColor;
  final VoidCallback? onTap; // اختيار هذا النوع (يوم كامل / ساعات)
  final bool selected; // هل هذا الخيار هو المحدد حالياً

  const OvertimePreviewCard({
    super.key,
    required this.title,
    required this.preview,
    required this.isLoading,
    this.subtitle,
    this.amountColor,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF0F1B4C) : palette.chipBorder,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            if (isLoading)
              const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text(
                preview == null
                    ? '—'
                    : 'SYP ${preview!.estimatedAmount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: amountColor ?? palette.textPrimary,
                ),
              ),
            if (subtitle != null && !isLoading) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: palette.hint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
