import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';

import 'flutter_core_platform_interface.dart';
import 'utils/theme_utils.dart';

class FlutterCore {
  Future<String?> getPlatformVersion() {
    return FlutterCorePlatform.instance.getPlatformVersion();
  }

  static Future<void> initApplication() async {
    // Init get storage
    await GetStorage.init();

    // Change status bar color
    refreshStatusBarBightness();
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = true
      ..dismissOnTap = false;
  }
}
