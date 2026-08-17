import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khibrat_flutter2/core/routes/app_routes.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ── AppBar العلوي ──
              Row(
                children: [
                  InkWell(
onTap: () => Get.offAllNamed('/onboarding'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF002166),
                        size: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'login'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w700, // تخفيف الوزن لتصبح أرق
                        color: const Color(0xFF002166),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 20),

              // ── الصورة التوضيحية ──
              _EntranceFade(
                child: Center(
                  child: Image.asset(
                    'assets/images/login_illustration.png',
                    height: 210,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── عناوين الترحيب الناعمة ──
              _EntranceFade(
                delayMs: 150,
                child: Column(
                  children: [
                    Text(
                      'welcome_back'.tr,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.w700, // وضوح ناعم وممتاز
                        color: const Color(0xFF002166),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'login_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── حقل البريد الإلكتروني ──
              _EntranceFade(
                delayMs: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'email_address'.tr,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600, // خط متناسق
                        color: const Color(0xFF002166),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => CustomTextField(
                        controller: controller.emailController,
                        hintText: 'enter_email'.tr,
                        prefixIcon: Icons.email_outlined,
                        suffixIcon: UnconstrainedBox(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: 8,
                            height: 8,
                          
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        errorText: controller.emailError.value,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── حقل كلمة المرور ──
              _EntranceFade(
                delayMs: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'password'.tr,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF002166),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'enter_password'.tr,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: controller.isPasswordHidden.value,
                        errorText: controller.passwordError.value,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── رابط نسيت كلمة المرور ──
            Align(
  alignment: AlignmentDirectional.centerEnd,
  child: TextButton(
    // 🔹 السطر الأهم: هكذا نربط الضغط بالانتقال لشاشة إدخال الإيميل
    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Text(
      'forgot_password'.tr,
      style: GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFCBA158),
      ),
    ),
  ),
),

              const SizedBox(height: 28),

              // ── زر تسجيل الدخول المطابق للديزاين الأصلي ──
              _EntranceFade(
                delayMs: 450,
                child: Obx(
                  () => SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002166),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFF002166).withOpacity(0.35),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    'login'.tr,
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                           
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntranceFade extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const _EntranceFade({required this.child, this.delayMs = 0});

  @override
  State<_EntranceFade> createState() => _EntranceFadeState();
}

class _EntranceFadeState extends State<_EntranceFade> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}