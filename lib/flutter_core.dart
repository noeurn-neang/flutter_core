import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'config/flutter_core_config.dart';
import 'utils/theme_utils.dart';

export 'package:cached_network_image/cached_network_image.dart';
export 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource, XFile;

export 'base_auth_manager.dart';
export 'components/circle_image.dart';
export 'components/datepicker/date_picker_text_field.dart';
export 'components/datepicker/time_picker_text_field.dart';
export 'components/profile_picture.dart';
export 'components/selects/select_option.dart';
export 'config/flutter_core_config.dart';
export 'constants/common.dart';
export 'constants/countries.dart';
export 'constants/dimens.dart';
export 'constants/theme.dart';
export 'controllers/base_settings_controller.dart';
export 'getx.dart';
export 'mixins/cache_manager_mixin.dart';
export 'mixins/form_validation_mixin.dart';
export 'models/app_setting_model.dart';
export 'models/base_user_model.dart';
export 'models/language_model.dart';
export 'network/base_api_repository.dart';
export 'network/base_provider.dart';
export 'services/storage_service.dart';
export 'utils/color_utils.dart';
export 'utils/core_metrics.dart';
export 'utils/core_validators.dart';
export 'utils/date_formats.dart';
export 'utils/debouncer.dart';
export 'utils/dialog_utils.dart';
export 'utils/image_utils.dart';
export 'utils/message_utils.dart';
export 'utils/number_utils.dart';
export 'utils/request_utils.dart';
export 'utils/responsive_utils.dart';
export 'utils/string_utils.dart';
export 'utils/theme_utils.dart';
export 'utils/translate_utils.dart';
export 'x_material_app.dart';

/// Bootstrap helpers for storage, package info, and loading overlay.
class FlutterCore {
  /// Initializes storage, app version, and applies [config].
  static Future<void> init([FlutterCoreConfig? config]) async {
    if (config != null) {
      FlutterCoreConfig.current = config;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    FlutterCoreConfig.current.appVersion = packageInfo.version;

    await GetStorage.init();
    refreshStatusBarBrightness();
    applyOverlayTheme();
  }

  /// Kept for existing call sites.
  static Future<void> initApplication([FlutterCoreConfig? config]) =>
      init(config);

  static void configLoading() {
    applyOverlayTheme();
  }
}
