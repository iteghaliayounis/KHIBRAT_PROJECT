import 'dart:io';
import '../../core/errors/api_exception.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../providers/profile_provider.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileProvider _provider;

  ProfileRepositoryImpl(this._provider);

  @override
  Future<ProfileModel> getProfile() async {
    final body = await _provider.getProfile();
    if (body['success'] == true && body['data'] != null) {
      return ProfileModel.fromJson(body['data'] as Map<String, dynamic>);
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر جلب بيانات الملف الشخصي',
    );
  }

  @override
  Future<ProfileModel> updateProfile({
    String? phone,
    String? residence,
    File? profileImage,
  }) async {
    final body = await _provider.updateProfile(
      phone: phone,
      residence: residence,
      profileImage: profileImage,
    );
    if (body['success'] == true && body['data'] != null) {
      return ProfileModel.fromJson(body['data'] as Map<String, dynamic>);
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر تحديث بيانات الملف الشخصي',
    );
  }

  @override
  Future<Map<String, dynamic>> uploadDocuments({
    required File identityImage,
    File? universityCertificate,
  }) async {
    final body = await _provider.uploadDocuments(
      identityImage: identityImage,
      universityCertificate: universityCertificate,
    );
    if (body['success'] == true && body['data'] != null) {
      return body['data'] as Map<String, dynamic>;
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر رفع الوثائق',
    );
  }
}
