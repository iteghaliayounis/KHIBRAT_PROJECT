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

      // Accessing fields via model.data
      if (model.data.token.isNotEmpty) {
        await StorageService.instance.saveToken(model.data.token);
      }
      await StorageService.instance.saveUser(model.data.user.toJson());
      await StorageService.instance.saveCompany(model.data.company.toJson());
      await StorageService.instance.setFirstLogin(model.data.user.isFirstLogin);

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
  
}