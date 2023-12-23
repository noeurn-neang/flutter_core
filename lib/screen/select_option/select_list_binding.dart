import 'package:get/get.dart';

import 'select_list_controller.dart';

class SelectListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectListController());
  }
}
