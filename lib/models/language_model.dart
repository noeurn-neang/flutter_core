class LanguageModel {
  const LanguageModel({
    required this.languageCode,
    required this.countryCode,
    required this.title,
  });

  final String languageCode;
  final String countryCode;
  final String title;

  String get localeCode =>
      '${languageCode}_${countryCode.toUpperCase()}';
}
