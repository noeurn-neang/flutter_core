import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import '../config/flutter_core_config.dart';

Locale getLocaleFromString(String locale) {
  final arr = locale.split('_');
  return Locale(arr[0], arr.length > 1 ? arr[1] : 'US');
}

String getCountryCodeFromLocale(String locale) {
  final arr = locale.split('_');
  return arr.length > 1 ? arr[1] : 'US';
}

String getCountryFromLocale(String locale) {
  return FlutterCoreConfig.current.languages
      .firstWhere(
        (element) => element.localeCode == locale,
        orElse: () => FlutterCoreConfig.current.languages.first,
      )
      .title;
}

Widget getFlagFromLocale(
  String locale, {
  double width = 30,
  double height = 20,
  double borderRadius = 3,
}) {
  return Flag.fromString(
    getCountryCodeFromLocale(locale),
    height: height,
    width: width,
    fit: BoxFit.fill,
    borderRadius: borderRadius,
  );
}

Widget getFlagCountryCode(
  String locale, {
  double width = 30,
  double height = 20,
  double borderRadius = 3,
}) {
  try {
    return Flag.fromString(
      locale,
      height: height,
      width: width,
      fit: BoxFit.fill,
      borderRadius: borderRadius,
    );
  } catch (_) {
    return const Icon(Icons.flag);
  }
}
