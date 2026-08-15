import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'config/flutter_core_config.dart';
import 'constants/common.dart';
import 'services/storage_service.dart';
import 'utils/translate_utils.dart';

/// Root widget wrapping [GetMaterialApp] with persisted theme and locale.
class XMaterialApp extends StatelessWidget {
  XMaterialApp({
    super.key,
    this.title,
    this.initialRoute,
    List<GetPage>? getPages,
    this.initialBinding,
    this.translationsKeys,
    this.locale,
    this.fallbackLocale,
    this.builder,
    this.themeMode = ThemeMode.system,
    this.theme,
    this.darkTheme,
  }) : getPages = List<GetPage>.from(getPages ?? const []);

  final String? title;
  final String? initialRoute;
  final List<GetPage> getPages;
  final Bindings? initialBinding;
  final Map<String, Map<String, String>>? translationsKeys;
  final Locale? locale;
  final Locale? fallbackLocale;
  final TransitionBuilder? builder;
  final ThemeMode themeMode;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  @override
  Widget build(BuildContext context) {
    final storedDark = StorageService.getBool(StorageItem.isDarkMode);
    final platformDark =
        MediaQuery.maybeOf(context)?.platformBrightness == Brightness.dark;
    final isDarkMode = storedDark ?? platformDark;
    final localeStr =
        StorageService.getString(StorageItem.locale) ??
        FlutterCoreConfig.current.defaultLocaleCode;

    return GetMaterialApp(
      title: title ?? 'Application',
      initialRoute: initialRoute,
      initialBinding: initialBinding,
      getPages: getPages,
      translationsKeys: translationsKeys,
      locale: locale ?? getLocaleFromString(localeStr),
      fallbackLocale: fallbackLocale ??
          getLocaleFromString(FlutterCoreConfig.current.defaultLocaleCode),
      debugShowCheckedModeBanner: false,
      builder: builder ?? EasyLoading.init(),
      themeMode: themeMode,
      theme: theme ??
          (isDarkMode
              ? FlutterCoreConfig.current.themeDataDark
              : FlutterCoreConfig.current.themeDataLight),
      darkTheme: darkTheme ?? FlutterCoreConfig.current.themeDataDark,
    );
  }
}
