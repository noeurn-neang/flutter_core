# Flutter Project Generator CLI

Generate Flutter projects with complete structure, Firebase, and AdMob setup in one command.

## Quick Start

**1. Install Requirements:**
```bash
# Flutter & Dart (usually together)
flutter --version

# Firebase CLI
npm install -g firebase-tools
firebase login
```

**2. Run CLI:**
```bash
dart flutter_core/lib/cli/create_project.dart flutter_core/lib/cli/project_template.json
```

**3. Follow prompts** - The CLI will:
- ✅ Check all requirements
- ✅ Create Flutter project
- ✅ Generate complete structure
- ✅ Configure Android/iOS
- ✅ Create Firebase project
- ✅ Run `flutterfire configure` (interactive)

**4. Start coding:**
```bash
cd projectname
# Project is ready!
```

## Requirements

The CLI checks these automatically and shows clear errors if missing:

- ✅ **Flutter SDK** (`flutter --version`)
- ✅ **Dart SDK** (`dart --version`) 
- ✅ **Firebase CLI** (`npm install -g firebase-tools`)
- ✅ **Firebase Login** (`firebase login`)

## Template File

Edit `project_template.json` before running:

```json
{
  "project": {
    "name": "projectname",
    "bundleId": "com.direxme.app.projectname",
    "displayName": "Project Name",
    "platforms": ["android", "ios"]
  },
  "flutter_core": {
    "branch": "main"
  },
  "admob": {
    "android": {
      "appId": "ca-app-pub-...",
      "bannerAdUnitId": "ca-app-pub-...",
      "interstitialAdUnitId": "ca-app-pub-..."
    },
    "ios": {
      "appId": "ca-app-pub-...",
      "bannerAdUnitId": "ca-app-pub-...",
      "interstitialAdUnitId": "ca-app-pub-..."
    }
  },
  "app": {
    "baseUrl": "https://www.sothea.biz/projectname",
    "baseApiUrl": "https://www.sothea.biz/projectname/v1/index.php",
    "authHeaderKey": "Authorizationgrown",
    "defaultPassword": "123"
  },
  "android": {
    "signing": {
      "keyAlias": "upload",
      "keyPassword": "Knc@168",
      "storePassword": "Knc@168",
      "storeFile": "upload-keystore.jks"
    }
  }
}
```

## What Gets Generated

**Complete project structure:**
- Flutter project with your name/bundle ID
- Full directory structure (modules, routes, models, services, etc.)
- All core files (`main.dart`, `app.dart`, routes, translations, etc.)
- Android/iOS configurations (AdMob, signing, etc.)
- Firebase setup (project creation + `flutterfire configure`)

**Dependencies added:**
- `flutter_core` (from GitHub)
- Firebase (`firebase_core`, `firebase_auth`)
- AdMob (`google_mobile_ads`)
- Auth (`google_sign_in`, `sign_in_with_apple`)
- Utilities (`url_launcher`, `share_plus`, etc.)

## Error Handling

The CLI uses **strict error checking**:
- ❌ Missing requirements → **Stops with clear error + fix instructions**
- ❌ Firebase not logged in → **Stops with login instructions**
- ❌ Installation failures → **Stops with manual steps**

No silent failures - you'll know exactly what's wrong and how to fix it.

## Platform Support

Specify platforms in template:
```json
{
  "project": {
    "platforms": ["android", "ios"]  // or ["android"] or ["ios"]
  }
}
```

Defaults to `["android", "ios"]` if not specified.
