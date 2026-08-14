class AssistantMessageModel {
  final String id;
  final String role;
  final String message;
  final DateTime? createdAt;

  const AssistantMessageModel({
    required this.id,
    required this.role,
    required this.message,
    this.createdAt,
  });

  bool get isUser => role.toLowerCase() == 'user';
  bool get isAssistant => role.toLowerCase() == 'assistant';

  factory AssistantMessageModel.fromJson(Map<String, dynamic> json) {
    return AssistantMessageModel(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']),
    );
  }

  AssistantMessageModel copyWith({
    String? id,
    String? role,
    String? message,
    DateTime? createdAt,
  }) {
    return AssistantMessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AssistantSessionModel {
  final String id;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AssistantMessageModel> messages;
  final int messagesTotal;
  final int messagesLastPage;

  const AssistantSessionModel({
    required this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.messages = const [],
    this.messagesTotal = 0,
    this.messagesLastPage = 1,
  });

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    for (final m in messages) {
      if (m.isUser && m.message.trim().isNotEmpty) {
        return m.message.trim();
      }
    }
    return '';
  }

  AssistantSessionModel copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AssistantMessageModel>? messages,
    int? messagesTotal,
    int? messagesLastPage,
  }) {
    return AssistantSessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      messagesTotal: messagesTotal ?? this.messagesTotal,
      messagesLastPage: messagesLastPage ?? this.messagesLastPage,
    );
  }

  factory AssistantSessionModel.fromJson(Map<String, dynamic> json) {
    final parsed = _parseMessages(json['messages']);
    return AssistantSessionModel(
      id: json['id']?.toString() ?? '',
      title: _nullableTitle(json['title']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      messages: parsed.messages,
      messagesTotal: parsed.total,
      messagesLastPage: parsed.lastPage,
    );
  }
}

class AssistantSessionPage {
  final List<AssistantSessionModel> sessions;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const AssistantSessionPage({
    required this.sessions,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory AssistantSessionPage.fromJson(Map<String, dynamic> json) {
    final root = json['data'];
    if (root is List) {
      return AssistantSessionPage(
        sessions: root
            .whereType<Map>()
            .map(
              (e) => AssistantSessionModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList(),
        currentPage: 1,
        lastPage: 1,
        total: root.length,
        perPage: root.length,
      );
    }

    final data = root is Map ? Map<String, dynamic>.from(root) : json;
    final inner = data['data'];
    final sessions = <AssistantSessionModel>[];
    if (inner is List) {
      for (final item in inner) {
        if (item is Map) {
          sessions.add(
            AssistantSessionModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return AssistantSessionPage(
      sessions: sessions,
      currentPage: _asInt(data['current_page'], 1),
      lastPage: _asInt(data['last_page'], 1),
      total: _asInt(data['total'], sessions.length),
      perPage: _asInt(data['per_page'], 15),
    );
  }
}

class AssistantSendResult {
  final String answer;
  final String sessionId;
  final AssistantMessageModel userMessage;
  final AssistantMessageModel assistantMessage;

  const AssistantSendResult({
    required this.answer,
    required this.sessionId,
    required this.userMessage,
    required this.assistantMessage,
  });

  factory AssistantSendResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final userRaw = data['user_message'];
    final assistantRaw = data['assistant_message'];
    final answer = data['answer']?.toString() ?? '';

    final userMessage = userRaw is Map
        ? AssistantMessageModel.fromJson(Map<String, dynamic>.from(userRaw))
        : AssistantMessageModel(
            id: 'user-${DateTime.now().millisecondsSinceEpoch}',
            role: 'user',
            message: '',
            createdAt: DateTime.now(),
          );

    final assistantMessage = assistantRaw is Map
        ? AssistantMessageModel.fromJson(
            Map<String, dynamic>.from(assistantRaw),
          )
        : AssistantMessageModel(
            id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
            role: 'assistant',
            message: answer,
            createdAt: DateTime.now(),
          );

    return AssistantSendResult(
      answer: answer.isNotEmpty ? answer : assistantMessage.message,
      sessionId: data['session_id']?.toString() ?? '',
      userMessage: userMessage,
      assistantMessage: assistantMessage,
    );
  }
}

class _ParsedMessages {
  final List<AssistantMessageModel> messages;
  final int total;
  final int lastPage;

  const _ParsedMessages({
    required this.messages,
    required this.total,
    required this.lastPage,
  });
}

_ParsedMessages _parseMessages(dynamic raw) {
  if (raw is List) {
    final list = raw
        .whereType<Map>()
        .map((e) => AssistantMessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return _ParsedMessages(
      messages: list,
      total: list.length,
      lastPage: 1,
    );
  }

  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    final inner = map['data'];
    final list = <AssistantMessageModel>[];
    if (inner is List) {
      for (final item in inner) {
        if (item is Map) {
          list.add(
            AssistantMessageModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return _ParsedMessages(
      messages: list,
      total: _asInt(map['total'], list.length),
      lastPage: _asInt(map['last_page'], 1),
    );
  }

  return const _ParsedMessages(messages: [], total: 0, lastPage: 1);
}

String? _nullableTitle(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

int _asInt(dynamic value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
