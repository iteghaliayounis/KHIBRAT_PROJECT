import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:file_picker/file_picker.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/khubrat_colors.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile/profile_info_tile.dart';
import '../widgets/profile/profile_editable_tile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // ✅ إصلاح #2: متغير محلي لتخزين الصورة المختارة (تظهر فوراً قبل رفعها)

  static const Color _navy = Color(0xFF002173);
  static const Color _goldLight = Color(0xFFFCD88A);
  static const Color _goldDark = Color(0xFF835C21);
  static const Color _bg = Color(0xFFF8FAFC);

  bool get _isArabic => Get.locale?.languageCode == 'ar';

  // ✅ إصلاح #1: اتجاه ديناميكي حسب اللغة
  TextDirection get _textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final d = DateTime.parse(raw);
      return intl.DateFormat('yyyy/MM/dd').format(d);
    } catch (_) {
      return raw;
    }
  }

  String _genderLabel(String? gender) {
    if (gender == 'male') return 'profile_gender_male'.tr;
    if (gender == 'female') return 'profile_gender_female'.tr;
    return '—';
  }

  // ✅ إصلاح #2: اختيار الصورة عبر FilePicker (مو ImagePicker) وعرضها فوراً
  Future<void> _pickAvatar(ProfileController controller) async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) return;
    final file = File(result.files.single.path!);
    controller.pickAndUpdateAvatar(file); // ← فعّلها (بدون setState)
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    // ✅ إصلاح #1: نلف الـ Scaffold بـ Directionality
    return Directionality(
      textDirection: _textDirection,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingProfile.value &&
                      controller.profile.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final profile = controller.profile.value;
                  if (profile == null) {
                    return Center(
                      child: TextButton(
                        onPressed: controller.fetchProfile,
                        child: Text(
                          '${'profile_load_error'.tr} — ${'profile_retry'.tr}',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchProfile,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      children: [
                        _buildIdentityCard(profile, controller),
                        const SizedBox(height: 16),
                        _buildPersonalInfoCard(profile),
                        const SizedBox(height: 16),
                        _buildContactInfoCard(controller),
                        const SizedBox(height: 20),
                        _buildDocumentsButton(),
                      ],
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

  Widget _buildAppBar() {
    return Container(
      height: 64,
      color: _navy,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // ✅ إصلاح #1: ديناميكي حسب اللغة
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
                // ✅ السهم بيشير لليمين بالعربي ولليسار بالإنجليزي
                _isArabic ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            'profile_title'.tr,
            style: GoogleFonts.cairo(
              fontSize: 16, // ✅ إصلاح #5: 13 → 14
              fontWeight: FontWeight.w900,
              color: _goldLight,
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(profile, ProfileController controller) {
    final palette = context.khubrat;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.chipBorder),
        boxShadow: [
          BoxShadow(
            color: palette.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            final url = controller.profile.value?.profileImageUrl;
            final loading = controller.isUpdatingAvatar.value;
            return Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _goldLight.withOpacity(0.7),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    // ✅ إصلاح #2: إظهار الصورة المحلية فوراً إذا تم اختيارها
                    child: controller.localAvatarFile.value != null
                        ? Image.file(
                            controller.localAvatarFile.value!,
                            fit: BoxFit.cover,
                          )
                        : (url == null || url.isEmpty)
                        ? Container(
                            color: palette.inputFill,
                            child: Icon(
                              Icons.person,
                              size: 34,
                              color: palette.textSecondary,
                            ),
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: palette.inputFill,
                              child: Icon(
                                Icons.person,
                                size: 34,
                                color: palette.textSecondary,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  left: -2,
                  child: InkWell(
                    // ✅ إصلاح #2: استخدم الدالة المحلية اللي بتعرض الصورة فوراً
                    onTap: loading ? null : () => _pickAvatar(controller),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _navy,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: loading
                          ? const Padding(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _goldLight,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: _goldLight,
                            ),
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Text(
            profile.fullName,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: palette.title,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            profile.department != null
                ? '${profile.jobTitle ?? ''} (${profile.department!.name})'
                : (profile.jobTitle ?? ''),
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: palette.chipBorder)),
            ),
            child: Column(
              children: [
                Text(
                  'profile_hire_date'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(profile.hireDate),
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(profile) {
    final palette = context.khubrat;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: palette.chipBorder)),
            ),
            child: Text(
              'profile_personal_professional_data'.tr,
              textAlign: TextAlign.start,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: palette.title,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ProfileInfoTile(
            label: 'profile_full_name'.tr,
            value: profile.fullName,
          ),
          const SizedBox(height: 12),
          // ✅ الإيميل: LTR دائماً (نص لاتيني)
          Directionality(
            textDirection: TextDirection.ltr,
            child: ProfileInfoTile(
              label: 'profile_email'.tr,
              value: profile.email,
              valueAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileInfoTile(
                  label: 'profile_date_of_birth'.tr,
                  value: _formatDate(profile.dateOfBirth),
                  valueAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProfileInfoTile(
                  label: 'profile_gender'.tr,
                  value: _genderLabel(profile.gender),
                  valueAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileInfoTile(
                  label: 'profile_nationality'.tr,
                  value: profile.nationality ?? '—',
                  valueAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProfileInfoTile(
                  label: 'profile_department'.tr,
                  value: profile.department?.name ?? '—',
                  valueAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProfileInfoTile(
            label: 'profile_job_title'.tr,
            value: profile.jobTitle ?? '—',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard(ProfileController controller) {
    final palette = context.khubrat;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: palette.chipBorder)),
            ),
            child: Text(
              'profile_contact_data'.tr,
              textAlign: TextAlign.start,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: palette.title,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ✅ إصلاح #3: ValueKey يعتمد على قيمة الهاتف — لما تتغير بعد الحفظ
          // الـ widget بينعاد بناؤه من الصفر ← البوكس بينقفل تلقائياً
          // ✅ الهاتف: LTR دائماً (أرقام)
          Obx(
            () => Directionality(
              textDirection: TextDirection.ltr,
              child: ProfileEditableTile(
                key: ValueKey('phone_${controller.profile.value?.phone ?? ''}'),
                label: 'profile_phone'.tr,
                value: controller.profile.value?.phone ?? '',
                isSaving: controller.isSavingField.value,
                valueAlign: TextAlign.left,
                onSave: controller.updatePhone,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => ProfileEditableTile(
              key: ValueKey(
                'address_${controller.profile.value?.residence ?? ''}',
              ),
              label: 'profile_address'.tr,
              value: controller.profile.value?.residence ?? '',
              isSaving: controller.isSavingField.value,
              onSave: controller.updateResidence,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ إصلاح #4: حماية من null + try-catch
  Widget _buildDocumentsButton() {
    return InkWell(
      onTap: () {
        try {
          Get.toNamed(AppRoutes.profileDocuments);
        } catch (e) {
          Get.snackbar(
            'error'.tr,
            'profile_documents_route_error'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_navy, Color(0xFF001242)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'profile_add_documents_button'.tr,
              style: GoogleFonts.cairo(
                fontSize: 13, // ✅ إصلاح #5: 12 → 13
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
