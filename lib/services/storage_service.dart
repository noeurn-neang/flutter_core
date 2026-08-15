import 'package:get_storage/get_storage.dart';

import '../constants/common.dart';

class StorageService {
  StorageService._();

  static final GetStorage _box = GetStorage();

  static Future<void> write(StorageItem item, dynamic value) {
    if (value == null) {
      return _box.remove(item.key);
    }
    return _box.write(item.key, value);
  }

  static String? getString(StorageItem item) {
    final value = _box.read(item.key);
    return value?.toString();
  }

  static bool? getBool(StorageItem item) {
    final value = _box.read(item.key);
    if (value is bool) return value;
    return null;
  }

  static int? getInt(StorageItem item) {
    final value = _box.read(item.key);
    if (value is int) return value;
    return int.tryParse('$value');
  }

  static Future<void> remove(StorageItem item) => _box.remove(item.key);

  static Future<void> clear() => _box.erase();

  static Future<void> saveToken(String? token) => write(StorageItem.token, token);

  static String? get token => getString(StorageItem.token);

  static Future<void> saveUser(String? user) => write(StorageItem.user, user);

  static String? get user => getString(StorageItem.user);

  static Future<void> saveLocale(String locale) =>
      write(StorageItem.locale, locale);

  static String? get locale => getString(StorageItem.locale);

  static Future<void> saveIsDarkMode(bool isDarkMode) =>
      write(StorageItem.isDarkMode, isDarkMode);

  static bool? get isDarkMode => getBool(StorageItem.isDarkMode);
}
