[← Back to Root](../README.md)

# Saranidhi — Mobile Release Build & Submission Guide

## Prerequisites

| Requirement | iOS | Android |
|-------------|-----|---------|
| Developer Account | Apple Developer ($99/year) | Google Play Console ($25 one-time) |
| IDE | Xcode (latest stable) | Android Studio |
| Flutter | Stable channel, `flutter doctor` clean | Same |
| Signing | Apple Distribution Certificate + Provisioning Profile | Upload keystore (`.jks`) |

---

## Step 1: Verify Build Locally

```bash
# From project root
cd /path/to/saranidhi

# Ensure dependencies are up to date
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run tests (should all pass)
flutter test

# Verify iOS build
flutter build ios --release --no-codesign

# Verify Android build
flutter build appbundle --release
```

---

## Step 2: iOS Release Build

### 2.1 Create Signing Assets (First Time Only)

1. Open [Apple Developer Portal](https://developer.apple.com/account)
2. Go to **Certificates, Identifiers & Profiles**
3. Create an **App ID**:
   - Bundle ID: `com.vteial.saranidhi`
   - Capabilities: None required (no push notifications on first release)
4. Create a **Distribution Certificate** (Apple Distribution)
5. Create a **Provisioning Profile** (App Store type) linked to the App ID

### 2.2 Configure Xcode

```bash
# Open in Xcode
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **Runner** target → **Signing & Capabilities**
2. Set Team to your Apple Developer team
3. Ensure Bundle Identifier is `com.vteial.saranidhi`
4. Signing: Automatic or manual (select App Store provisioning profile)

### 2.3 Build Archive

```bash
flutter build ipa --release
```

Output: `build/ios/ipa/saranidhi.ipa`

### 2.4 Upload to App Store Connect

Option A — Using Xcode:
1. Open Xcode → **Window** → **Organizer**
2. Select the archive → **Distribute App** → **App Store Connect**

Option B — Using Transporter:
1. Download **Transporter** app from Mac App Store
2. Drag the `.ipa` file into Transporter
3. Click **Deliver**

---

## Step 3: Android Release Build

### 3.1 Create Upload Keystore (First Time Only)

```bash
keytool -genkey -v -keystore ~/saranidhi-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias saranidhi-upload \
  -storepass YOUR_STORE_PASSWORD \
  -keypass YOUR_KEY_PASSWORD \
  -dname "CN=Eialarasu, O=vteial, L=Chennai, C=IN"
```

**IMPORTANT:** Back up this keystore file securely! You'll need it for every future update.

### 3.2 Configure Signing

Create `android/key.properties` (DO NOT commit to git):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=saranidhi-upload
storeFile=/Users/YOUR_USERNAME/saranidhi-upload.jks
```

Update `android/app/build.gradle.kts` — replace the release signing config:

```kotlin
// Add before android { block:
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

### 3.3 Build App Bundle

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Step 4: App Store Connect Setup (iOS)

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. **My Apps** → **+** → **New App**
3. Fill in:
   - Platform: iOS
   - Name: Saranidhi
   - Primary Language: English (U.S.)
   - Bundle ID: com.vteial.saranidhi
   - SKU: saranidhi-ios-1
4. Fill in listing details from `docs/store-listing.md`
5. Upload screenshots (see screenshot requirements in store-listing.md)
6. Set content rating: Questionnaire → no objectionable content
7. Set pricing: Free
8. Privacy Policy URL: `https://saranidhi.vercel.app/privacy.html`
9. Select the uploaded build
10. Submit for review

---

## Step 5: Google Play Console Setup (Android)

1. Go to [Google Play Console](https://play.google.com/console)
2. **Create app** →
   - App name: Saranidhi
   - Default language: English (United States)
   - App type: App
   - Free/Paid: Free
   - Category: Health & Fitness
3. Complete all setup tasks:
   - **Store listing:** Copy from `docs/store-listing.md`
   - **Content rating:** Fill questionnaire (no violence, no data collection)
   - **Target audience:** 13+ (spiritual content)
   - **Privacy policy:** `https://saranidhi.vercel.app/privacy.html`
   - **App access:** All functionality available without restrictions
4. **Testing** → **Internal testing** → Upload `.aab` first (recommended for initial testing)
5. Once verified → **Production** → **Create release** → Upload `.aab`
6. Submit for review

---

## Step 6: Post-Submission

### Expected Review Times

| Store | Typical Review Time |
|-------|-------------------|
| App Store (iOS) | 24–48 hours |
| Play Store (Android) | 1–7 days (first submission may take longer) |

### Common Rejection Reasons & Fixes

| Reason | Fix |
|--------|-----|
| Missing privacy policy | Already at saranidhi.vercel.app/privacy.html ✅ |
| Misleading metadata | Keep description accurate to functionality |
| Incomplete functionality | App is fully functional offline |
| Crash on review device | Test on older devices (iPhone SE, Android API 21+) |

---

## Step 7: After Approval

1. Both stores go live automatically after approval (or you can set a specific date)
2. Verify apps are searchable and downloadable
3. Tag release: `git tag v1.0.0 && git push origin v1.0.0`
4. Update `docs/sprint-tracker.md` → Sprint 14 complete
5. Announce! 🎉

---

## Files NOT to Commit

Add to `.gitignore` if not already present:

```
# Android signing
android/key.properties
*.jks
*.keystore

# iOS signing (handled by Xcode, not in repo)
ios/*.mobileprovision
ios/*.p12
```

---

## Quick Reference Commands

```bash
# iOS
flutter build ipa --release
# Output: build/ios/ipa/saranidhi.ipa

# Android
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab

# Both (verify first)
flutter doctor
flutter test
flutter analyze
```

---

[← Back to Root](../README.md)
