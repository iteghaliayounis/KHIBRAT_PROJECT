import '../../core/constants/api_constants.dart';
import '../../core/network/api_client_fixed.dart';

/// Talks directly to the `/api/auth/*` endpoints. Kept dumb on purpose:
/// no business logic here, only raw HTTP calls (Single Responsibility).
class AuthProvider {
  final ApiClientFixed _client = ApiClientFixed.instance;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _client.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
Future<Map<String, dynamic>> completeFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) {
    return _client.post(
      '/api/auth/complete-first-login',
      data: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  
}
