import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/overtime_preview_model.dart';

class OvertimePreviewCard extends StatelessWidget {
  final String title; // "الزيادة على اليوم" / "الزيادة على الساعة"
  final OvertimePreviewModel? preview;
  final bool isLoading;
  final String? subtitle; // مثلاً "3.5 × ساعة/SYP 5,000"
  final Color amountColor;
  final VoidCallback? onTap; // اختيار هذا النوع (يوم كامل / ساعات)
  final bool selected; // هل هذا الخيار هو المحدد حالياً

  const OvertimePreviewCard({
    super.key,
    required this.title,
    required this.preview,
    required this.isLoading,
    this.subtitle,
    this.amountColor = const Color(0xFF0F172A),
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF0F1B4C) : const Color(0xFFEFEFF4),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            // عنوان البوكس (الزيادة على اليوم / الزيادة على الساعة)
            // بنفس خط باقي الواجهة (Cairo)
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
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
              // مبلغ العملة (SYP) فقط: خط مختلف مخصص للأرقام والعملة
              // ليكون واضح ومريح للعين بدل الخط الافتراضي
              Text(
                preview == null
                    ? '—'
                    : 'SYP ${preview!.estimatedAmount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: amountColor,
                ),
              ),
            if (subtitle != null && !isLoading) ...[
              const SizedBox(height: 2),
              // تفصيل الحساب يحتوي أرقام وعملة أيضاً، فنفس خط العملة
              Text(
                subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
