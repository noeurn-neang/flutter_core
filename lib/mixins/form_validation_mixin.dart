import '../getx.dart';
import '../utils/string_utils.dart';

mixin FormValidationMixin {
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required!'.tr;
    }

    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required!'.tr;
    }

    String patttern = r'^\d{8,15}$';
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number!'.tr;
    }

    return null;
  }

  String? validatePhoneNumberOptional(String? value) {
    if (StringUtils.isNotNull(value)) {
      String patttern = r'^\d{8,15}$';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value!)) {
        return 'Please enter valid mobile number!'.tr;
      }
    }

    return null;
  }

  String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required!'.tr;
    }

    String patttern = r'^\d+$';
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid number!'.tr;
    }

    return null;
  }

  String? validateEmail(String? value) {
    String patttern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(value!)) {
      return 'Please enter valid email!'.tr;
    }

    return null;
  }
}
