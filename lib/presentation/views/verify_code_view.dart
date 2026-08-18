import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/verify_code_controller.dart';

class VerifyCodeView extends GetView<VerifyCodeController> {
  const VerifyCodeView({super.key});

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

              // ── Header ──
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
                    'verify_code_title'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF002166),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 40),

              Text(
                'enter_verification_code'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF002166),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${'code_sent_to'.tr} ${controller.email}',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // ── مربعات إدخال الرمز الـ 4 ──
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 60,
                      height: 64,
                      child: TextField(
                        controller: controller.otpControllers[index],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF002166),
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBA158),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            controller.focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            controller.focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),

              Obx(
                () => controller.errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 36),

              // ── زر التأكيد ──
              Obx(
                () => SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.verifyCode,
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'confirm_code'.tr,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── نص إعادة الإرسال / عدّاد الانتظار ──
              Center(
                child: Obx(() {
                  final remaining = controller.cooldownRemaining.value;
                  if (remaining > 0) {
                    return Text(
                      '${'resend_code_in'.tr} 0:${remaining.toString().padLeft(2, '0')}',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'didnt_receive_code'.tr,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      _HoverableResendButton(
                        onTap: controller.isResending.value ? null : controller.resendCode,
                        text: 'resend_code'.tr,
                        enabled: !controller.isResending.value,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverableResendButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final bool enabled;

  const _HoverableResendButton({
    required this.onTap,
    required this.text,
    this.enabled = true,
  });

  @override
  State<_HoverableResendButton> createState() => _HoverableResendButtonState();
}

class _HoverableResendButtonState extends State<_HoverableResendButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final canTap = widget.enabled && widget.onTap != null;
    return MouseRegion(
      onEnter: (_) {
        if (canTap) setState(() => _isHovered = true);
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: canTap ? widget.onTap : null,
        child: Text(
          widget.text,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: !canTap
                ? Colors.grey[400]
                : (_isHovered ? const Color(0xFF002166) : Colors.grey[600]),
            decoration: (_isHovered && canTap) ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}