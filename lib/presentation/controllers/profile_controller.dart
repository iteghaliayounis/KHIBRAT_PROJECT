import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/profile_model.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_documents_usecase.dart';

class ProfileController extends GetxController {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final UploadProfileDocumentsUsecase uploadDocumentsUsecase;

  ProfileController({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    required this.uploadDocumentsUsecase,
  });

  // ---------------- بيانات الملف الشخصي ----------------
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoadingProfile = false.obs;

  // ---------------- تعديل الصورة ----------------
  final RxBool isUpdatingAvatar = false.obs;

  /// ⬅️ إصلاح #2: الصورة المحلية المختارة، تُخزَّن على القرص وتُقرأ
  /// تلقائياً بعد إعادة فتح التطبيق (GetStorage) — ما بتروح إلا لما
  /// يختار المستخدم صورة جديدة.
  final Rx<File?> localAvatarFile = Rx<File?>(null);
  final _storage = GetStorage();
  static const _avatarCacheKey = 'cached_avatar_path';

  // ---------------- تعديل الهاتف / العنوان (Bottom Sheet) ----------------
  final RxBool isSavingField = false.obs;

  // ---------------- شاشة رفع الوثائق ----------------
  final Rx<File?> identityFile = Rx<File?>(null);
  final Rx<File?> certificateFile = Rx<File?>(null);
  final RxBool isUploadingDocuments = false.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreCachedAvatar();
    fetchProfile();
  }

  /// ⬅️ إصلاح #2: يقرأ آخر صورة محفوظة على القرص (إن وجدت) ويعرضها
  /// فوراً قبل ما يوصل رد السيرفر — هيك ما بتختفي الصورة بعد إغلاق
  /// التطبيق وإعادة فتحه.
  void _restoreCachedAvatar() {
    try {
      final cachedPath = _storage.read<String>(_avatarCacheKey);
      if (cachedPath != null && File(cachedPath).existsSync()) {
        localAvatarFile.value = File(cachedPath);
      }
    } catch (_) {
      // تجاهل أي خطأ قراءة كاش، مو مصيري
    }
  }

  // ---------------- GET /api/profile ----------------
  Future<void> fetchProfile() async {
    try {
      isLoadingProfile.value = true;
      profile.value = await getProfileUsecase.call();
    } on ApiException catch (e) {
      Get.snackbar('error'.tr, e.message);
    } catch (_) {
      Get.snackbar('error'.tr, 'profile_load_error'.tr);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ---------------- تعديل الصورة الشخصية ----------------
  /// ⬅️ إصلاح #2: يقبل ملف جاهز (لو الشاشة اختارتو بنفسها عبر
  /// FilePicker)، أو يفتح المعرض بنفسه إذا ما انبعتلوش شي.
  /// الصورة بتنعرض وبتتخزن على القرص فوراً (قبل حتى ما يرد السيرفر)،
  /// وبتضل معروضة حتى بعد إعادة فتح التطبيق.
  Future<void> pickAndUpdateAvatar([File? providedFile]) async {
    File? file = providedFile;
    if (file == null) {
      final result = await FilePicker.pickFiles(type: FileType.image);
      if (result == null || result.files.single.path == null) return;
      file = File(result.files.single.path!);
    }

    localAvatarFile.value = file;
    try {
      await _storage.write(_avatarCacheKey, file.path);
    } catch (_) {}

    try {
      isUpdatingAvatar.value = true;
      final updated = await updateProfileUsecase.call(profileImage: file);
      profile.value = updated;
      Get.snackbar('success'.tr, 'profile_avatar_update_success'.tr);
    } on ApiException catch (e) {
      Get.snackbar('error'.tr, e.message);
    } catch (_) {
      Get.snackbar('error'.tr, 'profile_avatar_update_error'.tr);
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

  // ---------------- تعديل رقم الهاتف / العنوان ----------------
  Future<bool> updatePhone(String newPhone) => _updateField(phone: newPhone);

  Future<bool> updateResidence(String newResidence) =>
      _updateField(residence: newResidence);

  Future<bool> _updateField({String? phone, String? residence}) async {
    try {
      isSavingField.value = true;
      final updated = await updateProfileUsecase.call(
        phone: phone,
        residence: residence,
      );
      profile.value = updated;
      Get.snackbar('success'.tr, 'profile_update_success'.tr);
      return true;
    } on ApiException catch (e) {
      Get.snackbar('error'.tr, e.message);
      return false;
    } catch (_) {
      Get.snackbar('error'.tr, 'profile_update_error'.tr);
      return false;
    } finally {
      isSavingField.value = false;
    }
  }

  // ---------------- شاشة رفع الوثائق ----------------
  Future<void> pickIdentityFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      identityFile.value = File(result.files.single.path!);
    }
  }

  Future<void> pickCertificateFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      certificateFile.value = File(result.files.single.path!);
    }
  }

  Future<void> submitDocuments() async {
    if (identityFile.value == null) {
      Get.snackbar(
        'error'.tr,
        'profile_identity_required'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isUploadingDocuments.value = true;
      final data = await uploadDocumentsUsecase.call(
        identityImage: identityFile.value!,
        universityCertificate: certificateFile.value,
      );
      final completed = data['profile_completed'] == true;
      if (profile.value != null) {
        profile.value = profile.value!.copyWith(profileCompleted: completed);
      }
      Get.snackbar(
        'success'.tr,
        'profile_documents_upload_success'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      identityFile.value = null;
      certificateFile.value = null;
      await Future.delayed(const Duration(milliseconds: 600));
      Get.back(); // رجوع لشاشة الملف الشخصي
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (_) {
      Get.snackbar(
        'error'.tr,
        'profile_documents_upload_error'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUploadingDocuments.value = false;
    }
  }
}
