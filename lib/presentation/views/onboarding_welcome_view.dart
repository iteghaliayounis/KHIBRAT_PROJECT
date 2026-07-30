import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khibrat_flutter2/core/routes/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/network_hub_icon.dart';

class OnboardingWelcomeView extends GetView<OnboardingController> {
  const OnboardingWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002166),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // ── زر الرجوع العلوي المضبوط للغة العربية ──
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // يضعه بالجهة اليمنى
                  children: [
                    InkWell(
                      onTap: () {
                        // يضمن الرجوع لشاشة اختيار اللغة حتى لو مُسحت من الـ Stack
                        if (Navigator.canPop(context)) {
                          Get.back();
                        } else {
Get.offAllNamed(AppRoutes.language); // تأكدي من اسم Route صفحة اللغة لديك
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // استخدام Transform.scale للتحكم باتجاه السهم بوضوح بدون ما يعكسه Flutter تلقائياً
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded, // سهم يشير لليمين للرجوع
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── البطاقة الذهبية في المنتصف ──
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF8DA8C),
                      Color(0xFFB3832B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: NetworkHubIcon(
                    size: 40,
                    color: Color(0xFF002166),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── العنوان ──
              Text(
                'كل ما يخص وظيفتك في مكان واحد',
                textAlign: TextAlign.center,
                style: AppTextStyles.arabicTitle,
              ),

              const SizedBox(height: 14),

              // ── النص الفرعي ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'تتبع دوامك، قدم إجازاتك، راجع كشف راتبك وتواصل مع الـ HR والمدير المباشر بضغطة زر واحدة.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.arabicSubTitle,
                ),
              ),

              const Spacer(flex: 3),

              // ── زر "ابدأ الآن" مع إجبار السهم على التوجه لليسار ──
              CustomButton(
                label: 'ابدأ الآن',
                style: CustomButtonStyle.gold,
                // نمرر السهم المباشر لليسار
                icon: Icons.arrow_back_rounded, 
                onPressed: controller.goToLogin,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}