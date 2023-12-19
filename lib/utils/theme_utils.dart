import 'dart:io';

import 'package:flutter/services.dart';

import '../constants/common.dart';
import '../services/index.dart';

refreshStatusBarBrightness() {
  bool isDarkMode =
      StorageService.getBool(StorageItem.isDarkMode.toString()) ?? false;
  Brightness brightness =
      isDarkMode && Platform.isIOS ? Brightness.dark : Brightness.light;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: brightness, statusBarIconBrightness: brightness));
}
