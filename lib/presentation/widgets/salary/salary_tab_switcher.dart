import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/salary_controller.dart';

class SalaryTabSwitcher extends StatelessWidget {
  final SalaryTab selected;
  final ValueChanged<SalaryTab> onChanged;
  final bool showAdvancesDot;

  const SalaryTabSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showAdvancesDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'salary_tab_slips'.tr,
              icon: Icons.account_balance_wallet_rounded,
              selected: selected == SalaryTab.salaries,
              onTap: () => onChanged(SalaryTab.salaries),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'salary_tab_advances'.tr,
              icon: Icons.volunteer_activism_rounded,
              selected: selected == SalaryTab.advances,
              showDot: showAdvancesDot && selected != SalaryTab.advances,
              onTap: () => onChanged(SalaryTab.advances),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        elevation: selected ? 2 : 0,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: selected ? AppColors.brandNavy : AppColors.brandGold,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          fontSize: 12,
                          color: selected ? AppColors.brandNavy : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (showDot)
                  const Positioned(
                    top: 0,
                    left: 10,
                    child: CircleAvatar(radius: 3.5, backgroundColor: AppColors.brandGold),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
