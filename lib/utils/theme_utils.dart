import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../config/flutter_core_config.dart';
import '../constants/common.dart';
import '../services/storage_service.dart';

void refreshStatusBarBrightness() {
  if (kIsWeb) return;

  final isDarkMode = StorageService.getBool(StorageItem.isDarkMode) ?? false;
  SystemChrome.setSystemUIOverlayStyle(
    isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
  );
}

/// Align EasyLoading with the active light/dark [ThemeData].
void applyOverlayTheme({bool? isDark}) {
  final dark = isDark ?? StorageService.getBool(StorageItem.isDarkMode) ?? false;
  final theme = dark
      ? FlutterCoreConfig.current.themeDataDark
      : FlutterCoreConfig.current.themeDataLight;
  final scheme = theme.colorScheme;

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45
    ..radius = 12
    ..backgroundColor = scheme.surfaceContainerHighest
    ..indicatorColor = scheme.primary
    ..textColor = scheme.onSurface
    ..maskColor = scheme.scrim.withValues(alpha: 0.45)
    ..userInteractions = true
    ..dismissOnTap = false;
}
