import 'package:flutter/material.dart';
import 'package:flutter_core_common/flutter_core_common.dart';

import '../constants/countries.dart';

/// Country list picker. Lives in `flutter_core` so common stays picker-free.
class CountrySelect extends StatelessWidget {
  const CountrySelect({
    super.key,
    this.title,
    this.enabled = true,
    this.controller,
    this.border,
    this.icon,
    this.labelKey = 'label',
    this.valueKey = 'code',
    this.validator,
  });

  final String? title;
  final bool enabled;
  final SelectOptionController? controller;
  final InputBorder? border;
  final Widget? icon;
  final String labelKey;
  final String valueKey;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return SelectOption(
      title: title,
      enabled: enabled,
      controller: controller,
      border: border,
      icon: icon,
      labelKey: labelKey,
      valueKey: valueKey,
      validator: validator,
      items: List<Map<String, dynamic>>.from(countries),
      itemIcon: (item) => getFlagCountryCode('${item[valueKey]}'),
    );
  }
}
