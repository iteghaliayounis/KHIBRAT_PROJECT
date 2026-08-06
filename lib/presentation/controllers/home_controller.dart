import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/profile_model.dart';
import '../../data/providers/profile_provider.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class HomeController extends GetxController {
  late final GetProfileUsecase _getProfileUsecase;

  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final RxBool isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    final provider = ProfileProvider();
    final repository = ProfileRepositoryImpl(provider);
    _getProfileUsecase = GetProfileUsecase(repository);
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoadingProfile.value = true;
      profile.value = await _getProfileUsecase();
    } catch (_) {
      // نُبقي القيم السابقة أو فارغة دون إزعاج المستخدم على الرئيسية
    } finally {
      isLoadingProfile.value = false;
    }
  }

  String get fullName {
    final name = profile.value?.fullName.trim() ?? '';
    return name;
  }

  String get jobTitle {
    return profile.value?.jobTitle?.trim() ?? '';
  }

  String? get profileImageUrl {
    return _resolveMediaUrl(profile.value?.profileImageUrl);
  }

  String get initials {
    final name = fullName;
    if (name.isEmpty) return '?';
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  static String? _resolveMediaUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final parsed = Uri.tryParse(url.trim());
    if (parsed == null) return url;
    final base = Uri.parse(ApiConstants.baseUrl);
    if (parsed.host == 'localhost' || parsed.host == '127.0.0.1') {
      return parsed
          .replace(
            scheme: base.scheme,
            host: base.host,
            port: base.hasPort ? base.port : null,
          )
          .toString();
    }
    return url;
  }
}
