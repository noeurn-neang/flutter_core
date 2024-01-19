import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

NumberFormat numberFormat =
    NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);

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

  static String formatMoney(String? currency, double? amount) {
    return '${currency ?? 'USD'} ${numberFormat.format(amount ??= 0)}';
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('d-MMM-y HH:ss').format(dateTime);
  }

  static String formatDateDB(String? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('d-MMM-y').format(toDate(dateTime));
  }

  static String formatDateTimeDB(String? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('d-MMM-y HH:ss').format(toDate(dateTime));
  }

  static DateTime toDate(String dateStr) {
    var strArr = dateStr.split(' ');
    var dateStrArr = strArr[0].split('-');
    var hour = 0;
    var min = 0;
    var second = 0;
    if (strArr.length > 1) {
      var timeStrArr = strArr[1].split(':');
      hour = int.parse(timeStrArr[0]);
      min = int.parse(timeStrArr[1]);
      if (timeStrArr.length > 2) {
        second = int.parse(timeStrArr[2].split('.')[0]);
      }
    }

    return DateTime(
      int.parse(dateStrArr[0]),
      int.parse(dateStrArr[1]),
      int.parse(dateStrArr[2]),
      hour = hour,
      min = min,
      second = second,
    );
  }

  static bool isNotNull(String? text) {
    return text != null && text.isNotEmpty;
  }
}
