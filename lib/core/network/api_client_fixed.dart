import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
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
          final locale = _apiLocale();
          options.headers['X-Locale'] = locale;
          options.headers['Accept-Language'] = locale;
          handler.next(options);
        },
      ),
    );
  }

  static final ApiClientFixed instance = ApiClientFixed._internal();
  late final Dio _dio;

  /// Laravel SetLocale reads X-Locale then Accept-Language (`ar` / `en`).
  static String _apiLocale() {
    final stored = StorageService.instance.language;
    final raw = (stored != null && stored.isNotEmpty)
        ? stored
        : (Get.locale?.languageCode ?? 'ar');
    final code = raw.split(RegExp('[-_]')).first.toLowerCase();
    return code == 'en' ? 'en' : 'ar';
  }

  /// GET request (leaves, evaluations, …).
  /// Accepts either [query] or [queryParameters] for compatibility.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final params = queryParameters ?? query;
      final response = await _dio.get(path, queryParameters: params);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return {'data': data};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Duration? receiveTimeout,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: receiveTimeout != null
            ? Options(receiveTimeout: receiveTimeout)
            : null,
      );
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      return {'data': body};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      final body = response.data;
      if (body == null || body == '') return {'success': true};
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      return {'success': true, 'data': body};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Multipart POST (e.g. leave apply with attachment file).
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required FormData formData,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return {'data': data};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// PUT request (JSON body, no files) — e.g. simple profile field
  /// updates when no image is being sent.
  ///
  /// ⬅️ مُضاف جديد من أجل شاشة الملف الشخصي (PUT /api/profile).
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      return {'data': body};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Multipart PUT (e.g. profile update with an optional image file).
  ///
  /// ⬅️ مُضاف جديد من أجل شاشة الملف الشخصي (PUT /api/profile يقبل
  /// multipart/form-data لأنه بيرسل profile_image كملف).
  Future<Map<String, dynamic>> putMultipart(
    String path, {
    required FormData formData,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return {'data': data};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ApiException _mapError(DioException e) {
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
        return ApiException.validation(
          serverMessage ?? 'validation_error',
          errors,
        );
      case 429:
        return ApiException.tooManyRequests(
          serverMessage ?? 'Please wait before requesting another OTP.',
        );
      default:
        return ApiException.generic(serverMessage ?? 'generic_error');
    }
  }

  String? _extractServerMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      final msg = data['message'].toString();
      return msg.isEmpty ? null : msg;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }
}
