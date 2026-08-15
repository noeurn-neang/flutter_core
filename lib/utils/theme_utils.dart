import 'dart:io';

import 'package:flutter/services.dart';

import '../constants/common.dart';
import '../services/storage_service.dart';

void refreshStatusBarBrightness() {
  final isDarkMode = StorageService.getBool(StorageItem.isDarkMode) ?? false;
  final overlay = isDarkMode
      ? SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
        )
      : SystemUiOverlayStyle.dark.copyWith(
          statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
        );
  SystemChrome.setSystemUIOverlayStyle(overlay);
}
