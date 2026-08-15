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
        themeDataLight = themeDataLight ??
            ThemeData(
              colorSchemeSeed: Colors.deepOrange,
              brightness: Brightness.light,
            ),
        themeDataDark = themeDataDark ??
            ThemeData(
              colorSchemeSeed: Colors.deepOrange,
              brightness: Brightness.dark,
            );

  static FlutterCoreConfig current = FlutterCoreConfig();

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
}
