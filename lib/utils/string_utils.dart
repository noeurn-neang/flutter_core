import 'dart:convert';

import 'package:crypto/crypto.dart';

class StringUtils {
  StringUtils._();

  static String encryptMd5(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }

  static String formatPhoneNumber(String number) {
    if (number.length < 7) return number;

    String prefixNumber = number.substring(0, 3);
    String phoneNumber = '($prefixNumber) ';

    if (number[0] == '0') {
      phoneNumber += addSpaceEvery3Digits(number.substring(3));
    } else {
      phoneNumber +=
          '${number.substring(3, 5)} ${addSpaceEvery3Digits(number.substring(5))}';
    }

    return phoneNumber;
  }

  static String addSpaceEvery3Digits(String phoneNumber) {
    if (phoneNumber.length <= 3) {
      return phoneNumber;
    } else {
      final firstPart = phoneNumber.substring(0, 3);
      final remainingDigits = phoneNumber.substring(3);
      return '$firstPart ${addSpaceEvery3Digits(remainingDigits)}';
    }
  }
}
