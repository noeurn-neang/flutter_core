import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterCore.init(
    FlutterCoreConfig(
      useBearerToken: true,
      languages: const [
        LanguageModel(
          languageCode: 'en',
          countryCode: 'US',
          title: 'English',
        ),
        LanguageModel(
          languageCode: 'km',
          countryCode: 'KH',
          title: 'ភាសារខ្មែរ',
        ),
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
      title: 'flutter_core example',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.put(BaseSettingsController());
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_core')),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.marginLarge),
        children: [
          const CircleImage(
            radius: 36,
            imageUrl: 'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
          ),
          Dimens.vml,
          Obx(
            () => SwitchListTile(
              title: const Text('Dark mode'),
              value: settings.isDarkMode.value,
              onChanged: (_) => settings.handleChangeThemeMode(),
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Obx(() => Text(settings.locale.value)),
            onTap: settings.handleChangeLanguage,
          ),
          Dimens.vml,
          FilledButton(
            onPressed: () {
              showMessage('Saved');
            },
            child: const Text('Snack success'),
          ),
          Dimens.vmm,
          FilledButton.tonal(
            onPressed: () async {
              final ok = await showCoreConfirm(
                context,
                title: 'Confirm',
                desc: 'Looks like Material 3?',
              );
              if (ok == true && context.mounted) {
                showMessage('Confirmed');
              }
            },
            child: const Text('Confirm dialog'),
          ),
          Dimens.vml,
          DatePickerTextField(
            title: 'Date',
            controller: TextEditingController(),
          ),
        ],
      ),
    );
  }
}
