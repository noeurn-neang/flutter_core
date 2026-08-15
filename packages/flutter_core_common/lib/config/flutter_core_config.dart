import 'package:flutter/material.dart';

import '../models/language_model.dart';

/// App-wide options passed to [FlutterCore.init].
class FlutterCoreConfig {
  FlutterCoreConfig({
    this.authHeaderKey = 'Authorization',
    this.useBearerToken = false,
    this.defaultLocaleCode = 'en_US',
    this.defaultDateFormat = 'd-MMM-y',
    this.defaultDateTimeFormat = 'dd-MMM-y HH:mm:ss',
    this.colorSchemeSeed = Colors.deepOrange,
    List<LanguageModel>? languages,
    ThemeData? themeDataLight,
    ThemeData? themeDataDark,
    this.maxUploadImageWidth = 1024,
    this.maxUploadImageHeight = 1024,
    this.uploadImageQuality = 80,
  })  : languages = languages ??
            [
              const LanguageModel(
                languageCode: 'en',
                countryCode: 'US',
                title: 'English',
              ),
            ],
        themeDataLight = themeDataLight ?? themeFromSeed(colorSchemeSeed, Brightness.light),
        themeDataDark = themeDataDark ?? themeFromSeed(colorSchemeSeed, Brightness.dark);

  static FlutterCoreConfig current = FlutterCoreConfig();

  /// Brand color. Used when [themeDataLight] / [themeDataDark] are omitted.
  Color colorSchemeSeed;

  String authHeaderKey;
  bool useBearerToken;
  String defaultLocaleCode;
  String defaultDateFormat;
  String defaultDateTimeFormat;
  List<LanguageModel> languages;
  ThemeData themeDataLight;
  ThemeData themeDataDark;
  String appVersion = '1.0.0';
  double maxUploadImageWidth;
  double maxUploadImageHeight;
  int uploadImageQuality;

  /// Material 3 theme so dialogs, sheets, and snackbars match the seed.
  static ThemeData themeFromSeed(Color seed, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        showDragHandle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
