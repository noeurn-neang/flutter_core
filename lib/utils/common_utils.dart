String getCurrentDate() {
  DateTime now = DateTime.now();

  return '${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}';
}
