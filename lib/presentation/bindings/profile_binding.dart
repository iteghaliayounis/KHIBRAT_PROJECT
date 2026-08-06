import 'package:get/get.dart';
import '../../data/providers/profile_provider.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_documents_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileProvider>(() => ProfileProvider());
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileProvider>()),
    );
    Get.lazyPut(() => GetProfileUsecase(Get.find<ProfileRepository>()));
    Get.lazyPut(() => UpdateProfileUsecase(Get.find<ProfileRepository>()));
    Get.lazyPut(
      () => UploadProfileDocumentsUsecase(Get.find<ProfileRepository>()),
    );
    Get.lazyPut(
      () => ProfileController(
        getProfileUsecase: Get.find(),
        updateProfileUsecase: Get.find(),
        uploadDocumentsUsecase: Get.find(),
      ),
    );
  }
}
