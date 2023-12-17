import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color getColorFromOrderStatus(int status) {
    switch (status) {
      case -2:
      case -1:
        return const Color.fromRGBO(255, 64, 73, 1.0);
      case 1:
        return const Color.fromRGBO(255, 170, 85, 1.0);
      case 2:
        return const Color.fromRGBO(90, 149, 154, 1.0);
      case 3:
        return const Color.fromRGBO(255, 170, 85, 1.0);
      case 4:
        return const Color.fromRGBO(34, 187, 51, 1.0);
      case 5:
        return const Color.fromRGBO(34, 187, 51, 1.0);
      default:
        return getColorFromOrderStatus(1);
    }
  }
}
