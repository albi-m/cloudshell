# Build & Release Guide

This guide covers building CloudShell for all platforms, code signing for distribution, CI/CD pipelines, and the release process.

---

## 1. Prerequisites

### Common

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.38+
- Dart SDK 3.10+ (bundled with Flutter)
- Git

### Platform-Specific

| Platform | Requirements |
|----------|-------------|
| macOS | Xcode 15+, `brew install libserialport automake libtool` |
| iOS | Xcode 15+, Apple Developer account (for device/distribution) |
| Android | Android Studio, Java 17 (temurin), Android SDK |
| Windows | Visual Studio 2022 with "Desktop development with C++" workload |
| Linux | `sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev libserialport-dev libsecret-1-dev` |

---

## 2. Development Builds

### Initial Setup

```bash
# Install dependencies
flutter pub get

# Generate code (Drift database, Freezed models, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

> Run `build_runner` and `gen-l10n` after pulling changes or modifying `.dart` model/table files.

### Run Locally

```bash
flutter run -d macos      # macOS
flutter run -d windows    # Windows
flutter run -d linux      # Linux
flutter run -d ios        # iOS Simulator
flutter run -d android    # Android Emulator
```

### With Supabase Backend

```bash
flutter run -d macos \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

See [SUPABASE-SETUP.md](SUPABASE-SETUP.md) for full backend configuration.

---

## 3. Release Builds

```bash
# macOS
flutter build macos --release

# iOS
flutter build ios --release             # Requires signing
flutter build ipa --release             # For App Store / TestFlight

# Android
flutter build apk --release             # Universal APK
flutter build appbundle --release       # AAB for Google Play

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

### Output Locations

| Platform | Path |
|----------|------|
| macOS | `build/macos/Build/Products/Release/cloudshell.app` |
| iOS | `build/ios/iphoneos/Runner.app` |
| Android APK | `build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | `build/app/outputs/bundle/release/app-release.aab` |
| Windows | `build/windows/x64/runner/Release/` |
| Linux | `build/linux/x64/release/bundle/` |

---

## 4. Code Signing

### macOS

CloudShell requires specific entitlements to function correctly. These are configured in:
- `macos/Runner/DebugProfile.entitlements` — sandbox disabled for development
- `macos/Runner/Release.entitlements` — sandbox enabled for distribution

**Critical entitlements:**
- `com.apple.security.network.client` — Required for SSH connections (without this, connections fail)
- `com.apple.security.network.server` — Required for port forwarding
- `com.apple.security.files.user-selected.read-write` — Required for SFTP file operations

**For distribution:**

1. Enroll in the [Apple Developer Program](https://developer.apple.com/programs/) ($99/year)
2. In Xcode, open `macos/Runner.xcworkspace`
3. Select the Runner target > Signing & Capabilities
4. Choose your Team and set a unique Bundle Identifier
5. Build:
   ```bash
   flutter build macos --release
   ```
6. Notarize for distribution outside the App Store:
   ```bash
   # Create a ZIP of the app
   ditto -c -k --keepParent build/macos/Build/Products/Release/cloudshell.app cloudshell-macos.zip

   # Submit for notarization
   xcrun notarytool submit cloudshell-macos.zip \
     --apple-id your@email.com \
     --team-id YOUR_TEAM_ID \
     --password @keychain:AC_PASSWORD \
     --wait

   # Staple the notarization ticket
   xcrun stapler staple build/macos/Build/Products/Release/cloudshell.app
   ```

### iOS

1. In Xcode, open `ios/Runner.xcworkspace`
2. Select the Runner target > Signing & Capabilities
3. Choose your Team and set a unique Bundle Identifier
4. Privacy descriptions are already configured in `ios/Runner/Info.plist`:
   - **Face ID**: "CloudShell uses Face ID to unlock the app and protect your SSH keys."
   - **Local Network**: "CloudShell needs local network access to connect to SSH servers on your network."
5. Build for App Store:
   ```bash
   flutter build ipa --release
   ```
6. Upload via Transporter app or `xcrun altool`

### Android

**Generate a release keystore:**

```bash
keytool -genkey -v \
  -keystore android/cloudshell.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias cloudshell
```

**Create `android/key.properties`** (do NOT commit this file):

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=cloudshell
storeFile=cloudshell.jks
```

**Update `android/app/build.gradle.kts`** to use the keystore:

```kotlin
// Add above android { block:
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

**Build for Google Play:**

```bash
flutter build appbundle --release
```

Upload the `.aab` file to the [Google Play Console](https://play.google.com/console).

> The current codebase uses `signingConfig = signingConfigs.getByName("debug")` for release builds. Update this before publishing.

**Android permissions** (already configured in `AndroidManifest.xml`):
- `android.permission.INTERNET` — SSH connections
- `android:allowBackup="false"` — Prevents backup of encrypted database

### Windows

Code signing is optional for direct distribution:

1. Obtain a code signing certificate from a CA (e.g., DigiCert, Sectigo)
2. Sign the executable:
   ```powershell
   signtool sign /f cert.pfx /p password /tr http://timestamp.digicert.com build\windows\x64\runner\Release\cloudshell.exe
   ```
3. For Microsoft Store: package as MSIX using `msix` pub package

### Linux

No code signing required for direct distribution. For packaging:

- **Snap**: Use `snapcraft.yaml`
- **Flatpak**: Use `flatpak-builder`
- **AppImage**: Use `appimage-builder`
- **Debian**: Use `dpkg-deb`

---

## 5. CI/CD Pipeline

### Continuous Integration (`.github/workflows/ci.yml`)

Runs on every push to `main`/`develop` and all pull requests:

1. **Analyze** — `flutter analyze --no-fatal-infos`
2. **Test** — `flutter test` with coverage upload
3. **Build** — All 5 platforms in parallel (macOS, iOS, Android, Windows, Linux)

Each build job runs code generation first:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Release Pipeline (`.github/workflows/release.yml`)

Triggered by tags matching `v*`:

1. Runs all CI checks (analyze + test)
2. Builds all platforms in release mode
3. Archives binaries:
   - `cloudshell-macos.zip`
   - `cloudshell-ios.zip`
   - `cloudshell-android.apk`
   - `cloudshell-windows-x64.zip`
   - `cloudshell-linux-x64.tar.gz`
4. Creates a GitHub Release with auto-generated notes and attached artifacts

### Adding Supabase to CI/CD

Add repository secrets (`Settings > Secrets > Actions`):
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Then pass them in build steps:
```yaml
- name: Build release
  run: |
    flutter build apk --release \
      --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
      --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
```

---

## 6. Release Checklist

Before creating a release:

- [ ] Update version in `pubspec.yaml` (e.g., `1.2.0+3`)
- [ ] Update `CHANGELOG.md` with new entries
- [ ] Run `flutter analyze` — must report 0 issues
- [ ] Run `flutter test` — all tests must pass
- [ ] Build all target platforms locally and verify
- [ ] Test critical flows: SSH connect, SFTP browse, key import, sync (if applicable)
- [ ] Commit changes to `main`
- [ ] Tag the release:
  ```bash
  git tag v1.2.0
  git push origin v1.2.0
  ```
- [ ] Verify GitHub Actions creates the release with all artifacts
- [ ] Upload platform-specific builds to app stores (if applicable)
