import 'package:get/get.dart';

import 'string_utils.dart';

class CoreValidators {
  CoreValidators._();

  static final RegExp _phone = RegExp(r'^\d{8,15}$');
  static final RegExp _integer = RegExp(r'^\d+$');
  static final RegExp _email = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required!'.tr;
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (!_phone.hasMatch(value!)) {
      return 'Please enter valid mobile number!'.tr;
    }
    return null;
  }

  static String? phoneOptional(String? value) {
    if (!StringUtils.isNotBlank(value)) return null;
    if (!_phone.hasMatch(value!)) {
      return 'Please enter valid mobile number!'.tr;
    }
    return null;
  }

  static String? integer(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (!_integer.hasMatch(value!)) {
      return 'Please enter valid number!'.tr;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required!'.tr;
    }
    if (!_email.hasMatch(value)) {
      return 'Please enter valid email!'.tr;
    }
    return null;
  }
}
