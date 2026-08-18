import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/api_exception.dart';
import '../../core/utils/storage_service.dart';
import '../../data/models/assistant_models.dart';
import '../../data/repositories/assistant_repository.dart';
import '../widgets/app_feedback.dart';
import 'home_controller.dart';

class AssistantController extends GetxController {
  final AssistantRepository _repository;

  AssistantController({AssistantRepository? repository})
      : _repository = repository ?? AssistantRepository();

  final TextEditingController inputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();
  final ScrollController sessionsScrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();

  final RxBool isDrawerOpen = false.obs;
  final RxBool isLoadingSessions = false.obs;
  final RxBool isLoadingMoreSessions = false.obs;
  final RxBool isLoadingSession = false.obs;
  final RxBool isCreatingSession = false.obs;
  final RxBool isSending = false.obs;
  final RxnString errorMessage = RxnString();

  final RxList<AssistantSessionModel> sessions = <AssistantSessionModel>[].obs;
  final Rxn<AssistantSessionModel> currentSession = Rxn<AssistantSessionModel>();
  final RxList<AssistantMessageModel> messages = <AssistantMessageModel>[].obs;
  final RxList<String> removingSessionIds = <String>[].obs;

  int _sessionsPage = 1;
  int _sessionsLastPage = 1;

  /// Welcome layout (orb) is shown when there is no user message yet.
  bool get showWelcome {
    return !messages.any((m) => m.isUser);
  }

  bool get isThinking => isSending.value || isCreatingSession.value;

  String get employeeName {
    if (Get.isRegistered<HomeController>()) {
      final name = Get.find<HomeController>().fullName.trim();
      if (name.isNotEmpty) return name;
    }
    final user = StorageService.instance.user;
    final fromStorage = (user?['full_name'] ?? user?['name'])?.toString().trim();
    if (fromStorage != null && fromStorage.isNotEmpty) return fromStorage;
    return '';
  }

  String get greetingName {
    AssistantMessageModel? welcome;
    for (final m in messages) {
      if (m.isAssistant) {
        welcome = m;
        break;
      }
    }
    if (welcome != null) {
      final parsed = _nameFromWelcome(welcome.message);
      if (parsed != null) return parsed;
    }
    return employeeName;
  }

  @override
  void onInit() {
    super.onInit();
    sessionsScrollController.addListener(_onSessionsScroll);
    loadSessions();
  }

  @override
  void onClose() {
    inputController.dispose();
    chatScrollController.dispose();
    sessionsScrollController.dispose();
    inputFocusNode.dispose();
    super.onClose();
  }

  void openDrawer() {
    isDrawerOpen.value = true;
    if (sessions.isEmpty && !isLoadingSessions.value) {
      loadSessions();
    }
  }

  void closeDrawer() => isDrawerOpen.value = false;

  Future<void> loadSessions({bool refresh = true}) async {
    if (refresh) {
      isLoadingSessions.value = true;
      errorMessage.value = null;
      _sessionsPage = 1;
    } else {
      if (isLoadingMoreSessions.value || _sessionsPage >= _sessionsLastPage) {
        return;
      }
      isLoadingMoreSessions.value = true;
    }

    try {
      final page = await _repository.listSessions(page: _sessionsPage);
      _sessionsLastPage = page.lastPage;
      if (refresh) {
        sessions.assignAll(page.sessions);
      } else {
        final existing = sessions.map((s) => s.id).toSet();
        sessions.addAll(page.sessions.where((s) => !existing.contains(s.id)));
      }
    } on ApiException catch (e) {
      if (refresh) errorMessage.value = e.message;
      AppFeedback.showError(e.message);
    } catch (e) {
      if (refresh) errorMessage.value = 'generic_error';
      AppFeedback.showError('generic_error');
    } finally {
      isLoadingSessions.value = false;
      isLoadingMoreSessions.value = false;
    }
  }

  Future<void> createNewSession() async {
    if (isCreatingSession.value || isSending.value) return;
    isCreatingSession.value = true;
    try {
      final session = await _repository.createSession();
      currentSession.value = session;
      messages.assignAll(_sorted(session.messages));
      _upsertSession(session);
      closeDrawer();
      _scrollChatToEnd();
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error');
    } finally {
      isCreatingSession.value = false;
    }
  }

  Future<void> openSession(String sessionId) async {
    if (isLoadingSession.value || isSending.value) return;
    isLoadingSession.value = true;
    closeDrawer();
    try {
      final session = await _repository.getSession(sessionId);
      currentSession.value = session;
      messages.assignAll(_sorted(session.messages));
      _upsertSession(session);
      _scrollChatToEnd();
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error');
    } finally {
      isLoadingSession.value = false;
    }
  }

