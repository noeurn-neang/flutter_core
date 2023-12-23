import 'package:get/get.dart';

import '../screen/select_option/select_list_binding.dart';
import '../screen/select_option/select_list_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.SELECT_LIST,
      page: () => SelectListView(),
      binding: SelectListBinding(),
    ),
  ];
}
