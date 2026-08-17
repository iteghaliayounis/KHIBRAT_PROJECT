import 'package:dio/dio.dart';
import 'package:khibrat_flutter2/core/constants/api_constants.dart';
import 'package:khibrat_flutter2/core/utils/storage_service.dart';
import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/data/models/login_response_model.dart';
import 'package:khibrat_flutter2/data/providers/auth_provider.dart';
import 'package:khibrat_flutter2/core/network/api_client_fixed.dart';
import 'package:khibrat_flutter2/domain/repositories/auth_repository.dart';

class AuthRepositoryFixed implements AuthRepository {
  final AuthProvider _provider = AuthProvider();

  AuthRepositoryFixed();

  @override
  Future<LoginResponseModel> login({required String email, required String password}) async {
    try {
      final resp = await _provider.login(email: email, password: password);
      final model = LoginResponseModel.fromJson(resp);

      if (model.requires2fa) {
        return model;
      }

      await _persistSession(model);
      return model;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null && response.data is Map && response.data['message'] != null) {
        throw ApiException(message: response.data['message'] as String, statusCode: response.statusCode);
      }
      throw ApiException.generic(e.message);
    } catch (e) {
      throw ApiException.generic(e.toString());
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
    try {
      await _provider.completeFirstLogin(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    } on DioException catch (e) {
      final response = e.response;
      if (response != null && response.data is Map && response.data['message'] != null) {
        throw ApiException(message: response.data['message'].toString(), statusCode: response.statusCode);
      }
      throw ApiException.generic(e.message);
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<bool> setTwoFactorEnabled({required bool enabled}) async {
    try {
      final resp = await _provider.setTwoFactor(enabled: enabled);
      if (resp['success'] == false) {
        throw ApiException.generic(
          (resp['message'] ?? 'generic_error').toString(),
        );
      }
      final data = resp['data'];
      final dataMap = data is Map ? Map<String, dynamic>.from(data) : null;
      final value = dataMap == null
          ? enabled
          : dataMap['two_factor_enabled'] == true;
      await StorageService.instance.saveTwoFactorEnabled(value);
      return value;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null &&
          response.data is Map &&
          response.data['message'] != null) {
        throw ApiException(
          message: response.data['message'].toString(),
          statusCode: response.statusCode,
        );
      }
      throw ApiException.generic(e.message);
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<LoginResponseModel> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final resp = await _provider.verifyLoginOtp(email: email, otp: otp);
      final model = LoginResponseModel.fromJson(resp);
      if (model.data == null || model.data!.token.isEmpty) {
        throw ApiException.generic(
          (resp['message'] ?? 'invalid_code').toString(),
        );
      }
      await _persistSession(model);
      // Completing login OTP means 2FA is enabled. Token/user payloads
      // often omit `two_factor_enabled`, which would otherwise store false.
      await StorageService.instance.saveTwoFactorEnabled(true);
      return model;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null &&
          response.data is Map &&
          response.data['message'] != null) {
        throw ApiException(
          message: response.data['message'].toString(),
          statusCode: response.statusCode,
        );
      }
      throw ApiException.generic(e.message);
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<void> _persistSession(LoginResponseModel model) async {
    final data = model.data;
    if (data == null) return;
    if (data.token.isNotEmpty) {
      await StorageService.instance.saveToken(data.token);
    }
    await StorageService.instance.saveUser(data.user.toJson());
    await StorageService.instance.saveCompany(data.company.toJson());
    await StorageService.instance.setFirstLogin(data.user.isFirstLogin);
    if (data.user.twoFactorEnabled) {
      await StorageService.instance.saveTwoFactorEnabled(true);
    }
  }
}