import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/api_exception.dart';
import '../utils/storage_service.dart';

/// Correct, single-definition ApiClient implementation that sends
/// Authorization: Bearer <token> when token exists.
class ApiClientFixed {
  ApiClientFixed._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.instance.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  static final ApiClientFixed instance = ApiClientFixed._internal();
  late final Dio _dio;

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// GET request used by read-only screens (e.g. My Evaluations) that need
  /// to fetch backend-driven data instead of submitting it.
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      // Some backends may return a bare JSON array for list endpoints.
      return {'data': data};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ApiException _mapError(DioException e) {
    // 🔴 1. طباعة التفاصيل كاملة في الـ Console لمعرفة السبب الحقيقي فوراً
    print("--------------------------------------------------");
    print("❌ DIO ERROR TYPE: ${e.type}");
    print("❌ STATUS CODE: ${e.response?.statusCode}");
    print("❌ LARAVEL RESPONSE BODY: ${e.response?.data}");
    print("❌ DIO ERROR MESSAGE: ${e.message}");
    print("--------------------------------------------------");

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return ApiException.network();
    }

    final response = e.response;
    if (response == null) return ApiException.network();

    final data = response.data;
    final serverMessage = _extractServerMessage(data);

    switch (response.statusCode) {
      case 401:
        return ApiException.unauthorized(serverMessage ?? 'unauthorized');
      case 403:
        return ApiException.forbidden(serverMessage ?? 'forbidden');
      case 422:
        final errors = (data is Map && data['errors'] is Map)
            ? Map<String, dynamic>.from(data['errors'])
            : null;
        return ApiException.validation(serverMessage ?? 'validation_error', errors);
      case 429:
        // Rate limit (e.g. resend OTP too soon) — surface Backend message only.
        return ApiException.tooManyRequests(
          serverMessage ?? 'Please wait before requesting another OTP.',
        );
      default:
        return ApiException.generic(serverMessage ?? 'generic_error');
    }
  }

  /// Reads `message` from a JSON map body, or returns a non-empty string body.
  String? _extractServerMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      final msg = data['message'].toString();
      return msg.isEmpty ? null : msg;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }
}