  Future<void> sendMessage([String? preset]) async {
    final text = (preset ?? inputController.text).trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;
    inputController.clear();
    inputFocusNode.unfocus();

    final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    var optimisticAdded = false;

    try {
      if (currentSession.value == null) {
        isCreatingSession.value = true;
        final created = await _repository.createSession();
        currentSession.value = created;
        messages.assignAll(_sorted(created.messages));
        _upsertSession(created);
        isCreatingSession.value = false;
      }

      final sessionId = currentSession.value!.id;
      messages.add(
        AssistantMessageModel(
          id: tempId,
          role: 'user',
          message: text,
          createdAt: DateTime.now(),
        ),
      );
      optimisticAdded = true;
      _scrollChatToEnd();

      final result = await _repository.sendMessage(
        sessionId: sessionId,
        message: text,
      );

      final tempIndex = messages.indexWhere((m) => m.id == tempId);
      if (tempIndex >= 0) {
        messages[tempIndex] = result.userMessage;
      }

      final alreadyHasAssistant =
          messages.any((m) => m.id == result.assistantMessage.id);
      if (!alreadyHasAssistant) {
        messages.add(result.assistantMessage);
      }

      await _refreshSessionTitle(sessionId);
      _scrollChatToEnd();
    } on ApiException catch (e) {
      if (optimisticAdded) {
        messages.removeWhere((m) => m.id == tempId);
      }
      inputController.text = text;
      inputController.selection = TextSelection.collapsed(offset: text.length);
      AppFeedback.showError(e.message);
    } catch (_) {
      if (optimisticAdded) {
        messages.removeWhere((m) => m.id == tempId);
      }
      inputController.text = text;
      AppFeedback.showError('generic_error');
    } finally {
      isCreatingSession.value = false;
      isSending.value = false;
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _repository.deleteSession(sessionId);
      removingSessionIds.add(sessionId);
      await Future<void>.delayed(const Duration(milliseconds: 420));
      sessions.removeWhere((s) => s.id == sessionId);
      removingSessionIds.remove(sessionId);

      if (currentSession.value?.id == sessionId) {
        currentSession.value = null;
        messages.clear();
      }
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error');
    }
  }

  void sendSuggestion(String text) => sendMessage(text);

  bool isSessionRemoving(String id) => removingSessionIds.contains(id);

  void _onSessionsScroll() {
    if (!sessionsScrollController.hasClients) return;
    final pos = sessionsScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 80) {
      if (!isLoadingMoreSessions.value && _sessionsPage < _sessionsLastPage) {
        _sessionsPage += 1;
        loadSessions(refresh: false);
      }
    }
  }

  void _upsertSession(AssistantSessionModel session) {
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session.copyWith(
        title: session.title ?? sessions[index].title,
        updatedAt: session.updatedAt ?? sessions[index].updatedAt,
      );
    } else {
      sessions.insert(0, session);
    }
  }

  Future<void> _refreshSessionTitle(String sessionId) async {
    try {
      final page = await _repository.listSessions(page: 1);
      _sessionsLastPage = page.lastPage;
      final existingLater = sessions
          .where((s) => page.sessions.every((fresh) => fresh.id != s.id))
          .toList();
      sessions.assignAll([...page.sessions, ...existingLater]);
      final match = sessions.firstWhereOrNull((s) => s.id == sessionId);
      if (match != null && currentSession.value?.id == sessionId) {
        currentSession.value = currentSession.value!.copyWith(
          title: match.title,
          updatedAt: match.updatedAt,
        );
      }
    } catch (_) {
      // Title refresh is best-effort; the chat itself already succeeded.
    }
  }

  void _scrollChatToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!chatScrollController.hasClients) return;
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<AssistantMessageModel> _sorted(List<AssistantMessageModel> list) {
    final copy = [...list];
    copy.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return aTime.compareTo(bTime);
    });
    return copy;
  }

  String? _nameFromWelcome(String message) {
    final firstLine = message.split('\n').first.trim();
    final match = RegExp(r'أهلاً بك[،,]?\s*(.+?)(?:\s*👋)?$').firstMatch(firstLine);
    if (match != null) {
      final name = match.group(1)?.replaceAll('👋', '').trim();
      if (name != null && name.isNotEmpty) return name;
    }
    final en = RegExp(
      r'welcome[,:]?\s*(.+?)(?:\s*👋)?$',
      caseSensitive: false,
    ).firstMatch(firstLine);
    if (en != null) {
      final name = en.group(1)?.replaceAll('👋', '').trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return null;
  }
}
