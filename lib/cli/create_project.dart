#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart create_project.dart <path_to_project_template.json>');
    exit(1);
  }

  final templatePath = args[0];
  final templateFile = File(templatePath);

  if (!templateFile.existsSync()) {
    print('Error: Template file not found: $templatePath');
    exit(1);
  }

  try {
    final templateJson = jsonDecode(templateFile.readAsStringSync());
    final project = ProjectGenerator(templateJson);
    await project.generate();
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

class ProjectGenerator {
  final Map<String, dynamic> config;
  late final String projectName;
  late final String projectPath;
  late final String bundleId;
  late final String displayName;
  String? firebaseProjectId; // Store Firebase project ID for later use

  late final List<String> platforms;

  ProjectGenerator(this.config) {
    final project = config['project'] as Map<String, dynamic>;
    projectName = project['name'] as String;
    bundleId = project['bundleId'] as String;
    displayName = project['displayName'] as String;
    platforms =
        (project['platforms'] as List<dynamic>?)?.cast<String>() ??
        ['android', 'ios'];
    projectPath = path.absolute(projectName);
  }

  Future<void> generate() async {
    print('🚀 Creating Flutter project: $projectName');
    print('');

    // Check all requirements first
    await _checkRequirements();

    // Create Flutter project
    await _createFlutterProject();

    // Generate project structure
    await _createDirectoryStructure();

    // Generate Dart files
    await _generateDartFiles();

    // Update pubspec.yaml
    await _updatePubspec();

    // Generate analysis_options.yaml
    await _generateAnalysisOptions();

    // Update Android configuration (if platform enabled)
    if (platforms.contains('android')) {
      await _updateAndroidConfig();
    }

    // Update iOS configuration (if platform enabled)
    if (platforms.contains('ios')) {
      await _updateIOSConfig();
    }

    // Copy Firebase config files if they exist (only for enabled platforms)
    await _copyFirebaseConfigs();

    // Run flutter pub get
    await _runFlutterPubGet();

    // Create Firebase project if needed
    await _createFirebaseProject();

    // Run flutterfire configure
    await _runFlutterfireConfigure();

    print('\n✨ Project structure created!');
    print('\n📋 Next steps:');
    print('1. cd $projectName');
    print('2. Start developing!');
  }

  Future<void> _checkRequirements() async {
    print('🔍 Checking requirements...');

    // Check Flutter
    bool flutterAvailable = false;
    String? flutterVersion;
    try {
      final flutterCheck = await Process.run(
        'flutter',
        ['--version'],
        runInShell: true,
      );
      if (flutterCheck.exitCode == 0) {
        flutterAvailable = true;
        final lines = flutterCheck.stdout.toString().split('\n');
        flutterVersion = lines.isNotEmpty ? lines[0].trim() : 'unknown';
        print('✓ Flutter found: $flutterVersion');
      }
    } catch (e) {
      // Flutter not found
    }

    if (!flutterAvailable) {
      print('\n❌ ERROR: Flutter is not installed or not in PATH!');
      print('');
      print('Required: Flutter SDK must be installed and accessible.');
      print('');
      print('To fix this:');
      print('  1. Install Flutter: https://docs.flutter.dev/get-started/install');
      print('  2. Add Flutter to your PATH');
      print('  3. Verify installation:');
      print('     flutter --version');
      print('  4. Then run this CLI again.');
      print('');
      throw Exception(
        'Flutter not found. Please install Flutter: https://docs.flutter.dev/get-started/install',
      );
    }

    // Check Dart (usually comes with Flutter)
    bool dartAvailable = false;
    String? dartVersion;
    try {
      final dartCheck = await Process.run(
        'dart',
        ['--version'],
        runInShell: true,
      );
      if (dartCheck.exitCode == 0) {
        dartAvailable = true;
        dartVersion = dartCheck.stdout.toString().trim();
        print('✓ Dart found: $dartVersion');
      }
    } catch (e) {
      // Dart not found
    }

    if (!dartAvailable) {
      print('\n❌ ERROR: Dart is not installed or not in PATH!');
      print('');
      print('Required: Dart SDK must be installed and accessible.');
      print('');
      print('To fix this:');
      print('  1. Dart usually comes with Flutter');
      print('  2. Verify Flutter installation includes Dart');
      print('  3. Or install Dart separately: https://dart.dev/get-dart');
      print('  4. Verify installation:');
      print('     dart --version');
      print('  5. Then run this CLI again.');
      print('');
      throw Exception(
        'Dart not found. Please install Dart or ensure Flutter is properly installed.',
      );
    }

    print('');
  }

  Future<void> _createFlutterProject() async {
    print('📦 Creating Flutter project...');
    print('   Platforms: ${platforms.join(", ")}');

    // Clean up existing project directory if it exists (from previous failed runs)
    final projectDir = Directory(projectPath);
    if (projectDir.existsSync()) {
      print('   Cleaning up existing project directory...');
      projectDir.deleteSync(recursive: true);
    }

    final args = [
      'create',
      '--org',
      'com.direxme.app',
      '--project-name',
      projectName,
    ];

    // Add platforms flag if specified
    if (platforms.isNotEmpty) {
      args.addAll(['--platforms', platforms.join(',')]);
    }

    args.add(projectName);

    final process = await Process.start('flutter', args, runInShell: true);

    await process.stdout.transform(utf8.decoder).forEach(print);
    await process.stderr.transform(utf8.decoder).forEach(print);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception('Failed to create Flutter project');
    }
  }

  Future<void> _createDirectoryStructure() async {
    print('📁 Creating directory structure...');
    final dirs = [
      'lib/app/configs',
      'lib/app/constants',
      'lib/app/models',
      'lib/app/modules/auth/login',
      'lib/app/modules/auth/register',
      'lib/app/modules/main',
      'lib/app/modules/splash',
      'lib/app/routes',
      'lib/app/translation',
      'lib/app/locales',
      'lib/app/network',
      'lib/app/utils',
      'lib/app/services',
      'lib/app/components/ads',
      'lib/app/components/buttons/socials',
      'lib/app/components/setting',
      'assets/images',
    ];

    for (final dir in dirs) {
      final dirPath = path.join(projectPath, dir);
      Directory(dirPath).createSync(recursive: true);
    }
  }

  Future<void> _generateDartFiles() async {
    print('📝 Generating Dart files...');

    await _writeFile('lib/main.dart', _generateMainDart());
    await _writeFile('lib/firebase_options.dart', _generateFirebaseOptions());
    await _writeFile('lib/app/app_binding.dart', _generateAppBinding());
    await _writeFile('lib/app/auth_manager.dart', _generateAuthManager());
    await _writeFile('lib/app/configs/app.dart', _generateAppConfig());
    await _writeFile('lib/app/constants/theme.dart', _generateTheme());
    await _writeFile(
      'lib/app/constants/login_types.dart',
      _generateLoginTypes(),
    );
    await _writeFile('lib/app/routes/app_routes.dart', _generateAppRoutes());
    await _writeFile('lib/app/routes/app_pages.dart', _generateAppPages());
    await _writeFile(
      'lib/app/translation/translation.dart',
      _generateTranslation(),
    );
    await _writeFile(
      'lib/app/modules/splash/splash_view.dart',
      _generateSplashView(),
    );
    await _writeFile(
      'lib/app/modules/main/main_view.dart',
      _generateMainView(),
    );
    await _writeFile(
      'lib/app/modules/main/main_binding.dart',
      _generateMainBinding(),
    );
    await _writeFile(
      'lib/app/modules/auth/auth_view.dart',
      _generateAuthView(),
    );
    await _writeFile(
      'lib/app/modules/auth/auth_controller.dart',
      _generateAuthController(),
    );
    await _writeFile(
      'lib/app/modules/auth/auth_binding.dart',
      _generateAuthBinding(),
    );
    await _writeFile('lib/app/models/user_model.dart', _generateUserModel());
    await _writeFile(
      'lib/app/network/api_provider.dart',
      _generateApiProvider(),
    );
    await _writeFile(
      'lib/app/network/api_repository.dart',
      _generateApiRepository(),
    );
    await _writeFile(
      'lib/app/locales/english_keys.dart',
      _generateEnglishKeys(),
    );
    await _writeFile(
      'lib/app/services/admob_service.dart',
      _generateAdMobService(),
    );
    await _writeFile('lib/app/services/ad_manager.dart', _generateAdManager());
    await _writeFile(
      'lib/app/components/common.dart',
      _generateCommonComponents(),
    );
    await _writeFile('lib/app/components/my_app_bar.dart', _generateMyAppBar());
    await _writeFile(
      'lib/app/components/ads/banner_ads.dart',
      _generateBannerAds(),
    );
    await _writeFile(
      'lib/app/constants/common.dart',
      _generateCommonConstants(),
    );
    await _writeFile('lib/app/utils/common_utils.dart', _generateCommonUtils());
    await _writeFile('lib/app/utils/view_utils.dart', _generateViewUtils());
    await _writeFile(
      'lib/app/components/setting/setting_group.dart',
      _generateSettingGroup(),
    );
    await _writeFile(
      'lib/app/components/setting/setting_item.dart',
      _generateSettingItem(),
    );
  }

  Future<void> _updatePubspec() async {
    print('📄 Updating pubspec.yaml...');
    final pubspecPath = path.join(projectPath, 'pubspec.yaml');
    final pubspecFile = File(pubspecPath);
    var content = pubspecFile.readAsStringSync();

    // Update name
    content = content.replaceFirst(
      RegExp(r'^name: .*', multiLine: true),
      'name: $projectName',
    );

    // Update description
    content = content.replaceFirst(
      RegExp(r'^description: .*', multiLine: true),
      'description: ${config['project']['description']}',
    );

    // Add dependencies
    final flutterCoreBranch = config['flutter_core']?['branch'] as String? ?? 'main';
    
    // Check if dependencies already exist (avoid duplicates)
    if (content.contains('flutter_core:')) {
      print('  ⚠ Dependencies already exist, skipping...');
    } else {
      // Insert dependencies after cupertino_icons (which Flutter creates by default)
      // This ensures proper YAML structure
      final additionalDependencies = '''

  flutter_core:
    git:
      url: https://github.com/noeurn-neang/flutter_core.git
      ref: $flutterCoreBranch
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  google_sign_in: ^6.2.1
  font_awesome_flutter: ^10.6.0
  url_launcher: ^6.1.14
  share_plus: ^7.2.1
  google_mobile_ads: ^6.0.0
  sign_in_with_apple: ^6.1.2''';

      // Find cupertino_icons and insert after it
      // Pattern matches: "  cupertino_icons: ^X.X.X" followed by newline
      final cupertinoPattern = RegExp(r'(  cupertino_icons:\s+[^\n]+\n)');
      if (cupertinoPattern.hasMatch(content)) {
        final match = cupertinoPattern.firstMatch(content);
        if (match != null) {
          final matchedText = match.group(0)!;
          content = content.replaceFirst(
            cupertinoPattern,
            matchedText + additionalDependencies + '\n',
          );
        }
      } else {
        // Fallback: insert after flutter: sdk: flutter
        final flutterPattern = RegExp(r'(  flutter:\s+sdk: flutter\s*\n)');
        if (flutterPattern.hasMatch(content)) {
          final match = flutterPattern.firstMatch(content);
          if (match != null) {
            final matchedText = match.group(0)!;
            content = content.replaceFirst(
              flutterPattern,
              matchedText + additionalDependencies + '\n',
            );
          }
        }
      }
    }

    // Add assets section
    final assets = config['assets'] as Map<String, dynamic>;
    final images = (assets['images'] as List).map((e) => '    - $e').join('\n');

    if (!content.contains('assets:')) {
      content = content.replaceFirst(
        RegExp(r'(uses-material-design: true)'),
        r'$1\n\n  assets:\n$images',
      );
    }

    pubspecFile.writeAsStringSync(content);
  }

  Future<void> _generateAnalysisOptions() async {
    print('📋 Generating analysis_options.yaml...');
    final analysisOptionsPath = path.join(projectPath, 'analysis_options.yaml');
    final content = '''include: package:flutter_lints/flutter.yaml

linter:
  rules:
  - prefer_relative_imports
''';
    File(analysisOptionsPath).writeAsStringSync(content);
  }

  Future<void> _updateAndroidConfig() async {
    print('🤖 Updating Android configuration...');

    // Update root build.gradle to add Google Services (only for Groovy DSL)
    // Note: Kotlin DSL projects add the plugin directly in app/build.gradle.kts
    final rootBuildGradlePath = path.join(projectPath, 'android/build.gradle');
    final rootBuildGradleKtsPath = path.join(projectPath, 'android/build.gradle.kts');
    
    // Only update root build.gradle if using Groovy DSL
    if (File(rootBuildGradlePath).existsSync() && !File(rootBuildGradleKtsPath).existsSync()) {
      var rootBuildGradle = File(rootBuildGradlePath).readAsStringSync();

      // Add Google Services classpath if not present
      if (!rootBuildGradle.contains('google-services')) {
        rootBuildGradle = rootBuildGradle.replaceFirst(
          RegExp(r"(dependencies\s*\{)"),
          r'''$1
        // START: FlutterFire Configuration
        classpath 'com.google.gms:google-services:4.4.0'
        // END: FlutterFire Configuration''',
        );
        File(rootBuildGradlePath).writeAsStringSync(rootBuildGradle);
      }
    }
    
    // For Kotlin DSL, we need to add Google Services to settings.gradle.kts or build.gradle.kts
    // But actually, newer Flutter projects add it directly in app/build.gradle.kts plugins block
    // which we already handle above, so no root-level changes needed for Kotlin DSL

    // Update AndroidManifest.xml
    final manifestPath = path.join(
      projectPath,
      'android/app/src/main/AndroidManifest.xml',
    );
    final manifestFile = File(manifestPath);
    var manifest = manifestFile.readAsStringSync();

    // Update package name
    manifest = manifest.replaceAll(
      RegExp(r'package="[^"]*"'),
      'package="$bundleId"',
    );

    // Add AdMob App ID
    final admobAppId = config['admob']['android']['appId'] as String;
    if (!manifest.contains('APPLICATION_ID')) {
      final applicationTag = manifest.contains('</application>')
          ? manifest.split('</application>')[0]
          : manifest;
      manifest = manifest.replaceFirst('</application>', '''\n        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="$admobAppId"/>
    </application>''');
    }

    manifestFile.writeAsStringSync(manifest);

    // Update app build.gradle/build.gradle.kts package name and add optimizations
    final buildGradlePath = path.join(projectPath, 'android/app/build.gradle');
    final buildGradleKtsPath = path.join(projectPath, 'android/app/build.gradle.kts');
    
    // Check for Kotlin DSL first (newer Flutter projects)
    if (File(buildGradleKtsPath).existsSync()) {
      var buildGradle = File(buildGradleKtsPath).readAsStringSync();

      // Update package name
      buildGradle = buildGradle.replaceAll(
        RegExp(r'applicationId\s*=\s*"[^"]*"'),
        'applicationId = "$bundleId"',
      );

      // Update namespace
      buildGradle = buildGradle.replaceAll(
        RegExp(r'namespace\s*=\s*"[^"]*"'),
        'namespace = "$bundleId"',
      );

      // Add Google Services plugin if not present
      if (!buildGradle.contains('google-services')) {
        buildGradle = buildGradle.replaceFirst(
          RegExp(r'(id\("dev\.flutter\.flutter-gradle-plugin"\))'),
          r'''$1
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration''',
        );
      }

      // Add signing configs and release optimizations
      if (!buildGradle.contains('signingConfigs')) {
        // Add signing configs before buildTypes
        final buildTypesMatch = RegExp(r'(buildTypes\s*\{)').firstMatch(buildGradle);
        if (buildTypesMatch != null) {
          buildGradle = buildGradle.replaceFirst(
            RegExp(r'(buildTypes\s*\{)'),
            '''signingConfigs {
        create("release") {
            val keystoreProperties = java.util.Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
            }
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {''',
          );
        }
      }

      // Update release buildType with optimizations
      if (buildGradle.contains('buildTypes') && !buildGradle.contains('minifyEnabled')) {
        buildGradle = buildGradle.replaceFirst(
          RegExp(r'(release\s*\{[^}]*signingConfig\s*=\s*signingConfigs\.getByName\("debug"\)[^}]*\})'),
          '''release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }''',
        );
      } else if (buildGradle.contains('release') && !buildGradle.contains('minifyEnabled')) {
        // Fallback: update existing release block
        buildGradle = buildGradle.replaceFirst(
          RegExp(r'(release\s*\{[^}]*signingConfig\s*=\s*signingConfigs\.getByName\("debug"\)[^}]*\})'),
          '''release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }''',
        );
      }

      File(buildGradleKtsPath).writeAsStringSync(buildGradle);
    } else if (File(buildGradlePath).existsSync()) {
      // Handle Groovy DSL (older projects)
      var buildGradle = File(buildGradlePath).readAsStringSync();

      // Update package name
      buildGradle = buildGradle.replaceAll(
        RegExp(r'applicationId\s+"[^"]*"'),
        'applicationId "$bundleId"',
      );

      // Update namespace
      buildGradle = buildGradle.replaceAll(
        RegExp(r'namespace\s+"[^"]*"'),
        'namespace "$bundleId"',
      );

      // Add Google Services plugin if not present
      if (!buildGradle.contains('google-services')) {
        buildGradle = buildGradle.replaceFirst(
          RegExp(r"(apply plugin: 'com.android.application')"),
          r'''$1
// START: FlutterFire Configuration
apply plugin: 'com.google.gms.google-services'
// END: FlutterFire Configuration''',
        );
      }

      // Add signing configs and release optimizations for Groovy DSL
      if (!buildGradle.contains('signingConfigs')) {
        buildGradle = buildGradle.replaceFirst(
          RegExp(r'(buildTypes\s*\{)'),
          '''signingConfigs {
        release {
            def keystorePropertiesFile = rootProject.file("key.properties")
            def keystoreProperties = new Properties()
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
            }
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {''',
        );
      }

      // Update release buildType with optimizations
      if (buildGradle.contains('buildTypes') && !buildGradle.contains('minifyEnabled')) {
        buildGradle = buildGradle.replaceFirst(
          RegExp(r'(release\s*\{[^}]*signingConfig\s*signingConfigs\.debug[^}]*\})'),
          '''release {
            signingConfig signingConfigs.release
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }''',
        );
      }

      File(buildGradlePath).writeAsStringSync(buildGradle);
    }

    // Create ProGuard rules file
    final proguardRulesPath = path.join(projectPath, 'android/app/proguard-rules.pro');
    if (!File(proguardRulesPath).existsSync()) {
      final proguardRules = '''# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Google Sign In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
''';
      File(proguardRulesPath).writeAsStringSync(proguardRules);
    }

    // Create key.properties
    final signing = config['android']['signing'] as Map<String, dynamic>;
    final keyPropertiesPath = path.join(projectPath, 'android/key.properties');
    final keyProperties =
        '''storePassword=${signing['storePassword']}
keyPassword=${signing['keyPassword']}
keyAlias=${signing['keyAlias']}
storeFile=${signing['storeFile']}
''';
    File(keyPropertiesPath).writeAsStringSync(keyProperties);

    // Update strings.xml with app name
    final stringsXmlPath = path.join(
      projectPath,
      'android/app/src/main/res/values/strings.xml',
    );
    if (File(stringsXmlPath).existsSync()) {
      var stringsXml = File(stringsXmlPath).readAsStringSync();
      stringsXml = stringsXml.replaceAll(
        RegExp(r'<string name="app_name">[^<]*</string>'),
        '<string name="app_name">$displayName</string>',
      );
      File(stringsXmlPath).writeAsStringSync(stringsXml);
    }
  }

  Future<void> _updateIOSConfig() async {
    print('🍎 Updating iOS configuration...');

    // Update Podfile to specify iOS platform version
    final podfilePath = path.join(projectPath, 'ios/Podfile');
    final podfileFile = File(podfilePath);
    if (podfileFile.existsSync()) {
      var podfile = podfileFile.readAsStringSync();
      // Uncomment platform line if it's commented
      if (podfile.contains('# platform :ios')) {
        podfile = podfile.replaceFirst(
          '# platform :ios',
          'platform :ios',
        );
      }
      // Also handle if it's commented with quotes
      if (podfile.contains("# platform :ios, '13.0'")) {
        podfile = podfile.replaceFirst(
          "# platform :ios, '13.0'",
          "platform :ios, '13.0'",
        );
      }
      podfileFile.writeAsStringSync(podfile);
    }

    // Update Info.plist
    final infoPlistPath = path.join(projectPath, 'ios/Runner/Info.plist');
    final infoPlistFile = File(infoPlistPath);
    if (infoPlistFile.existsSync()) {
      var infoPlist = infoPlistFile.readAsStringSync();

      // Update bundle identifier
      infoPlist = infoPlist.replaceAll(
        RegExp(r'\$\{PRODUCT_BUNDLE_IDENTIFIER\}'),
        bundleId,
      );

      // Add AdMob App ID
      final admobAppId = config['admob']['ios']['appId'] as String;
      if (!infoPlist.contains('GADApplicationIdentifier')) {
        infoPlist = infoPlist.replaceFirst(
          '</dict>',
          '''\t<key>GADApplicationIdentifier</key>
\t<string>$admobAppId</string>
</dict>''',
        );
      }

      infoPlistFile.writeAsStringSync(infoPlist);
    }
  }

  Future<void> _runFlutterPubGet() async {
    print('\n📦 Running flutter pub get...');
    final process = await Process.start(
      'flutter',
      ['pub', 'get'],
      workingDirectory: projectPath,
      runInShell: true,
    );

    await process.stdout.transform(utf8.decoder).forEach(print);
    await process.stderr.transform(utf8.decoder).forEach(print);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      print(
        '⚠️  Warning: flutter pub get failed. You may need to run it manually.',
      );
    } else {
      print('✓ Dependencies installed successfully');
    }
  }

  Future<void> _createFirebaseProject() async {
    print('\n🔥 Checking Firebase requirements...');

    // Check if Firebase CLI is available
    bool firebaseCliAvailable = false;
    try {
      final firebaseCheck = await Process.run(
        'firebase',
        ['--version'],
        runInShell: true,
      );
      if (firebaseCheck.exitCode == 0) {
        firebaseCliAvailable = true;
        final version = firebaseCheck.stdout.toString().trim();
        print('✓ Firebase CLI found: $version');
      }
    } catch (e) {
      // Firebase CLI not found
    }

    if (!firebaseCliAvailable) {
      print('\n❌ ERROR: Firebase CLI is not installed!');
      print('');
      print('Required: Firebase CLI must be installed to create Firebase projects automatically.');
      print('');
      print('To fix this:');
      print('  1. Install Firebase CLI:');
      print('     npm install -g firebase-tools');
      print('');
      print('  2. Verify installation:');
      print('     firebase --version');
      print('');
      print('  3. Then run this CLI again.');
      print('');
      throw Exception(
        'Firebase CLI not found. Please install it with: npm install -g firebase-tools',
      );
    }

    // Check if user is logged in
    bool isLoggedIn = false;
    String? loggedInEmail;
    try {
      final loginCheck = await Process.run(
        'firebase',
        ['login:list'],
        runInShell: true,
      );
      if (loginCheck.exitCode == 0) {
        final output = loginCheck.stdout.toString();
        // Check if there's an email in the output (logged in users show email)
        final emailMatch = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+').firstMatch(output);
        if (emailMatch != null) {
          isLoggedIn = true;
          loggedInEmail = emailMatch.group(0);
          print('✓ Firebase login verified: $loggedInEmail');
        }
      }
    } catch (e) {
      // Error checking login status
    }

    if (!isLoggedIn) {
      print('\n❌ ERROR: Not logged in to Firebase!');
      print('');
      print('Required: You must be logged in to Firebase to create projects automatically.');
      print('');
      print('To fix this:');
      print('  1. Login to Firebase:');
      print('     firebase login');
      print('');
      print('  2. This will open a browser for authentication.');
      print('');
      print('  3. After successful login, run this CLI again.');
      print('');
      throw Exception(
        'Not logged in to Firebase. Please run: firebase login',
      );
    }

    // Generate Firebase project ID from project name
    // Firebase project IDs: lowercase, alphanumeric, hyphens, 6-30 chars
    String firebaseProjectId = projectName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9-]'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    // Ensure it's within Firebase's limits
    if (firebaseProjectId.length < 6) {
      firebaseProjectId = '${firebaseProjectId}${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6 - firebaseProjectId.length)}';
    }
    if (firebaseProjectId.length > 30) {
      firebaseProjectId = firebaseProjectId.substring(0, 30);
    }

    // Check if project already exists
    try {
      final listCheck = await Process.run(
        'firebase',
        ['projects:list'],
        runInShell: true,
      );
      if (listCheck.exitCode == 0) {
        final output = listCheck.stdout.toString();
        // Check if project ID exists in the list
        if (output.contains(firebaseProjectId)) {
          print('✓ Firebase project already exists: $firebaseProjectId');
          // Store the project ID for later use
          this.firebaseProjectId = firebaseProjectId;
          return;
        }
      }
    } catch (e) {
      // Continue to try creating
    }

    // Create Firebase project
    print('📦 Creating Firebase project: $firebaseProjectId');
    print('   Display name: $displayName');
    try {
      // Use Process.run to capture output and check for "already exists" error
      final createResult = await Process.run(
        'firebase',
        [
          'projects:create',
          firebaseProjectId,
          '--display-name',
          displayName,
        ],
        runInShell: true,
      );

      if (createResult.exitCode == 0) {
        print('✓ Firebase project created successfully: $firebaseProjectId');
        // Store the project ID for later use
        this.firebaseProjectId = firebaseProjectId;
      } else {
        // Check if error is because project already exists
        final errorOutput = createResult.stderr.toString() + createResult.stdout.toString();
        if (errorOutput.contains('already exists') ||
            errorOutput.contains('already a project') ||
            errorOutput.contains('Please try again with a unique project ID')) {
          print('✓ Firebase project already exists: $firebaseProjectId');
          // Store the project ID for later use
          this.firebaseProjectId = firebaseProjectId;
        } else {
          // Other error occurred - still try to use the project ID
          print('⚠️  Project creation failed, but will try to use project ID: $firebaseProjectId');
          print('   Error: ${errorOutput.split('\n').first}');
          // Assume project exists and use it (user can verify in flutterfire configure)
          this.firebaseProjectId = firebaseProjectId;
        }
      }
    } catch (e) {
      print('⚠️  Error creating Firebase project: $e');
      print('   You can create it manually at: https://console.firebase.google.com/');
    }
  }

  Future<void> _runFlutterfireConfigure() async {
    print('\n🔥 Running flutterfire configure...');
    print(
      '   (This will generate firebase_options.dart with your Firebase config)',
    );

    // Check if flutterfire CLI is installed
    bool hasFlutterfire = false;
    try {
      final flutterfireCheck = await Process.run('dart', [
        'pub',
        'global',
        'list',
      ], runInShell: true);

      hasFlutterfire = flutterfireCheck.stdout.toString().contains(
        'flutterfire_cli',
      );
    } catch (e) {
      // Error checking
    }

    if (!hasFlutterfire) {
      print('📥 Installing FlutterFire CLI...');
      final installProcess = await Process.start('dart', [
        'pub',
        'global',
        'activate',
        'flutterfire_cli',
      ], runInShell: true);

      await installProcess.stdout.transform(utf8.decoder).forEach(print);
      await installProcess.stderr.transform(utf8.decoder).forEach(print);

      final installExitCode = await installProcess.exitCode;
      if (installExitCode != 0) {
        print('\n❌ ERROR: Failed to install FlutterFire CLI!');
        print('');
        print('Required: FlutterFire CLI must be installed to configure Firebase.');
        print('');
        print('To fix this:');
        print('  1. Install FlutterFire CLI manually:');
        print('     dart pub global activate flutterfire_cli');
        print('');
        print('  2. Verify installation:');
        print('     dart pub global list');
        print('');
        print('  3. Then run flutterfire configure manually:');
        print('     flutterfire configure');
        print('');
        throw Exception(
          'Failed to install FlutterFire CLI. Please run: dart pub global activate flutterfire_cli',
        );
      }
      print('✓ FlutterFire CLI installed');
    } else {
      print('✓ FlutterFire CLI found');
    }

    // Run flutterfire configure automatically
    // Use --yes to auto-detect platforms and skip confirmations
    final flutterfireArgs = <String>['configure', '--yes'];
    
    if (firebaseProjectId != null) {
      print('   Using Firebase project: $firebaseProjectId');
      flutterfireArgs.addAll(['--project', firebaseProjectId!]);
    } else {
      print('   Auto-detecting Firebase project...');
      print('   (If multiple projects exist, you may need to select one)');
    }

    print('   Auto-configuring Firebase for platforms: ${platforms.join(", ")}');
    
    final process = await Process.start(
      'flutterfire',
      flutterfireArgs,
      workingDirectory: projectPath,
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      print('\n⚠️  Warning: flutterfire configure failed or was cancelled.');
      if (firebaseProjectId != null) {
        print('   Project ID was: $firebaseProjectId');
        print('   You can run it manually:');
        print('     cd $projectName');
        print('     flutterfire configure --yes --project $firebaseProjectId');
      } else {
        print('   You can run it manually:');
        print('     cd $projectName');
        print('     flutterfire configure --yes');
      }
      print(
        '   Or manually update firebase_options.dart with your Firebase keys',
      );
    } else {
      print('\n✓ Firebase configured successfully!');
      print('   firebase_options.dart has been generated with your Firebase keys.');
    }
  }

  Future<void> _copyFirebaseConfigs() async {
    print('🔥 Setting up Firebase configuration...');
    print(
      '   Note: Run "flutterfire configure" after project creation to generate firebase_options.dart',
    );

    final firebase = config['firebase'] as Map<String, dynamic>;
    final cliDir = path.dirname(Platform.script.toFilePath());

    // Copy Android google-services.json (if Android platform enabled)
    if (platforms.contains('android')) {
      final androidConfigPath = firebase['android']['file_path'] as String;
      final androidSource = path.join(cliDir, 'google-services.json');
      if (File(androidSource).existsSync()) {
        final androidDest = path.join(
          projectPath,
          'android/app/google-services.json',
        );
        File(androidSource).copySync(androidDest);
        print('  ✓ Copied Android Firebase config (google-services.json)');
        print(
          '     You can replace this with your own file or use flutterfire configure',
        );
      } else {
        print('  ⚠ Android Firebase config file not found: $androidSource');
        print(
          '     Run "flutterfire configure" to set up Firebase for Android',
        );
      }
    }

    // Copy iOS GoogleService-Info.plist (if iOS platform enabled)
    if (platforms.contains('ios')) {
      final iosConfigPath = firebase['ios']['file_path'] as String;
      final iosSource = path.join(cliDir, 'GoogleService-Info.plist');
      if (File(iosSource).existsSync()) {
        final iosDest = path.join(
          projectPath,
          'ios/Runner/GoogleService-Info.plist',
        );
        File(iosSource).copySync(iosDest);
        print('  ✓ Copied iOS Firebase config (GoogleService-Info.plist)');
        print(
          '     You can replace this with your own file or use flutterfire configure',
        );
      } else {
        print('  ⚠ iOS Firebase config file not found: $iosSource');
        print('     Run "flutterfire configure" to set up Firebase for iOS');
      }
    }
  }

  Future<void> _writeFile(String relativePath, String content) async {
    final filePath = path.join(projectPath, relativePath);
    final file = File(filePath);
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  String _generateMainDart() {
    return '''import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/x_material_app.dart';

import 'app/app_binding.dart';
import 'app/configs/app.dart';
import 'app/routes/app_pages.dart';
import 'app/services/ad_manager.dart';
import 'app/translation/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Application
  await AppConfigs.init();

  // Initialize AdMob
  await AdManager.initialize();

  runApp(const MyApp());

  // Run Config After App Loaded
  FlutterCore.configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
''';
  }

  String _generateFirebaseOptions() {
    final hasAndroid = platforms.contains('android');
    final hasIOS = platforms.contains('ios');

    var androidSection = '';
    var iosSection = '';
    var cases = '';

    if (hasAndroid) {
      androidSection = '''
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );''';
      cases += '      case TargetPlatform.android:\n        return android;\n';
    }

    if (hasIOS) {
      iosSection =
          '''
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: '$bundleId',
  );''';
      cases += '      case TargetPlatform.iOS:\n        return ios;\n';
    }

    return '''// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
//
// NOTE: This file is a placeholder. Run "flutterfire configure" to generate
// the actual Firebase configuration with your project's Firebase settings.
//
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
$cases      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
$androidSection$iosSection
}
''';
  }

  String _generateAppBinding() {
    return '''import 'package:flutter_core/getx.dart';
import 'package:flutter_core/network/base_provider.dart';

import 'configs/app.dart';
import 'network/api_provider.dart';
import 'network/api_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<BaseProvider>(ApiProvider(AppConfigs.baseApiUrl), permanent: true);
    Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
  }
}
''';
  }

  String _generateAuthManager() {
    return '''import 'package:flutter/material.dart';
import 'package:flutter_core/base_auth_manager.dart';
import 'package:flutter_core/getx.dart';

import 'models/user_model.dart';
import 'routes/app_pages.dart';

class AuthManager extends BaseAuthManager {
  final user = UserModel().obs;

  void showRequiredLogin({VoidCallback? callback}) {
    Get.offAllNamed(Routes.AUTH);
  }

  @override
  void login(Map<String, dynamic> response) {
    var tokenStr = response['token'];
    setAuthState(response);
    saveToCache(tokenStr, response);
    redirectAfterLoggedIn();
  }

  @override
  void redirectAfterLoggedIn() {
    Get.offAllNamed(Routes.MAIN);
  }

  @override
  void redirectAfterLoggedOut() {
    Get.offAllNamed(Routes.AUTH);
  }

  @override
  void setAuthState(userJson) {
    user.value = UserModel.fromJson(userJson);
  }

  @override
  void removeAuthState() {
    user.value.id = null;
  }

  bool get isLoggedIn => user.value.id != null;
}
''';
  }

  String _generateAppConfig() {
    final app = config['app'] as Map<String, dynamic>;
    return '''import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/configs/variables.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/models/language_model.dart';

import '../../firebase_options.dart';
import '../constants/theme.dart';

class AppConfigs {
  AppConfigs._();

  static const String baseUrl = '${app['baseUrl']}';
  static const String baseApiUrl = '${app['baseApiUrl']}';

  static const String defaultPassword = '${app['defaultPassword']}';

  static Future<void> init() async {
    // Init Flutter Core Plugin
    await FlutterCore.initApplication();

    // Init Firebase (only if configured)
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      // Check if Firebase options are configured (not placeholders)
      if (options.apiKey != 'YOUR_ANDROID_API_KEY' &&
          options.apiKey != 'YOUR_IOS_API_KEY' &&
          options.appId != 'YOUR_ANDROID_APP_ID' &&
          options.appId != 'YOUR_IOS_APP_ID') {
        await Firebase.initializeApp(
          options: options,
        );
      } else {
        print('⚠️  Firebase not configured. Run "flutterfire configure" to set up Firebase.');
      }
    } catch (e) {
      print('⚠️  Firebase initialization failed: \$e');
      print('   Run "flutterfire configure" to set up Firebase properly.');
    }

    // Http Request Header
    Variables.authHeaderKey = '${app['authHeaderKey']}';

    // Translation
    Variables.languages = [
      LanguageModel("en", "us", "English"),
    ];

    // Theme Data
    Variables.themeDataDark = ThemeData(
      colorSchemeSeed: ColorSeed.indigo.color,
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    Variables.themeDataLight = ThemeData(
      colorSchemeSeed: ColorSeed.indigo.color,
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }
}
''';
  }

  String _generateTheme() {
    return '''import 'package:flutter/material.dart';

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Color(0xff029642)),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}
''';
  }

  String _generateLoginTypes() {
    return '''enum LoginType {
  google,
  apple,
  facebook,
}
''';
  }

  String _generateAppRoutes() {
    return '''part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const MAIN = _Paths.MAIN;
  static const AUTH = _Paths.AUTH;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const MAIN = '/main';
  static const AUTH = '/auth';
}
''';
  }

  String _generateAppPages() {
    return '''import 'package:flutter_core/getx.dart';

    import '../modules/splash/splash_view.dart';
    import '../modules/main/main_view.dart';
    import '../modules/main/main_binding.dart';
    import '../modules/auth/auth_view.dart';
    import '../modules/auth/auth_binding.dart';

    part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
  ];
}
''';
  }

  String _generateTranslation() {
    return '''import '../locales/english_keys.dart';

class AppTranslation {
  static Map<String, Map<String, String>> loadTranslateKeys() {
    return {
      "en_US": getEnglishKeys(),
    };
  }
}
''';
  }

  String _generateSplashView() {
    return '''import 'package:flutter/material.dart';
    import 'package:flutter/services.dart';
    import 'package:flutter_core/getx.dart';

    import '../../auth_manager.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key}) {
    Get.put(AuthManager(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Center(
          child: Text(
            '$displayName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
''';
  }

  String _generateUserModel() {
    return '''class UserModel {
  int? id;
  String? userName;
  String? email;
  String? fullName;
  String? tel;
  String? photoURL;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.fullName,
    this.tel,
    this.photoURL,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    fullName = json['fullName'];
    tel = json['tel'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['email'] = email;
    data['fullName'] = fullName;
    data['tel'] = tel;
    data['photoURL'] = photoURL;
    return data;
  }
}
''';
  }

  String _generateApiProvider() {
    return '''import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_core/getx.dart';
import 'package:flutter_core/network/base_provider.dart';
import 'package:flutter_core/utils/message_utils.dart';

import '../auth_manager.dart';

class ApiProvider extends BaseProvider {
  ApiProvider(super.baseApiUrl);

  @override
  FutureOr responseInterceptor(Request request, Response response) async {
    var body = jsonDecode(response.body);
    if (body['error'] != null && body['status'] == 'Token Expired') {
      showMessage('Token expired!'.tr, isError: true);

      await FirebaseAuth.instance.signOut();
      final AuthManager authManager = Get.find();
      authManager.logOut();
    }

    return super.responseInterceptor(request, response);
  }
}
''';
  }

  String _generateApiRepository() {
    return '''import 'package:flutter_core/network/api.dart';
    import 'package:flutter_core/utils/string_utils.dart';

class ApiRepository extends BaseApiRepository {
  ApiRepository({required super.apiProvider});

  // Login
  Future<dynamic> login(String user, String password) async {
    return base({'user': user, 'pwd': StringUtils.encryptMd5(password)});
  }
}
''';
  }

  String _generateEnglishKeys() {
    return '''getEnglishKeys() {
  return {
    "Settings": "Settings",
    "User Info": "User Info",
    "Logout": "Logout",
    "Cancel": "Cancel",
    "Confirm": "Confirm",
    "Success": "Success",
    "Error": "Error",
    "Loading...": "Loading...",
    "Get Start": "Get Start",
    "Skip": "Skip",
    "Or": "Or",
    "Login Via Email": "Login Via Email",
    "welcome_message": "Welcome to $displayName",
    "social_signin_message": "Sign up or sign in via",
  };
}
''';
  }

  String _generateMainView() {
    return '''import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$displayName'),
      ),
      body: const Center(
        child: Text('Main View'),
      ),
    );
  }
}
''';
  }

  String _generateMainBinding() {
    return '''import 'package:flutter_core/getx.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Add your main module dependencies here
  }
}
''';
  }

  String _generateAuthView() {
    return '''import 'package:flutter/material.dart';
    import 'package:flutter_core/getx.dart';

    import 'auth_controller.dart';
    import '../../routes/app_pages.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Auth View'),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.MAIN);
              },
              child: const Text('Go to Main'),
            ),
          ],
        ),
      ),
    );
  }
}
''';
  }

  String _generateAuthController() {
    return '''import 'package:flutter_core/getx.dart';

class AuthController extends GetxController {
  // Add your authentication logic here
}
''';
  }

  String _generateAuthBinding() {
    return '''import 'package:flutter_core/getx.dart';

import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
''';
  }

  String _generateAdMobService() {
    final admob = config['admob'] as Map<String, dynamic>;
    final androidBannerId = admob['android']['bannerAdUnitId'] as String;
    final iosBannerId = admob['ios']['bannerAdUnitId'] as String;

    return '''import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  // Test ad unit IDs for development (uncomment to use test ads)
  // static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  static String get bannerAdUnitId {
    // For development/testing, you can use test ad units:
    // return testBannerAdUnitId;

    // Production ad units:
    if (Platform.isAndroid) {
      return '$androidBannerId';
    } else if (Platform.isIOS) {
      return '$iosBannerId';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();

    // Optional: Configure test devices for development
    // Uncomment and add your test device IDs if needed
    // MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(
    //     testDeviceIds: ['TEST_DEVICE_ID_HERE'],
    //   ),
    // );
  }

  static AdSize getBannerAdSize() {
    return AdSize.banner;
  }
}
''';
  }

  String _generateAdManager() {
    final admob = config['admob'] as Map<String, dynamic>;
    final androidInterstitialId =
        admob['android']['interstitialAdUnitId'] as String;
    final iosInterstitialId = admob['ios']['interstitialAdUnitId'] as String;

    return '''import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'admob_service.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  // Track last ad show time to avoid showing too frequently
  static DateTime? _lastInterstitialTime;

  static Future<void> initialize() async {
    await AdMobService.initialize();
    _loadInterstitialAd();
  }

  static void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              _lastInterstitialTime = DateTime.now();
              _loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          // Retry after some time
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  static String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return '$androidInterstitialId';
    } else if (Platform.isIOS) {
      return '$iosInterstitialId';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static void showInterstitialAd() {
    // Only show if enough time has passed (avoid showing too frequently)
    final now = DateTime.now();
    if (_lastInterstitialTime != null) {
      final timeSinceLastAd = now.difference(_lastInterstitialTime!);
      if (timeSinceLastAd.inSeconds < 60) {
        // Don't show ads too frequently (less than 1 minute)
        return;
      }
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  // Call this when user navigates between major screens
  static void onNavigation() {
    // Show interstitial ad occasionally (e.g., every 3rd navigation)
    final random = DateTime.now().millisecondsSinceEpoch % 5;
    if (random == 0) { // ~20% chance
      showInterstitialAd();
    }
  }
}
''';
  }

  String _generateCommonComponents() {
    return '''import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.isOutlined = false,
    required this.onPressed,
    this.width = 280,
  });

  final String buttonText;
  final bool isOutlined;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : Theme.of(context).primaryColor,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isOutlined
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopScreenImage extends StatelessWidget {
  final String screenImageName;
  final Widget? topButton;

  const TopScreenImage({
    super.key,
    required this.screenImageName,
    this.topButton,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/\$screenImageName'),
              ),
            ),
          ),
          if (topButton != null)
            Positioned(
              child: topButton!,
              right: 0,
            ),
        ],
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 40),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, required this.textField});
  final TextFormField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          width: 2.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: textField,
    );
  }
}
''';
  }

  String _generateMyAppBar() {
    return '''import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const MyAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(title, style: textStyle),
      actions: actions,
      toolbarHeight: 70,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
''';
  }

  String _generateBannerAds() {
    final admob = config['admob'] as Map<String, dynamic>;
    final androidBannerId = admob['android']['bannerAdUnitId'] as String;
    final iosBannerId = admob['ios']['bannerAdUnitId'] as String;

    return '''import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({super.key});

  @override
  BannerAdsState createState() => BannerAdsState();
}

class BannerAdsState extends State<BannerAds> {
  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? '$androidBannerId'
      : '$iosBannerId';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          )
        : const SizedBox(
            width: 320.0,
            height: 50.0,
          );
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
''';
  }

  String _generateCommonConstants() {
    return '''import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFD4DEF7);
const Color kTextColor = Color(0xFF4879C5);
const InputDecoration kTextInputDecoration = InputDecoration(
  border: InputBorder.none,
  hintText: '',
);
''';
  }

  String _generateCommonUtils() {
    return '''import '../configs/app.dart';

String? getFullImageUrl(String? imageURL) {
  if (imageURL == null || imageURL.isEmpty) return imageURL;
  return '\${AppConfigs.baseUrl}/\$imageURL';
}
''';
  }

  String _generateViewUtils() {
    return '''import 'package:flutter/material.dart';
    import 'package:flutter_core/getx.dart';

class ViewUtils {
  static BoxDecoration profileDecoration(String image) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(image),
      ),
    );
  }

  static BoxDecoration bodyDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      color: Theme.of(Get.context!).cardColor,
    );
  }
}
''';
  }

  String _generateSettingGroup() {
    return '''import 'package:flutter/material.dart';

import 'setting_item.dart';

class SettingsGroup extends StatelessWidget {
  final String? settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final List<SettingsItem> items;
  final EdgeInsets? margin;
  final double? iconItemSize;

  SettingsGroup({
    this.settingsGroupTitle,
    this.settingsGroupTitleStyle,
    required this.items,
    this.margin,
    this.iconItemSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    if (iconItemSize != null) {
      SettingsScreenUtils.settingsGroupIconSize = iconItemSize;
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (settingsGroupTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                settingsGroupTitle!,
                style: settingsGroupTitleStyle ??
                    const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
''';
  }

  String _generateSettingItem() {
    return '''import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icons;
  final IconStyle? iconStyle;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final int? titleMaxLine;
  final int? subtitleMaxLine;
  final TextOverflow? overflow;

  const SettingsItem({
    super.key,
    required this.icons,
    this.iconStyle,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.backgroundColor,
    this.trailing,
    this.onTap,
    this.titleMaxLine,
    this.subtitleMaxLine,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        onTap: onTap,
        leading: (iconStyle != null && iconStyle!.withBackground!)
            ? Container(
                decoration: BoxDecoration(
                  color: iconStyle!.backgroundColor,
                  borderRadius:
                      BorderRadius.circular(iconStyle!.borderRadius!),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icons,
                  size: SettingsScreenUtils.settingsGroupIconSize,
                  color: iconStyle!.iconsColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icons,
                  size: SettingsScreenUtils.settingsGroupIconSize,
                ),
              ),
        title: Text(
          title,
          style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold),
          maxLines: titleMaxLine,
          overflow: titleMaxLine != null ? overflow : null,
        ),
        trailing: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleStyle ??
                    Theme.of(context).textTheme.bodyMedium!,
                maxLines: subtitleMaxLine,
                overflow: subtitleMaxLine != null
                    ? TextOverflow.ellipsis
                    : null,
              )
            : trailing ?? const Icon(Icons.navigate_next),
      ),
    );
  }
}

class SettingsScreenUtils {
  static double? settingsGroupIconSize;
  static TextStyle? settingsGroupTitleStyle;
}

class IconStyle {
  Color? iconsColor;
  bool? withBackground;
  Color? backgroundColor;
  double? borderRadius;

  IconStyle({
    this.iconsColor = Colors.white,
    this.withBackground = true,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8,
  });
}
''';
  }
}
