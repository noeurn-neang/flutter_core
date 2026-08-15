import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import 'demo_api.dart';
import 'demo_auth.dart';
import 'example_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterCore.init(
    FlutterCoreConfig(
      useBearerToken: true,
      colorSchemeSeed: const Color(0xFF6750A4),
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

  Get.put(BaseSettingsController());
  Get.put(DemoAuthManager());
  runApp(const MyApp());
  FlutterCore.configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<BaseSettingsController>();
    return Obx(
      () => XMaterialApp(
        title: 'flutter_core',
        translationsKeys: exampleTranslations,
        themeMode:
            settings.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const CatalogPage()),
        ],
      ),
    );
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage>
    with FormValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'dev@example.com');
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _country = SelectOptionController();
  final _fruit = SelectOptionController();
  XFile? _picked;
  String? _apiName;

  static const _avatarUrl = 'https://i.pravatar.cc/200?img=12';

  late final BaseSettingsController settings;
  late final DemoAuthManager auth;
  late final DemoRepository api;

  @override
  void initState() {
    super.initState();
    settings = Get.find<BaseSettingsController>();
    auth = Get.find<DemoAuthManager>();
    api = DemoRepository();
  }

  @override
  void dispose() {
    _email.dispose();
    _date.dispose();
    _time.dispose();
    _country.dispose();
    _fruit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_core'),
          actions: [
            Obx(
              () => IconButton(
                tooltip: 'Theme',
                onPressed: settings.handleChangeThemeMode,
                icon: Icon(
                  settings.isDarkMode.value
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Language',
              onPressed: settings.handleChangeLanguage,
              icon: const Icon(Icons.language),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'App'),
              Tab(text: 'Forms'),
              Tab(text: 'Media'),
              Tab(text: 'Session'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _pad(_appTab(context)),
            _pad(_formsTab()),
            _pad(_mediaTab(context)),
            _pad(_sessionTab()),
          ],
        ),
      ),
    );
  }

  Widget _pad(Widget child) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.marginLarge),
      children: [child],
    );
  }

  Widget _appTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme, locale, dialogs, snacks',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Dimens.vmm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => showMessage('Saved'),
              child: const Text('Success'),
            ),
            FilledButton.tonal(
              onPressed: () => showMessage('Failed', isError: true),
              child: const Text('Error'),
            ),
            OutlinedButton(
              onPressed: () async {
                final ok = await showCoreConfirm(
                  context,
                  title: 'Confirm'.tr,
                  desc: 'Remove this item?',
                );
                if (ok == true) showMessage('Removed');
              },
              child: const Text('Confirm'),
            ),
            OutlinedButton(
              onPressed: () async {
                showLoading();
                await Future<void>.delayed(const Duration(milliseconds: 800));
                hideLoading();
              },
              child: const Text('Loading'),
            ),
            OutlinedButton(
              onPressed: () {
                DialogUtils.showSelection(
                  context,
                  const [
                    SelectionItem(id: 'a', name: 'Option A'),
                    SelectionItem(id: 'b', name: 'Option B'),
                  ],
                  title: 'Pick one',
                  onItemSelected: (id) => showMessage(id),
                );
              },
              child: const Text('Sheet'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formsTab() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: CoreValidators.email,
          ),
          Dimens.vmm,
          DatePickerTextField(title: 'Date', controller: _date),
          Dimens.vmm,
          TimePickerTextField(title: 'Time', controller: _time),
          Dimens.vmm,
          SelectOption(
            title: 'Country',
            type: SelectOptionDataType.country,
            controller: _country,
          ),
          Dimens.vmm,
          SelectOption(
            title: 'Fruit',
            controller: _fruit,
            items: const [
              {'label': 'Mango', 'code': 'mango'},
              {'label': 'Banana', 'code': 'banana'},
            ],
          ),
          Dimens.vml,
          FilledButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                showMessage('OK');
              }
            },
            child: const Text('Validate'),
          ),
        ],
      ),
    );
  }

  Widget _mediaTab(BuildContext context) {
    return Column(
      children: [
        ProfilePicture(
          imageUrl: _picked == null ? _avatarUrl : null,
          size: 48,
          onImagePicked: (file) {
            setState(() => _picked = file);
            showMessage(file.name);
          },
        ),
        TextButton(
          onPressed: () => previewImage(context: context, imageUrl: _avatarUrl),
          child: const Text('Preview'),
        ),
        if (!kIsWeb)
          TextButton(
            onPressed: () => downloadImage(_avatarUrl),
            child: const Text('Save to gallery'),
          ),
      ],
    );
  }

  Widget _sessionTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            auth.isLoggedIn.value
                ? auth.user.value?.email ?? ''
                : 'Signed out',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Dimens.vmm,
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              onPressed: () => auth.login(
                token: 'demo-token',
                user: {'id': 1, 'email': 'dev@example.com'},
              ),
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              onPressed: auth.logOut,
              child: const Text('Sign out'),
            ),
            OutlinedButton(
              onPressed: () async {
                showLoading();
                final response = await api.fetchUser();
                hideLoading();
                if (response.hasError) {
                  handleRequestError(response);
                  return;
                }
                final body = response.body;
                setState(() {
                  _apiName = body is Map ? '${body['name']}' : '$body';
                });
              },
              child: const Text('GET user'),
            ),
          ],
        ),
        if (_apiName != null) ...[
          Dimens.vmm,
          Text(_apiName!),
        ],
      ],
    );
  }
}
