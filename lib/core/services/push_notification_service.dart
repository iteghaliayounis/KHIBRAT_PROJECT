import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';
import '../utils/storage_service.dart';
import '../../data/providers/device_provider.dart';
import '../../firebase_options.dart';

const String _androidChannelId = 'khibrat_default';
const String _androidChannelName = 'Khibrat Notifications';

/// Top-level background handler (must be a top-level or static function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Required when the isolate starts from a killed/background state.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('========== FCM BACKGROUND MESSAGE ==========');
  debugPrint('FCM BACKGROUND messageId: ${message.messageId}');
  debugPrint('FCM BACKGROUND notification: ${message.notification?.title} | ${message.notification?.body}');
  debugPrint('FCM BACKGROUND data: ${message.data}');

  // If Android already shows a system notification (notification payload present),
  // we do not duplicate it. For data-only / stripped payloads, show locally.
  final hasSystemNotification = message.notification != null;
  if (hasSystemNotification) {
    debugPrint('FCM BACKGROUND: system notification present — skip local show');
    return;
  }

  final title = message.data['title']?.toString() ?? 'إشعار جديد';
  final body = message.data['body']?.toString() ?? '';
  if (title.isEmpty && body.isEmpty) {
    debugPrint('FCM BACKGROUND: empty title/body — nothing to show');
    return;
  }

  final local = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await local.initialize(
    settings: const InitializationSettings(android: androidInit),
  );

  final androidPlugin = local.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      _androidChannelId,
      _androidChannelName,
      description: 'General push notifications',
      importance: Importance.high,
    ),
  );

  await local.show(
    id: message.hashCode,
    title: title,
    body: body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannelId,
        _androidChannelName,
        channelDescription: 'General push notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    payload: _encodeNotificationPayload(message.data),
  );
  debugPrint('FCM BACKGROUND: LOCAL NOTIFICATION DISPLAYED');
}

String? _encodeNotificationPayload(Map<String, dynamic> data) {
  final type = data['type']?.toString() ?? '';
  final relatedId = data['related_id']?.toString() ?? '';
  final relatedTable = data['related_table']?.toString() ?? '';
  final reviewId = data['review_id']?.toString() ?? '';

  if (type.isEmpty && relatedId.isEmpty && reviewId.isEmpty) {
    return null;
  }

  return jsonEncode({
    'type': type,
    'related_id': relatedId,
    'related_table': relatedTable,
    'review_id': reviewId,
  });
}

Map<String, dynamic>? _decodeNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) return null;

  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
  } catch (_) {
    // Backward compatible: plain review UUID from older local notifications.
    return {
      'type': 'evaluation_assigned',
      'related_table': 'evaluation_reviews',
      'related_id': payload,
      'review_id': payload,
    };
  }
  return null;
}

String? _extractReviewIdFromMap(Map<String, dynamic> data) {
  final reviewId = data['review_id']?.toString();
  if (reviewId != null && reviewId.isNotEmpty) return reviewId;

  final type = data['type']?.toString();
  final relatedTable = data['related_table']?.toString();
  final relatedId = data['related_id']?.toString();

  if ((type == 'evaluation_assigned' || relatedTable == 'evaluation_reviews') &&
      relatedId != null &&
      relatedId.isNotEmpty) {
    return relatedId;
  }
  return null;
}

