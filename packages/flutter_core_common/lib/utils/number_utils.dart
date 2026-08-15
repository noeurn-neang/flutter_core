double? parseDouble(dynamic data) {
  if (data == null) return null;
  return num.tryParse('$data')?.toDouble();
}
