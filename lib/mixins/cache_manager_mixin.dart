import '../constants/common.dart';
import '../services/index.dart';

mixin CacheManagerMixin {
  Future<bool> saveToken(String? token) async {
    StorageService.write(StorageItem.token.toString(), token);
    return true;
  }

  String? getToken() {
    return StorageService.getString(StorageItem.token.toString());
  }

  Future<void> removeToken() async {
    return await StorageService.remove(StorageItem.token.toString());
  }

  Future<bool> saveUser(String user) async {
    StorageService.write(StorageItem.user.toString(), user);
    return true;
  }

  String? getUser() {
    return StorageService.getString(StorageItem.user.toString());
  }

  Future<void> removeUser() async {
    return await StorageService.remove(StorageItem.user.toString());
  }

  Future<bool> saveExpiredDt(String expireDate) async {
    StorageService.write(StorageItem.expiredDt.toString(), expireDate);
    return true;
  }

  String? getExpiredDt() {
    return StorageService.getString(StorageItem.expiredDt.toString());
  }

  Future<void> removeExpiredDt() async {
    return await StorageService.remove(StorageItem.expiredDt.toString());
  }

  Future<bool> saveLanguages(String languages) async {
    StorageService.write(StorageItem.languages.toString(), languages);
    return true;
  }

  String? getLanguages() {
    return StorageService.getString(StorageItem.languages.toString());
  }

  Future<void> removeLanguages() async {
    return await StorageService.remove(StorageItem.languages.toString());
  }

  Future<bool> saveIsDarkMode(bool? isDarkMode) async {
    StorageService.write(StorageItem.isDarkMode.toString(), isDarkMode);
    return true;
  }

  Future<bool> saveLocale(String locale) async {
    StorageService.write(StorageItem.locale.toString(), locale);
    return true;
  }

  bool? getIsDarkMode() {
    return StorageService.getBool(StorageItem.isDarkMode.toString());
  }

  String? getLocale() {
    return StorageService.getString(StorageItem.locale.toString());
  }

  Future<void> clearCache() async {
    return await StorageService.clear();
  }
}
