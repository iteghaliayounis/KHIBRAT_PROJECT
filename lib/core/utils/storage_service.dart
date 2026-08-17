import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final GetStorage _box = GetStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyLanguage = 'app_language';
  static const String _keyUser = 'auth_user';
  static const String _keyCompany = 'auth_company';
  static const String _keyIsFirstLogin = 'is_first_login';
  static const String _keyTwoFactor = 'two_factor_enabled';

  static Future<void> init() async {
    await GetStorage.init();
  }

  // Token
  String? get token => _box.read(_keyToken);
  Future<void> saveToken(String token) => _box.write(_keyToken, token);
  Future<void> clearToken() => _box.remove(_keyToken);

  // Language
  String? get language => _box.read(_keyLanguage);
  Future<void> saveLanguage(String localeCode) => _box.write(_keyLanguage, localeCode);
  bool get hasSelectedLanguage => _box.hasData(_keyLanguage);

  // User / Company (الحل الصارم للأخطاء المجهولة)
  Map<String, dynamic>? get user {
    final data = _box.read(_keyUser);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> saveUser(Map<String, dynamic> user) => _box.write(_keyUser, user);

  Map<String, dynamic>? get company {
    final data = _box.read(_keyCompany);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> saveCompany(Map<String, dynamic> company) => _box.write(_keyCompany, company);

  // First login flag
  bool get isFirstLogin => _box.read(_keyIsFirstLogin) ?? false;
  Future<void> setFirstLogin(bool value) => _box.write(_keyIsFirstLogin, value);

  bool get twoFactorEnabled {
    if (_box.read(_keyTwoFactor) == true) return true;
    final storedUser = user;
    if (storedUser != null && storedUser['two_factor_enabled'] == true) {
      return true;
    }
    return false;
  }

  Future<void> saveTwoFactorEnabled(bool value) async {
    await _box.write(_keyTwoFactor, value);
    final storedUser = user;
    if (storedUser != null) {
      storedUser['two_factor_enabled'] = value;
      await _box.write(_keyUser, storedUser);
    }
  }

  Future<void> clearSession() async {
    await _box.remove(_keyToken);
    await _box.remove(_keyUser);
    await _box.remove(_keyCompany);
    await _box.remove(_keyIsFirstLogin);
    await _box.remove(_keyTwoFactor);
  }
}