/// Push notification orchestration: permissions, token sync, foreground
/// display, and deep-link navigation into evaluation detail.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  static const String _tokenStorageKey = 'fcm_token';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final DeviceProvider _deviceProvider = DeviceProvider();
  final GetStorage _box = GetStorage();

  bool _initialized = false;
  Map<String, dynamic>? _pendingNavData;

  String? get currentToken => _box.read<String>(_tokenStorageKey);

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestPermission();

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // App opened from background via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    // Token refresh
    _messaging.onTokenRefresh.listen((token) async {
      debugPrint('========== FCM TOKEN REFRESH ==========');
      debugPrint('FCM TOKEN: $token');
      await _persistToken(token);
      if (_isLoggedIn) {
        await _registerTokenWithBackend(token);
      }
    });

    debugPrint('PushNotificationService initialized');
  }

  /// Call after successful login (or when restoring an existing session).
  Future<void> syncTokenAfterAuth() async {
    try {
      await _requestPermission();
      final token = await _messaging.getToken();
      debugPrint('========== FCM TOKEN ==========');
      debugPrint('FCM TOKEN: $token');
      if (token == null || token.isEmpty) {
        debugPrint('FCM: no token available yet');
        return;
      }
      await _persistToken(token);
      await _registerTokenWithBackend(token);
    } catch (e, st) {
      debugPrint('FCM syncTokenAfterAuth failed: $e\n$st');
    }
  }

  /// Call on logout — best-effort unregister, never blocks logout.
  Future<void> unregisterBeforeLogout() async {
    final token = currentToken;
    if (token == null || token.isEmpty) return;
    try {
      debugPrint('FCM UNREGISTER: ${token.substring(0, 12)}...');
      await _deviceProvider.unregisterDevice(fcmToken: token);
    } catch (e) {
      debugPrint('FCM unregister failed (ignored): $e');
    }
  }

  /// Consume cold-start / pending notification navigation after reaching home.
  Future<void> consumeInitialMessage() async {
    try {
      final initial = await _messaging.getInitialMessage();
      debugPrint('========== FCM getInitialMessage ==========');
      debugPrint('FCM INITIAL: ${initial?.messageId}');
      debugPrint('FCM INITIAL notification: ${initial?.notification?.title}');
      debugPrint('FCM INITIAL data: ${initial?.data}');
      if (initial != null) {
        _handleNavigationFromData(initial.data);
      }
    } catch (e) {
      debugPrint('FCM getInitialMessage failed: $e');
    }

    if (_pendingNavData != null) {
      final data = _pendingNavData!;
      _pendingNavData = null;
      _navigateFromNotificationData(data);
    }
  }

  /// Store navigation until the user reaches an authenticated screen.
  void queueNotificationNavigation(Map<String, dynamic> data) {
    _pendingNavData = Map<String, dynamic>.from(data);
    debugPrint('FCM queued navigation: $_pendingNavData');
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('========== LOCAL NOTIFICATION TAP ==========');
        debugPrint('payload: ${response.payload}');
        final data = _decodeNotificationPayload(response.payload);
        if (data != null) {
          _handleNavigationFromData(data);
        }
      },
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: 'General push notifications',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('========== FCM FOREGROUND MESSAGE RECEIVED ==========');
    debugPrint('FCM messageId: ${message.messageId}');
    debugPrint('FCM NOTIFICATION: ${message.notification?.title} | ${message.notification?.body}');
    debugPrint('FCM DATA: ${message.data}');

    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString() ?? '';
    final body = notification?.body ?? message.data['body']?.toString() ?? '';
    final payload = _encodeNotificationPayload(message.data);
    debugPrint('FCM LOCAL PAYLOAD: $payload');

    if (title.isEmpty && body.isEmpty) {
      debugPrint('FCM FOREGROUND: empty title/body — skip local notification');
      return;
    }

    await _local.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: 'General push notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
    debugPrint('LOCAL NOTIFICATION DISPLAYED');
  }

  void _onMessageOpened(RemoteMessage message) {
    debugPrint('========== FCM MESSAGE OPENED ==========');
    debugPrint('FCM DATA: ${message.data}');
    _handleNavigationFromData(message.data);
  }

  void _handleNavigationFromData(Map<String, dynamic> data) {
    debugPrint('FCM NAV DATA: $data');

    if (!_isLoggedIn) {
      queueNotificationNavigation(data);
      return;
    }

    _navigateFromNotificationData(data);
  }

  void _navigateFromNotificationData(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final relatedTable = data['related_table']?.toString() ?? '';
    final reviewId = _extractReviewIdFromMap(data);

    if (type == 'evaluation_assigned' ||
        relatedTable == 'evaluation_reviews' ||
        (reviewId != null && reviewId.isNotEmpty && type.isEmpty)) {
      if (reviewId == null || reviewId.isEmpty) return;
      _navigateToEvaluation(reviewId);
      return;
    }

    if (type.startsWith('leave_') || relatedTable == 'leave_requests') {
      debugPrint('NAVIGATING TO LEAVES');
      Get.toNamed(AppRoutes.leaveDashboard);
      return;
    }

    if (type.startsWith('overtime_') || relatedTable == 'overtime_requests') {
      debugPrint('NAVIGATING TO OVERTIME');
      Get.toNamed(AppRoutes.overTime);
      return;
    }

    if (type.startsWith('advance_') || relatedTable == 'salary_advances') {
      debugPrint('NAVIGATING TO SALARY / ADVANCES');
      Get.toNamed(AppRoutes.salaryDashboard);
      return;
    }

    debugPrint('FCM: unknown notification type — no navigation');
  }

  void _navigateToEvaluation(String reviewId) {
    if (reviewId.isEmpty) return;
    debugPrint('NAVIGATING TO EVALUATION: $reviewId');

    // Avoid stacking duplicate detail screens for the same review.
    if (Get.currentRoute == AppRoutes.evaluationDetail) {
      Get.offNamed(
        AppRoutes.evaluationDetail,
        arguments: {'reviewId': reviewId},
      );
      return;
    }

    Get.toNamed(
      AppRoutes.evaluationDetail,
      arguments: {'reviewId': reviewId},
    );
  }

  Future<void> _persistToken(String token) async {
    await _box.write(_tokenStorageKey, token);
  }

  Future<void> _registerTokenWithBackend(String token) async {
    final platform = kIsWeb
        ? 'web'
        : Platform.isIOS
            ? 'ios'
            : 'android';

    debugPrint('FCM REGISTERING with backend...');
    await _deviceProvider.registerDevice(
      fcmToken: token,
      platform: platform,
      deviceName: Platform.operatingSystem,
    );
    debugPrint(
      'FCM token registered with backend (${token.substring(0, 12)}...)',
    );
  }

  bool get _isLoggedIn {
    final token = StorageService.instance.token;
    return token != null && token.isNotEmpty;
  }
}
