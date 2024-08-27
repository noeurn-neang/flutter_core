# Get start
  ## 1. Create project
  ```sh
  flutter create --org com.neang.app.lottery --platforms=android,ios lotteryapp
  ```
  ## 2. Enable code lint
  Open and replace with below `./analysis_options.yaml`
  ```yaml
  include: package:flutter_lints/flutter.yaml

  linter:
  rules:
  - prefer_relative_imports
  ```
  ## 3. Add FlutterCore to project
  Open `pubspec.yml` add below
  ```yaml
  dependencies:
		flutter_core:
			path: '../flutter_core' #Local path
         
			# or

			# git: # GitHub Repo
			#   url: https://github.com/noeurn-neang/flutter_core.git
			#   ref: main
  ```
  ## 4. Update your main.dart to use XMaterialApp
  Open `./lib/main.dart` add below
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Init Application
    await AppConfigs.init();

    runApp(const MyApp());

    // Run Config After App Loaded
    FlutterCore.configLoading();
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return XMaterialApp(
        initialRoute: AppPages.INITIAL,
        initialBinding: AppBinding(),
        getPages: AppPages.routes,
        translationsKeys: AppTranslation.loadTranslateKeys(),
      );
    }
  }
  ```
  ## 4. Add config file api base url and theme
  Add new file `./lib/app/configs/app.dart` add below
  ```dart
  class AppConfigs {
    AppConfigs._();

    static const String baseUrl = 'http://157.230.255.189:5758';
    static const String baseApiUrl = '$baseUrl/api';

    static Future<void> init() async {
      // Init Flutter Core Plugin
      await FlutterCore.initApplication();

      // Http Request Header
      Variables.authHeaderKey = 'Authorizationgrown';

      // Date Format
      Variables.defaultDateFormat = 'y-MM-dd';
      Variables.defaultDateTimeFormat = 'y-MM-dd HH:mm:ss';

      // Translation
      Variables.languages = [
        LanguageModel("km", "kh", "ភាសារខ្មែរ"),
        LanguageModel("en", "us", "English"),
      ];

      // Dark theme data
      Variables.themeDataDark = ThemeData(
        colorSchemeSeed: primaryColor,
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            color: Color.fromARGB(255, 157, 159, 165),
          ),
        ),
      );

      // Light theme data
      Variables.themeDataLight = ThemeData(
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            color: Color.fromARGB(255, 157, 159, 165),
          ),
        ),
      );
    }
  }
  ```
      

# Using Of Image Picker 
1. IOS
   1. Go to <project root>/ios/Runner/Info.plist 
    NSPhotoLibraryUsageDescription
    NSCameraUsageDescription
    NSMicrophoneUsageDescription

