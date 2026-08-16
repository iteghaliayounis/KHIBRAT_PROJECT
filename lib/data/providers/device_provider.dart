import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

/// Registers / unregisters FCM device tokens with the Laravel backend.
class DeviceProvider {
  DeviceProvider({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient.instance;

  final ApiClient _api;

  Future<void> registerDevice({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await _api.post(
      ApiConstants.devices,
      data: {
        'fcm_token': fcmToken,
        'platform': platform,
        if (deviceName != null && deviceName.isNotEmpty) 'device_name': deviceName,
      },
    );
  }

  Future<void> unregisterDevice({required String fcmToken}) async {
    await _api.post(
      ApiConstants.devicesUnregister,
      data: {'fcm_token': fcmToken},
    );
  }
}
