import 'package:dio/dio.dart';
import 'package:khibrat_flutter2/core/constants/api_constants.dart';
import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/core/utils/storage_service.dart';
import 'package:khibrat_flutter2/data/models/login_response_model.dart';
import 'package:khibrat_flutter2/data/providers/auth_provider.dart';
import 'package:khibrat_flutter2/core/network/api_client_fixed.dart';
import 'package:khibrat_flutter2/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthProvider _provider = AuthProvider();

  AuthRepositoryImpl();

  @override
  Future<LoginResponseModel> login({required String email, required String password}) async {
    try {
      final resp = await _provider.login(email: email, password: password);
      final model = LoginResponseModel.fromJson(resp);

      if (model.requires2fa) {
        return model;
      }

      if (model.data != null && model.data!.token.isNotEmpty) {
        await StorageService.instance.saveToken(model.data!.token);
      }
      if (model.data != null) {
        await StorageService.instance.saveUser(model.data!.user.toJson());
        await StorageService.instance.saveCompany(model.data!.company.toJson());
        await StorageService.instance.setFirstLogin(model.data!.user.isFirstLogin);
        await StorageService.instance
            .saveTwoFactorEnabled(model.data!.user.twoFactorEnabled);
      }

      return model;
  } on DioException catch (e) {
  final response = e.response;
  
  // 👈 أضيفي هذه السطور لطباعة استجابة السيرفر في الكونسول
  print("❌ STATUS CODE: ${response?.statusCode}");
  print("❌ SERVER RESPONSE BODY: ${response?.data}");

  if (response != null && response.data is Map && response.data['message'] != null) {
    final msg = response.data['message'];
    if (msg is String) {
      throw ApiException(message: msg, statusCode: response.statusCode);
    } else {
      throw ApiException(message: msg.toString(), statusCode: response.statusCode);
    }
  }
  throw ApiException.generic(e.message);
}
  }

  @override
  Future<void> sendResetCode({required String email}) async {
    try {
      await ApiClientFixed.instance.post('/api/auth/forgot-password', data: {'email': email});
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<String> resendOtp({required String email}) async {
    try {
      final resp = await ApiClientFixed.instance.post(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
      if (resp['success'] == false) {
        throw ApiException.generic(
          (resp['message'] ?? 'failed_resend_code').toString(),
        );
      }
      return (resp['message'] ?? 'OTP resent successfully.').toString();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<void> verifyResetCode({required String email, required String code}) async {
    try {
      await ApiClientFixed.instance.post('/api/auth/verify-otp', data: {'email': email, 'otp': code});
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword, required String passwordConfirmation}) async {
    try {
      await ApiClientFixed.instance.post('/api/auth/reset-password', data: {
        'email': email,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      });
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<void> completeFirstLogin({required String password, required String passwordConfirmation}) async {
    return;
  }

  @override
  Future<bool> setTwoFactorEnabled({required bool enabled}) async => enabled;

  @override
  Future<LoginResponseModel> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    throw UnimplementedError();
  }
}