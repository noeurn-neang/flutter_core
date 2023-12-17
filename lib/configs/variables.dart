import '../models/language_model.dart';

class Variables {
  Variables._();

  static String authHeaderKey = 'Authorization';
  static String defaultLocaleCode = 'en_US';
  static List<LanguageModel> languages = [LanguageModel("en", "us", "English")];
}
