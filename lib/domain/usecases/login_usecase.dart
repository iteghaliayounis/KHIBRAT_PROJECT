import '../../data/models/login_response_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<LoginResponseModel> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}