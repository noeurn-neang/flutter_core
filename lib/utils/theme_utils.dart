import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/common.dart';
import '../services/index.dart';

/// Refreshes status bar icon brightness after theme changes.
/// [header] — purple header screens (main tabs, auth); otherwise content style.
void refreshStatusBarBrightness({bool header = false}) {
  final isDarkMode =
      StorageService.getBool(StorageItem.isDarkMode.toString()) ?? false;
  final useLightIcons = header || isDarkMode;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness:
        useLightIcons ? Brightness.light : Brightness.dark,
    statusBarBrightness:
        useLightIcons ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness:
        useLightIcons ? Brightness.light : Brightness.dark,
  ));
}
