import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../utils/common_utils.dart';

enum StorageItem {
  user,
  token,
  languages,
  deviceInfo,
  isDarkMode,
  locale,
  expiredDt,
  translationKeys,
  defaultCardIndex,
  defaultCurrency,
}

enum EnvItem { baseApiUrl, authHeadKey }

var windowHeight = MediaQuery.of(Get.context!).size.height;
var statusBarHeight = MediaQuery.of(Get.context!).viewPadding.top;
var screenHeight = windowHeight - statusBarHeight;
var screenWidth = MediaQuery.of(Get.context!).size.width;
var isTablet = MediaQuery.of(Get.context!).size.shortestSide > 700;

var curentDate = getCurrentDate();
