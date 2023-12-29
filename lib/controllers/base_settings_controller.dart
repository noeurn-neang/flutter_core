import 'package:get/get.dart';

import '../configs/variables.dart';
import '../mixins/cache_manager_mixin.dart';
import '../utils/dialog_utils.dart';
import '../utils/theme_utils.dart';
import '../utils/translate_utils.dart';

class BaseSettingsController extends GetxController with CacheManagerMixin {
  var isDarkMode = false.obs;
  final locale = Variables.defaultLocaleCode.obs;

  BaseSettingsController();

  @override
  void onInit() {
    super.onInit();

    isDarkMode.value = getIsDarkMode() ?? false;
    locale.value = getLocale() ?? Variables.defaultLocaleCode;
  }

  void handleChangeLanguage() {
    showLanguageDialog();
  }

  void handleChangeThemeMode() {
    isDarkMode.value = !isDarkMode.value;
    saveIsDarkMode(isDarkMode.value);
    Get.changeTheme(
        isDarkMode.value ? Variables.themeDataDark : Variables.themeDataLight);
    refreshStatusBarBrightness();
    Get.forceAppUpdate();
  }

  showLanguageDialog() {
    var list = Variables.languages
        .map((element) => ({
              'id':
                  '${element.languageCode}_${element.countryCode.toUpperCase()}',
              'name': element.title,
              'icon': getFlagFromLocale(
                  '${element.languageCode}_${element.countryCode.toUpperCase()}')
            }))
        .toList();

    DialogUtils.showSelection(Get.context!, list,
        title: 'Select Language'.tr,
        selectedId: locale.value, onItemSelected: (dynamic newLocale) {
      locale.value = newLocale;
      saveLocale(newLocale);
      Get.updateLocale(getLocaleFromString(newLocale));
      Get.back();
    });
  }
}
