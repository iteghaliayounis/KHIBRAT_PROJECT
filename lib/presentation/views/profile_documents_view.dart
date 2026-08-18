import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';
import '../widgets/profile/profile_upload_box.dart';
import '../../core/theme/khubrat_colors.dart';

class ProfileDocumentsView extends GetView<ProfileController> {
  const ProfileDocumentsView({super.key});

  static const Color _navy = Color(0xFF002173);
  static const Color _goldLight = Color(0xFFFCD88A);
  static const Color _bg = Color(0xFFF8FAFC);

  bool get _isArabic => Get.locale?.languageCode == 'ar';
  TextDirection get _textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    // ⬅️ نفس أسلوب profile_view.dart: نلف الشاشة كلها بـ Directionality
    // صريحة مبنية على اللغة الحالية، بدل الاعتماد على القيم الافتراضية.
    return Directionality(
      textDirection: _textDirection,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 64,
                color: _navy,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  textDirection: _textDirection,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isArabic ? Icons.chevron_right : Icons.chevron_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'profile_documents_title'.tr,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: _goldLight,
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.khubrat.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: context.khubrat.chipBorder),
                      ),
                      child: Text(
                        'profile_documents_description'.tr,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: context.khubrat.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => ProfileUploadBox(
                        label: 'profile_identity_image'.tr,
                        icon: Icons.badge_outlined,
                        file: controller.identityFile.value,
                        onTap: controller.pickIdentityFile,
                        required: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => ProfileUploadBox(
                        label: 'profile_certificate_image'.tr,
                        icon: Icons.school_outlined,
                        file: controller.certificateFile.value,
                        onTap: controller.pickCertificateFile,
                        required: false,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.khubrat.surface,
                  border: Border(top: BorderSide(color: context.khubrat.chipBorder)),
                ),
                child: Obx(() {
                  final loading = controller.isUploadingDocuments.value;
                  return InkWell(
                    onTap: loading ? null : controller.submitDocuments,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_navy, Color(0xFF001242)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'profile_upload_documents_button'.tr,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
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
