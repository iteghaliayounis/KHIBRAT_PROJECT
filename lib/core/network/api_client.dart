import 'api_client_fixed.dart';

/// Compatibility shim: keep same ApiClient API but delegate to ApiClientFixed
class ApiClient {
  ApiClient._();

  static final _delegate = ApiClientFixed.instance;
  static final ApiClient instance = ApiClient._();

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Duration? receiveTimeout,
  }) => _delegate.post(path, data: data, receiveTimeout: receiveTimeout);

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _delegate.get(path, queryParameters: queryParameters);

  Future<Map<String, dynamic>> delete(String path) => _delegate.delete(path);
}
