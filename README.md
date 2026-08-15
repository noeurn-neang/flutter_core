# flutter_core

GetX bootstrap library: theme, locale, storage, HTTP, forms, and (on `main`) avatar update / image picker.

## Git branches

| `ref` | What you get |
|---|---|
| `main` (default, **full**) | Common + camera/gallery, update avatar, PhotoView, country list |
| `common` (**basic**) | Theme, locale, storage, HTTP, auth base, forms, avatar **display** only |

```yaml
dependencies:
  flutter_core:
    git:
      url: https://github.com/noeurn-neang/flutter_core.git
      ref: main      # full
      # ref: common  # basic
```

Or a local path:

```yaml
dependencies:
  flutter_core:
    path: ../flutter_core
```

Shared fixes land on `common`, then merge into `main`. Picker/avatar-update commits stay on `main` only.

## Quick start

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterCore.init(
    FlutterCoreConfig(
      authHeaderKey: 'Authorization',
      useBearerToken: true,
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

On `main`, add iOS photo/camera usage descriptions if you use `ProfilePicture`.
