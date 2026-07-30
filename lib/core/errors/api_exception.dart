/// Unified exception type thrown by the data layer and caught by
/// controllers to show a friendly, translated message to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException({required this.message, this.statusCode, this.errors});

  factory ApiException.network() => ApiException(message: 'network_error');

  factory ApiException.unauthorized([String? message]) =>
      ApiException(message: message ?? 'invalid_credentials', statusCode: 401);

  factory ApiException.forbidden([String? message]) =>
      ApiException(message: message ?? 'account_inactive', statusCode: 403);

  factory ApiException.validation(String message, [Map<String, dynamic>? errors]) =>
      ApiException(message: message, statusCode: 422, errors: errors);

  factory ApiException.generic([String? message]) =>
      ApiException(message: message ?? 'generic_error');

  @override
  String toString() => message;
}
