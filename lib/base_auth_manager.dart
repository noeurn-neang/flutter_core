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
    Timer(const Duration(milliseconds: 200), () {
      checkLoginStatus();
    });
  }

  Future<void> logOut() async {
    removeAuthState();
    await removeToken();
    await removeUser();
    redirectAfterLoggedOut();
  }

  Future<void> login({
    required Map<String, dynamic> user,
    String? token,
  }) async {
    setAuthState(user);
    await saveUser(json.encode(user));
    if (token != null) await saveToken(token);
    redirectAfterLoggedIn();
  }

  void redirectAfterLoggedIn();

  void redirectAfterLoggedOut();

  void setAuthState(dynamic userJson);

  void removeAuthState();

  Future<void> checkLoginStatus() async {
    final token = getToken();
    if (token != null) {
      try {
        final userStr = getUser();
        setAuthState(json.decode(userStr!));
        redirectAfterLoggedIn();
      } catch (_) {
        await logOut();
      }
    } else {
      redirectAfterLoggedOut();
    }
  }
}
