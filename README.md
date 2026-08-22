# CookSmart (कुकस्मार्ट) - Flutter & Gemini AI Recipe Assistant

A Flutter mobile application designed with the **Culinary Noir** theme (`#121214` dark surface, `#FF6B35` flame orange, `#FFAA00` amber glow), multilingual localization (मराठी, हिंदी, English, Español), and real-time **Google Gemini AI** recipe synthesis.

---

## 🚀 Opening in Android Studio

1. Open **Android Studio**.
2. Click **Open** (or `File > Open...`).
3. Select the folder:
   ```
   C:\Users\Sairam\.gemini\antigravity-ide\scratch\cooksmart-app\cooksmart_flutter
   ```
4. Wait for Android Studio to sync Dart dependencies and Gradle.
5. In the top device bar, select your connected Android physical device or Android Emulator.
6. Click the green **Run (▶)** button (or press `Shift + F10`).

---

## 📦 Building Android APK

### Option 1: Via Terminal / Command Line
Inside this directory (`cooksmart_flutter`), run:

```bash
# Build Universal Release APK
flutter build apk --release

# OR build Split Per-ABI APKs (smaller file size)
flutter build apk --split-per-abi --release
```

The compiled APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Option 2: Via Android Studio Menu
1. Go to menu: `Build > Flutter > Build APK` (or `Build > Build Bundle(s) / APK(s) > Build APK(s)`).
2. Click `locate` in the bottom right popup once build finishes.

---

## 🛠️ Project Structure & Architecture

```
cooksmart_flutter/
├── android/                         # Android Studio native host project & Gradle scripts
│   ├── app/
│   │   ├── src/main/AndroidManifest.xml  # Includes INTERNET & NETWORK permissions
│   │   └── build.gradle.kts        # Android Gradle plugin & SDK targets
│   └── build.gradle.kts
├── lib/
│   ├── main.dart                   # Application entry point & route shell
│   ├── theme/
│   │   └── app_theme.dart          # Culinary Noir colors & Google Fonts tokens
│   ├── models/
│   │   └── recipe.dart             # Recipe, IngredientItem, CookingStep models
│   ├── localization/
│   │   └── app_strings.dart        # Full dictionary for मराठी, हिंदी, English, Español
│   ├── services/
│   │   └── gemini_service.dart     # Gemini AI REST client (gemini-3.5-flash / gemini-flash-latest)
│   ├── providers/
│   │   └── recipe_provider.dart    # Provider state management & async Gemini dispatch
│   ├── widgets/
│   │   ├── bottom_nav_bar.dart     # Glassmorphic bottom navigation
│   │   ├── cooking_mode_modal.dart # Step countdown timers with Play/Pause
│   │   └── language_selector_modal.dart # Language selection modal
│   └── screens/
│       ├── home_screen.dart             # Screen 1: Home & food categories
│       ├── ingredient_input_screen.dart # Screen 2: Pantry & Gemini AI generator
│       ├── recipe_result_screen.dart    # Screen 3: Recipe details, metrics & checklist
│       └── saved_recipes_screen.dart    # Screen 4: 2-column saved recipe grid
├── test/
│   └── widget_test.dart            # Flutter smoke and widget tests
└── pubspec.yaml                    # Dependencies (provider, google_fonts, http, intl)
```

---

## 🤖 Gemini AI Configuration

The app is configured to call Google Gemini API with fallback candidate models:
- `models/gemini-3.5-flash`
- `models/gemini-flash-latest`
- `models/gemini-3.6-flash`
- `models/gemini-3-flash-preview`

The API key is securely embedded in `lib/services/gemini_service.dart`.
Recipes are dynamically generated with title, description, precise ingredient measurements, numbered cooking steps with timer seconds, calories, servings, and estimated preparation time in the user's selected language.
