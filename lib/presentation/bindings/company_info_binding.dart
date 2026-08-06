import 'package:get/get.dart';

import '../controllers/company_info_controller.dart';

class CompanyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyInfoController());
  }
}
