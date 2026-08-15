import 'package:intl/intl.dart';

import '../config/flutter_core_config.dart';

class DateFormats {
  DateFormats._();

  static String format(DateTime? dateTime, {String? pattern}) {
    if (dateTime == null) return '';
    return DateFormat(
      pattern ?? FlutterCoreConfig.current.defaultDateFormat,
    ).format(dateTime);
  }

  static String formatDateTime(DateTime? dateTime, {String? pattern}) {
    if (dateTime == null) return '';
    return DateFormat(
      pattern ?? FlutterCoreConfig.current.defaultDateTimeFormat,
    ).format(dateTime);
  }

  static DateTime? tryParse(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value) ??
        _tryFixed(value) ??
        _tryPattern(value, FlutterCoreConfig.current.defaultDateFormat) ??
        _tryPattern(value, FlutterCoreConfig.current.defaultDateTimeFormat);
  }

  static DateTime? _tryPattern(String value, String pattern) {
    try {
      return DateFormat(pattern).parseLoose(value);
    } catch (_) {
      return null;
    }
  }

  static DateTime? _tryFixed(String value) {
    try {
      return DateFormat('y-MM-dd').parseLoose(value.split('T').first.split(' ').first);
    } catch (_) {
      return null;
    }
  }

  static String now({String pattern = 'y-MM-dd'}) {
    return DateFormat(pattern).format(DateTime.now());
  }
}
