import 'dart:convert';

import 'package:crypto/crypto.dart';

class StringUtils {
  StringUtils._();

  static String encryptMd5(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }
}
