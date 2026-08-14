import 'package:khibrat_flutter2/core/constants/api_constants.dart';
import 'package:khibrat_flutter2/core/network/api_client.dart';

class AssistantProvider {
  final ApiClient _client = ApiClient.instance;

  Future<Map<String, dynamic>> createSession() {
    return _client.post(ApiConstants.assistantSessions);
  }

  Future<Map<String, dynamic>> listSessions({int page = 1}) {
    return _client.get(
      ApiConstants.assistantSessions,
      queryParameters: {'page': page},
    );
  }

  Future<Map<String, dynamic>> getSession(String sessionId) {
    return _client.get(ApiConstants.assistantSession(sessionId));
  }

  Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String message,
  }) {
    return _client.post(
      ApiConstants.assistantSessionMessages(sessionId),
      data: {'message': message},
      receiveTimeout: ApiConstants.assistantReceiveTimeout,
    );
  }

  Future<Map<String, dynamic>> deleteSession(String sessionId) {
    return _client.delete(ApiConstants.assistantSession(sessionId));
  }
}
