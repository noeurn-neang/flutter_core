import 'package:flutter/services.dart';

import '../constants/common.dart';
import '../services/index.dart';

refreshStatusBarBightness() {
  bool isDarkMode =
      StorageService.getBool(StorageItem.isDarkMode.toString()) ?? false;
  Brightness brightness = isDarkMode ? Brightness.dark : Brightness.light;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: brightness, statusBarIconBrightness: brightness));
}
