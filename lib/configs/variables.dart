import 'package:flutter/material.dart';

import '../models/language_model.dart';

class Variables {
  Variables._();

  static String authHeaderKey = 'Authorization';
  static String defaultLocaleCode = 'en_US';
  static String defaultDateFormat = 'd-MMM-y';
  static String defaultDateTimeFormat = 'dd-MMM-y HH:ss';
  static List<LanguageModel> languages = [LanguageModel("en", "us", "English")];
  static String appVersion = '1.0.0';

  static ThemeData themeDataLight = ThemeData(
    colorSchemeSeed: Colors.deepOrange,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData themeDataDark = ThemeData(
    colorSchemeSeed: Colors.deepOrange,
    useMaterial3: true,
    brightness: Brightness.dark,
  );

  static double maxUploadImageWidth = 1024;
  static double maxUploadImageHeight = 1024;
  static int uploadImageQuaility = 80; // 50% quaility
}
