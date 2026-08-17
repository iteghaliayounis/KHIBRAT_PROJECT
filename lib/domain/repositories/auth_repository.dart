// lib/domain/repositories/auth_repository.dart
import '../../data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> sendResetCode({required String email});

  /// POST /api/auth/resend-otp — resend OTP for the current OTP flow email.
  /// Returns the Backend success `message` when `success` is true.
  Future<String> resendOtp({required String email});

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

  Future<bool> setTwoFactorEnabled({required bool enabled});

  Future<LoginResponseModel> verifyLoginOtp({
    required String email,
    required String otp,
  });
}