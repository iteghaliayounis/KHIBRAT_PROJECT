import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/data/models/assistant_models.dart';
import 'package:khibrat_flutter2/data/providers/assistant_provider.dart';

class AssistantRepository {
  final AssistantProvider _provider;

  AssistantRepository({AssistantProvider? provider})
      : _provider = provider ?? AssistantProvider();

  Future<AssistantSessionModel> createSession() async {
    try {
      final resp = await _provider.createSession();
      return AssistantSessionModel.fromJson(_requireDataMap(resp));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<AssistantSessionPage> listSessions({int page = 1}) async {
    try {
      final resp = await _provider.listSessions(page: page);
      _ensureSuccess(resp);
      return AssistantSessionPage.fromJson(resp);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<AssistantSessionModel> getSession(String sessionId) async {
    try {
      final resp = await _provider.getSession(sessionId);
      return AssistantSessionModel.fromJson(_requireDataMap(resp));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<AssistantSendResult> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final resp = await _provider.sendMessage(
        sessionId: sessionId,
        message: message,
      );
      _ensureSuccess(resp);
      return AssistantSendResult.fromJson(resp);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      final resp = await _provider.deleteSession(sessionId);
      if (resp['success'] == false) {
        throw ApiException(
          message: resp['message']?.toString() ?? 'generic_error',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  void _ensureSuccess(Map<String, dynamic> resp) {
    if (resp['success'] == false) {
      throw ApiException(
        message: resp['message']?.toString() ?? 'generic_error',
      );
    }
  }

  Map<String, dynamic> _requireDataMap(Map<String, dynamic> resp) {
    _ensureSuccess(resp);
    final data = resp['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw ApiException(message: 'generic_error');
  }
}
