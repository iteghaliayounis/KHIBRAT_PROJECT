import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileDocumentsUsecase {
  final ProfileRepository repository;
  UploadProfileDocumentsUsecase(this.repository);

  Future<Map<String, dynamic>> call({
    required File identityImage,
    File? universityCertificate,
  }) {
    return repository.uploadDocuments(
      identityImage: identityImage,
      universityCertificate: universityCertificate,
    );
  }
}
