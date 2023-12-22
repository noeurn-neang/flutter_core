import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import './mixins/cache_manager_mixin.dart';
import './models/app_setting_model.dart';

abstract class BaseAuthManager extends GetxController with CacheManagerMixin {
  final appSetting = AppSettingModel().obs;

  @override
  void onReady() {
    super.onReady();
    Timer(const Duration(seconds: 1), () {
      checkLoginStatus();
    });
  }

  void logOut() async {
    await removeToken();
    await removeUser();
    redirectAfterLoggedOut();
  }

  void login(Map<String, dynamic> response) async {
    var tokenStr = response['access_token'];
    var userJson = response['user'];
    setAuthState(userJson);
    saveToCache(tokenStr, userJson);
    // saveDeviceToken();
    redirectAfterLoggedIn();
  }

  void redirectAfterLoggedIn();

  void redirectAfterLoggedOut();

  void setAuthState(userJson);

  void saveToCache(tokenStr, userJson) async {
    await saveUser(json.encode(userJson));
    if (tokenStr != null) await saveToken(tokenStr);

    // var expiredDt = DateTime.now().add(const Duration(hours: 1));
    // await saveExpiredDt(expiredDt.toString());
  }

  Future<void> checkLoginStatus() async {
    final token = getToken();
    if (token != null) {
      try {
        var userStr = getUser();
        setAuthState(json.decode(userStr!));
        redirectAfterLoggedIn();
      } catch (e) {
        logOut();
      }
    } else {
      redirectAfterLoggedOut();
    }
  }
}
