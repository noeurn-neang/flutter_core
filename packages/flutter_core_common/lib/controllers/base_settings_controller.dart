import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/flutter_core_config.dart';
import '../mixins/cache_manager_mixin.dart';
import '../utils/dialog_utils.dart';
import '../utils/theme_utils.dart';
import '../utils/translate_utils.dart';

class BaseSettingsController extends GetxController with CacheManagerMixin {
  final isDarkMode = false.obs;
  final locale = FlutterCoreConfig.current.defaultLocaleCode.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = getIsDarkMode() ?? false;
    locale.value = getLocale() ?? FlutterCoreConfig.current.defaultLocaleCode;
  }

  void handleChangeLanguage() {
    showLanguageDialog();
  }

  void handleChangeThemeMode() {
    isDarkMode.value = !isDarkMode.value;
    saveIsDarkMode(isDarkMode.value);
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
    applyOverlayTheme(isDark: isDarkMode.value);
    refreshStatusBarBrightness();
  }

  Future<void> showLanguageDialog() async {
    final context = Get.context;
    if (context == null) return;

    final list = FlutterCoreConfig.current.languages
        .map(
          (element) => SelectionItem(
            id: element.localeCode,
            name: element.title,
            icon: getFlagFromLocale(element.localeCode),
          ),
        )
        .toList();

    await DialogUtils.showSelection(
      context,
      list,
      title: 'Select Language'.tr,
      selectedId: locale.value,
      onItemSelected: (newLocale) {
        locale.value = newLocale;
        saveLocale(newLocale);
        Get.updateLocale(getLocaleFromString(newLocale));
      },
    );
  }
}
