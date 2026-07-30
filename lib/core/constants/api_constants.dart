/// Base API configuration. Update [baseUrl] to point to the real
/// backend environment (staging / production) as needed.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.105:8000'; // TODO: set real base URL

  static const String login = '/api/auth/login';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
