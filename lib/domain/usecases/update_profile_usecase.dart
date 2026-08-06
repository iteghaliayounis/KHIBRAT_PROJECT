import 'dart:io';
import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;
  UpdateProfileUsecase(this.repository);

  Future<ProfileModel> call({
    String? phone,
    String? residence,
    File? profileImage,
  }) {
    return repository.updateProfile(
      phone: phone,
      residence: residence,
      profileImage: profileImage,
    );
  }
}
