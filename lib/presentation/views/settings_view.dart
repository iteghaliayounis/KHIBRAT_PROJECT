import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/settings_controller.dart';
import '../widgets/app_bottom_nav.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  static const Color _navy = Color(0xFF002166);
  static const Color _bg = Color(0xFFF4F7FB);
  static const Color _logoutRed = Color(0xFFE25D5D);
  static const Color _lockOrange = Color(0xFFE8A317);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isArabic = controller.selectedLocale.value.startsWith('ar');

      return Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: _bg,
          body: Column(
            children: [
              _buildAppBar(isArabic),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildLanguageCard(),
                    const SizedBox(height: 14),
                    _buildTwoFactorCard(),
                    const SizedBox(height: 14),
                    _buildLogoutCard(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: AppBottomNavBar(
              selectedIndex: 3,
              onTap: _onNavTap,
            ),
          ),
        ),
      );
    });
  }

  void _onNavTap(int index) {
    if (index == 3) return;
    if (index == 0) {
      Get.until((route) => route.settings.name == AppRoutes.home);
      return;
    }
    if (index == 1) {
      Get.offNamed(AppRoutes.profile);
    } else if (index == 2) {
      Get.offNamed(AppRoutes.companyInfo);
    }
  }

  Widget _buildAppBar(bool isArabic) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'settings_title'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isArabic
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public_rounded, color: Color(0xFF2F6BFF), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'settings_language_title'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'settings_language_subtitle'.tr,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Obx(() {
            final isAr = controller.selectedLocale.value.startsWith('ar');
            return Row(
              children: [
                Expanded(
                  child: _languageChip(
                    label: isAr
                        ? 'settings_lang_en'.tr
                        : 'settings_lang_en_active'.tr,
                    selected: !isAr,
                    onTap: () => controller.changeLanguage('en_US'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _languageChip(
                    label: isAr
                        ? 'settings_lang_ar_active'.tr
                        : 'settings_lang_ar'.tr,
                    selected: isAr,
                    onTap: () => controller.changeLanguage('ar_SY'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _languageChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _navy : const Color(0xFFE6EAF0),
            width: selected ? 1.6 : 1.2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: _navy,
          ),
        ),
      ),
    );
  }

  Widget _buildTwoFactorCard() {
    return _card(
      child: Obx(() {
        final enabled = controller.twoFactorEnabled.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: _lockOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: enabled
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    enabled ? 'settings_2fa_on'.tr : 'settings_2fa_off'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: enabled
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings_2fa_title'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'settings_2fa_desc'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: enabled,
              onChanged: controller.isUpdatingTwoFactor.value
                  ? null
                  : controller.toggleTwoFactor,
              activeTrackColor: _navy,
              inactiveTrackColor: const Color(0xFFE6E8EE),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLogoutCard() {
    return Material(
      color: const Color(0xFFFFF1F1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _showLogoutDialog,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.power_settings_new_rounded,
                color: _logoutRed,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'settings_logout'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _logoutRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  color: _logoutRed,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'settings_logout_title'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'settings_logout_message'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'settings_logout_cancel'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _logoutRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'settings_logout_confirm'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.45),
    );
  }
}
