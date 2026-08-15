enum StorageItem {
  user,
  token,
  languages,
  isDarkMode,
  locale,
  expiredDt,
  defaultCurrency,
}

extension StorageItemKey on StorageItem {
  String get key => name;
}
