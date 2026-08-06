import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;
  GetProfileUsecase(this.repository);

  Future<ProfileModel> call() => repository.getProfile();
}
