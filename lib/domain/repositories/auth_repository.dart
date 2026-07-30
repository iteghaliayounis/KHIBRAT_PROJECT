// lib/domain/repositories/auth_repository.dart
import '../../data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> sendResetCode({required String email});

  Future<void> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String passwordConfirmation,
  });

  Future<void> completeFirstLogin({
    required String password,
    required String passwordConfirmation,
  });
}