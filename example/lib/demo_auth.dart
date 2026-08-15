import 'package:flutter_core/flutter_core.dart';

/// Fake session for the example. Copy this pattern in your app.
class DemoAuthManager extends BaseAuthManager {
  final user = Rxn<BaseUserModel>();
  final isLoggedIn = false.obs;

  @override
  void redirectAfterLoggedIn() {
    isLoggedIn.value = true;
  }

  @override
  void redirectAfterLoggedOut() {
    isLoggedIn.value = false;
  }

  @override
  void setAuthState(dynamic userJson) {
    user.value = BaseUserModel.fromJson(
      Map<String, dynamic>.from(userJson as Map),
    );
  }

  @override
  void removeAuthState() {
    user.value = null;
  }
}
