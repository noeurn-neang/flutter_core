# flutter_core

GetX bootstrap as two packages in one repo:

| Package | What you get |
|---|---|
| `flutter_core_common` | Theme, locale, storage, HTTP, auth base, forms, avatar **display** |
| `flutter_core` | Common **plus** camera/gallery, `ProfilePicture`, PhotoView, country select |

`flutter_core` depends on `flutter_core_common` and re-exports it. Full apps import `package:flutter_core/flutter_core.dart` only.

If you only need theme, HTTP, and forms, depend on **`flutter_core_common`**. That keeps camera/gallery plugins out of the app. Use **`flutter_core`** only when you need picker, gallery, or country select.

```yaml
# Basic
dependencies:
  flutter_core_common:
    git:
      url: https://github.com/noeurn-neang/flutter_core.git
      path: packages/flutter_core_common

# Full (includes common)
dependencies:
  flutter_core:
    git:
      url: https://github.com/noeurn-neang/flutter_core.git
      path: packages/flutter_core
```

Local path:

```yaml
dependencies:
  flutter_core:
    path: ../flutter_core/packages/flutter_core
```

## Quick start

```dart
import 'package:flutter_core/flutter_core.dart';
// or: import 'package:flutter_core_common/flutter_core_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterCore.init(
    FlutterCoreConfig(
      useBearerToken: true,
      colorSchemeSeed: const Color(0xFF6750A4),
      languages: const [
        LanguageModel(languageCode: 'km', countryCode: 'KH', title: 'ភាសារខ្មែរ'),
        LanguageModel(languageCode: 'en', countryCode: 'US', title: 'English'),
      ],
    ),
  );

  runApp(const MyApp());
  FlutterCore.configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return XMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
      ],
    );
  }
}
```

Requires Flutter **3.47** / Dart **3.13**.

```sh
cd example && flutter run
cd example && flutter run -d chrome
```

Add iOS photo/camera usage descriptions if you use `ProfilePicture`.
