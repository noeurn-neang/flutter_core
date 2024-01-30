import 'package:flutter/material.dart';

import '../models/language_model.dart';

class Variables {
  Variables._();

  static String authHeaderKey = 'Authorization';
  static String defaultLocaleCode = 'en_US';
  static List<LanguageModel> languages = [LanguageModel("en", "us", "English")];

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

  static double maxUploadImageWidth = 720;
  static double maxUploadImageHeight = 1024;
  static int uploadImageQuaility = 100; // 50% quaility
}
