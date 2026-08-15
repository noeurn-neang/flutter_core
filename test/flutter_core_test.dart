import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_core/flutter_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DateFormats parses ISO and formats', () {
    final parsed = DateFormats.tryParse('2024-01-15');
    expect(parsed, DateTime(2024, 1, 15));
    expect(DateFormats.format(DateTime(2024, 1, 15), pattern: 'y-MM-dd'),
        '2024-01-15');
  });

  test('StringUtils isNotBlank and hashMd5', () {
    expect(StringUtils.isNotBlank(' a '), isTrue);
    expect(StringUtils.isNotBlank(''), isFalse);
    expect(StringUtils.hashMd5('a'), isNotEmpty);
  });

  test('CoreValidators email', () {
    expect(CoreValidators.email(null), isNotNull);
    expect(CoreValidators.email('not-an-email'), isNotNull);
    expect(CoreValidators.email('user@example.com'), isNull);
  });

  test('parseDouble', () {
    expect(parseDouble('3.5'), 3.5);
    expect(parseDouble(null), isNull);
  });

  test('LanguageModel localeCode', () {
    const language = LanguageModel(
      languageCode: 'km',
      countryCode: 'kh',
      title: 'Khmer',
    );
    expect(language.localeCode, 'km_KH');
  });
}
