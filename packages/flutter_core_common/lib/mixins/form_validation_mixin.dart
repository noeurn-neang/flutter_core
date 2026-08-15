import '../utils/core_validators.dart';

mixin FormValidationMixin {
  String? validateRequired(String? value) => CoreValidators.required(value);

  String? validatePhoneNumber(String? value) => CoreValidators.phone(value);

  String? validatePhoneNumberOptional(String? value) =>
      CoreValidators.phoneOptional(value);

  String? validateInteger(String? value) => CoreValidators.integer(value);

  String? validateEmail(String? value) => CoreValidators.email(value);
}
