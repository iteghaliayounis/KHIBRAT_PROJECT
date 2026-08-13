import 'package:get/get.dart';

import '../controllers/company_policies_controller.dart';

class CompanyPoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyPoliciesController());
  }
}
