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
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorWidget = SizedBox(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        strokeCap: StrokeCap.round,
        color: scheme.primary,
      ),
    )
    ..indicatorSize = 36
    ..radius = 20
    ..fontSize = 14
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 28, vertical: 22)
    ..backgroundColor = scheme.surfaceContainerHigh
    ..indicatorColor = scheme.primary
    ..textColor = scheme.onSurface
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = scheme.scrim.withValues(alpha: 0.32)
    ..boxShadow = [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.16),
        blurRadius: 28,
        offset: const Offset(0, 10),
      ),
    ]
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..userInteractions = false
    ..dismissOnTap = false;
}
