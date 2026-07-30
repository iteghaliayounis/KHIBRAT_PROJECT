import '../repositories/auth_repository.dart'; // عدلي المسار بحسب مجلد الـ Domain لديكِ

class SendResetCodeUseCase {
  final AuthRepository _repository;

  SendResetCodeUseCase(this._repository);

  Future<void> call({required String email}) async {
    return await _repository.sendResetCode(email: email);
  }
}