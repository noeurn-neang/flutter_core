double? parseDouble(dynamic data) {
  return data != null ? double.parse('$data') : null;
}
