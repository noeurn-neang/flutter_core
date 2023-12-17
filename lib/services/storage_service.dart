import 'package:get_storage/get_storage.dart';

class StorageService {

  static Future<void> write(String key, dynamic value) async {
    final box = GetStorage();
    return await box.write(key, value!);
  }

  static String? getString(String key) {
    final box = GetStorage();
    return box.read(key);
  }

  static bool? getBool(String key) {
    final box = GetStorage();
    return box.read(key);
  }

  static Future<void> remove(String key) async {
    final box = GetStorage();
    return box.remove(key);
  }

  static Future<void> clear() async {
    final box = GetStorage();
    return box.erase();
  }
}
