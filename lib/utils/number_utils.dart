import 'string_utils.dart';

double? parseDouble(dynamic data) {
  return StringUtils.isNotNull(data) ? double.parse('$data') : null;
}
