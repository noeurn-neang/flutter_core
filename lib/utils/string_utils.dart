import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StringUtils {
  StringUtils._();

  static String hashMd5(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }

  /// Kept for existing call sites; prefer [hashMd5].
  static String encryptMd5(String value) => hashMd5(value);

  static bool isNotBlank(String? text) => text != null && text.trim().isNotEmpty;

  /// Kept for existing call sites; prefer [isNotBlank].
  static bool isNotNull(String? text) => isNotBlank(text);

  static String formatPhoneNumber(String number) {
    if (number.length < 7) return number;

    final prefixNumber = number.substring(0, 3);
    var phoneNumber = '($prefixNumber) ';

    if (number[0] == '0') {
      phoneNumber += addSpaceEvery3Digits(number.substring(3));
    } else {
      phoneNumber +=
          '${number.substring(3, 5)} ${addSpaceEvery3Digits(number.substring(5))}';
    }

    return phoneNumber;
  }

  static String addSpaceEvery3Digits(String phoneNumber) {
    if (phoneNumber.length <= 3) return phoneNumber;
    final firstPart = phoneNumber.substring(0, 3);
    final remainingDigits = phoneNumber.substring(3);
    return '$firstPart ${addSpaceEvery3Digits(remainingDigits)}';
  }

  static String formatMoney(String? currency, double? amount) {
    final format =
        NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);
    return '${currency ?? 'USD'} ${format.format(amount ?? 0)}';
  }

  static String formatNumber(double? amount) {
    return NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2)
        .format(amount ?? 0);
  }

  static TimeOfDay toTime(String text) {
    final dateTime = DateFormat('h:mm a').parse(text);
    return TimeOfDay.fromDateTime(dateTime);
  }

  static String doubleWithoutZero(double value) {
    final regex = RegExp(r'([.]*0)(?!.*\d)');
    return value.toString().replaceAll(regex, '');
  }

  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.ceil()} m';
  }
}
