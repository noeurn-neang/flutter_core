import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import '../configs/variables.dart';

Locale getLanguageCodeFromLocale(String locale) {
  var arr = locale.split('_');
  return Locale(arr[0], arr.length > 1 ? arr[1] : 'US');
}

String getCountryCodeFromLocale(String locale) {
  var arr = locale.split('_');
  return arr.length > 1 ? arr[1] : 'US';
}

String getCountryFromLocale(String locale) {
  var language = Variables.languages
      .where((element) =>
          '${element.languageCode}_${element.countryCode.toUpperCase()}' ==
          locale)
      .first;

  return language.title;
}

Widget getFlagFromLocale(String locale,
    {double width = 30, double height = 20, double borderRadius = 3}) {
  return Flag.fromString(
    getCountryCodeFromLocale(locale),
    height: height,
    width: width,
    fit: BoxFit.fill,
    borderRadius: borderRadius,
  );
}
