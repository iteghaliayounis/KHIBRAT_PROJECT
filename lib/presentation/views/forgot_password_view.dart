import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/forgot_password_controller.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ── AppBar العلوي الموحد ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
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
                  Text(
                    'forgot_password_title'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF002166),
                    ),
                  ),
                  const SizedBox(width: 40), // لموازنة عنوان الشاشة في الوسط
                ],
              ),

              const SizedBox(height: 20),

              // ── الصورة التوضيحية ──
              _EntranceFade(
                child: Center(
                  child: Image.asset(
                    'assets/images/forgot_password_illustration.png',
                    height: 290,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),


              const SizedBox(height: 28),

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
                        fontWeight: FontWeight.w600,
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

              const SizedBox(height: 32),

              // ── زر إرسال الرمز ──
              _EntranceFade(
                delayMs: 350,
                child: Obx(
                  () => SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.sendResetCode,
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
                                    'send_code'.tr,
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