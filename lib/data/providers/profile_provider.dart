import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client_fixed.dart';

/// ⚠️ يستخدم ApiClientFixed.instance مباشرة (مو الـ shim ApiClient)
/// لأنو الـ shim الحالي ما بيعرض postMultipart/put/putMultipart.
/// و PUT /api/profile محتاج multipart (بسبب صورة الملف الشخصي)، فأضفت
/// تابعين جداد بـ ApiClientFixed: put() و putMultipart() — راجع
/// EDITS_TO_EXISTING_FILES.md لتفاصيل هالإضافة بالضبط.
class ProfileProvider {
  final ApiClientFixed _client = ApiClientFixed.instance;

  /// GET /api/profile
  Future<Map<String, dynamic>> getProfile() {
    return _client.get(ApiConstants.profilePreview);
  }

  /// PUT /api/profile  (multipart/form-data)
  /// بيحدث فقط phone / residence / profile_image (أي حقل null ما بينبعت)
  Future<Map<String, dynamic>> updateProfile({
    String? phone,
    String? residence,
    File? profileImage,
  }) async {
    final map = <String, dynamic>{};
    if (phone != null) map['phone'] = phone;
    if (residence != null) map['residence'] = residence;
    if (profileImage != null) {
      map['profile_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split(Platform.pathSeparator).last,
      );
    }

    final formData = FormData.fromMap(map);
    return _client.putMultipart(ApiConstants.profileUpdate, formData: formData);
  }

  /// POST /api/profile/documents  (multipart/form-data)
  /// identity_image إجباري، university_certificate اختياري
  Future<Map<String, dynamic>> uploadDocuments({
    required File identityImage,
    File? universityCertificate,
  }) async {
    final map = <String, dynamic>{
      'identity_image': await MultipartFile.fromFile(
        identityImage.path,
        filename: identityImage.path.split(Platform.pathSeparator).last,
      ),
    };
    if (universityCertificate != null) {
      map['university_certificate'] = await MultipartFile.fromFile(
        universityCertificate.path,
        filename: universityCertificate.path.split(Platform.pathSeparator).last,
      );
    }

    final formData = FormData.fromMap(map);
    return _client.postMultipart(
      ApiConstants.profileDocuments,
      formData: formData,
    );
  }
}
