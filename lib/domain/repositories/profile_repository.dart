import 'dart:io';
import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile({
    String? phone,
    String? residence,
    File? profileImage,
  });

  /// بيرجع true/false + رابط الوثائق (مو ضروري نحول الرد لموديل كامل،
  /// بترجعلنا Map فيها profile_completed و documents)
  Future<Map<String, dynamic>> uploadDocuments({
    required File identityImage,
    File? universityCertificate,
  });
}
