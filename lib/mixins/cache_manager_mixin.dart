import '../constants/common.dart';
import '../services/storage_service.dart';

mixin CacheManagerMixin {
  Future<void> saveToken(String? token) => StorageService.saveToken(token);

  String? getToken() => StorageService.token;

  Future<void> removeToken() => StorageService.remove(StorageItem.token);

  Future<void> saveUser(String user) => StorageService.saveUser(user);

  String? getUser() => StorageService.user;

  Future<void> removeUser() => StorageService.remove(StorageItem.user);

  Future<void> saveLocale(String locale) => StorageService.saveLocale(locale);

  String? getLocale() => StorageService.locale;

  Future<void> saveIsDarkMode(bool isDarkMode) =>
      StorageService.saveIsDarkMode(isDarkMode);

  bool? getIsDarkMode() => StorageService.isDarkMode;

  Future<void> clearCache() => StorageService.clear();
}
