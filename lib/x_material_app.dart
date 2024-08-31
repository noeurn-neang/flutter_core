import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './utils/translate_utils.dart';
import 'configs/variables.dart';
import 'constants/common.dart';
import 'routes/app_pages.dart';
import 'services/index.dart';

class XMaterialApp extends StatelessWidget {
  final String? title;
  final String? initialRoute;
  final List<GetPage>? getPages;
  final Bindings? initialBinding;
  final Map<String, Map<String, String>>? translationsKeys;
  final Locale? locale;
  final Locale? fallbackLocale;
  final TransitionBuilder? builder;
  final ThemeMode themeMode;
  final Color? colorSchemeSeed;
  final ThemeData? theme;

  const XMaterialApp(
      {super.key,
      this.title,
      this.initialRoute,
      this.getPages,
      this.initialBinding,
      this.translationsKeys,
      this.locale,
      this.fallbackLocale,
      this.builder,
      this.themeMode = ThemeMode.system,
      this.colorSchemeSeed,
      this.theme});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        StorageService.getBool(StorageItem.isDarkMode.toString()) ??
            (MediaQuery.of(context).platformBrightness == Brightness.dark);
    String localeStr =
        StorageService.getString(StorageItem.locale.toString()) ?? 'en_US';

    print(isDarkMode);

    for (var route in AppPages.routes) {
      getPages!.add(route);
    }

    return GetMaterialApp(
      title: title ?? 'Application',
      initialRoute: initialRoute,
      initialBinding: initialBinding,
      getPages: getPages,
      translationsKeys: translationsKeys,
      locale: getLocaleFromString(localeStr),
      fallbackLocale:
          fallbackLocale ?? getLocaleFromString(Variables.defaultLocaleCode),
      debugShowCheckedModeBanner: false,
      builder: builder ?? EasyLoading.init(),
      themeMode: themeMode,
      theme: isDarkMode ? Variables.themeDataDark : Variables.themeDataLight,
    );
  }
}
