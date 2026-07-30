import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../controllers/language_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_option_card.dart';

class LanguageSelectionView extends GetView<LanguageController> {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // الخلفية الزرقاء الداكنة فقط
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // العنوان الرئيسي باللون الذهبي المطابق للصورة
              Text(
                'اختر لغة التطبيق', // أو 'choose_language'.tr
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.secondary, // اللون الذهبي
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 10),

              // النص الفرعي
              Text(
                'Please select your preferred application language', // أو 'choose_language_desc'.tr
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // بطاقات اختيار اللغة
              Obx(
                () => Column(
                  children: [
                    LanguageOptionCard(
                      label: 'اللغة العربية',
                      countryCode: 'SY',
                      selected: controller.selectedLocale.value == 'ar_SY',
                      onTap: controller.selectArabic,
                    ),
                    const SizedBox(height: 16),
                    LanguageOptionCard(
                      label: 'English Language',
                      countryCode: 'US',
                      selected: controller.selectedLocale.value == 'en_US',
                      onTap: controller.selectEnglish,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // زر المتابعة
              CustomButton(
                label: 'متابعة', // أو 'continue_btn'.tr
                style: CustomButtonStyle.gold,
              
                onPressed: controller.confirmSelection,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}