import '../repositories/auth_repository.dart';

class CompleteFirstLoginUseCase {
  final AuthRepository _repository;

  CompleteFirstLoginUseCase(this._repository);

  Future<void> call({
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.completeFirstLogin(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
