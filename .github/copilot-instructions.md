# Yuva Ride User App - AI Coding Guidelines

## Architecture Overview
This Flutter app follows a layered MVVM-inspired architecture:
- **View Layer** (`lib/view/`): UI screens and widgets, separated into `screens/` (e.g., auth flows) and `custom_widgets/`.
- **Controller Layer** (`lib/controller/`): Provider-based state management (e.g., `AuthProvider` in `auth_provider.dart`).
- **Repository Layer** (`lib/repository/`): Data access abstraction (e.g., `AuthRepository` handles auth API calls).
- **Service Layer** (`lib/services/`): Core services like `ApiService` (Dio wrapper), `LocalStorage` (SharedPreferences), `MapServices` for Google Maps integration.
- **Model Layer** (`lib/models/`): JSON-serializable data models (e.g., `ProfileModel`).
- **Utils** (`lib/utils/`): Constants (API URLs in `constants.dart`), themes, colors, global functions.

Data flow: UI triggers Provider methods → Provider calls Repository → Repository uses ApiService for HTTP requests → Responses parsed into Models → UI updates via notifyListeners().

## Key Patterns
- **State Management**: Use Provider with ChangeNotifier. Each feature has a dedicated Provider (e.g., `AuthProvider`) with ApiResponse states for loading/success/error.
- **API Calls**: All HTTP via `ApiService` (Dio). Automatically adds Bearer token from LocalStorage. Shows toasts for success/error by default (customizable via isToast params).
- **Error Handling**: ApiResponse class wraps responses. Check status with `isStatusSuccess()` from `status.dart`.
- **Local Storage**: Use `LocalStorage` for token persistence (SharedPreferences).
- **Models**: Generated from JSON using standard fromJson/toJson. Place in `lib/models/`.
- **Constants**: API URLs in `AppUrl` class (`lib/utils/constants.dart`). Base URL: `https://poolpal.techlanditsolutions.com/customer/`.
- **Themes**: Custom themes in `lib/utils/theme.dart` with light/dark modes.

## Developer Workflows
- **Build & Run**: `flutter pub get` then `flutter run`. Hot reload/restart via IDE or `flutter hot-reload`.
- **Dependencies**: Add via `flutter pub add <package>`. Update with `flutter pub upgrade`.
- **Debugging**: Use Flutter DevTools for performance. Logs via `print()` or Dio interceptors.
- **Testing**: Run `flutter test` (basic widget tests in `test/widget_test.dart`).
- **Build Release**: `flutter build apk` or `flutter build ios` for production.

## Conventions
- **File Naming**: snake_case for files (e.g., `auth_provider.dart`), PascalCase for classes.
- **Imports**: Relative imports within lib (e.g., `import 'package:yuva_ride/controller/auth_provider.dart';`).
- **Code Style**: Follow `analysis_options.yaml` (Flutter lints). Use emojis in comments for sections (e.g., 🔹).
- **Assets**: Images in `assets/images/`, referenced via `AppAssets` in `utils/app_assets.dart`.
- **Navigation**: Use named routes or direct pushes; avoid deep nesting.
- **Permissions**: Handle via `permission_handler` for location/maps/media access.

## Integration Points
- **Google Maps**: Use `google_maps_flutter` with `MapServices` for polylines/routes.
- **Location**: `geolocator` and `geocoding` for GPS and address conversion.
- **Speech/Media**: `speech_to_text`, `image_picker`, `video_player` for user inputs.
- **External APIs**: Msg91 for OTP, custom backend for auth/profile.
- **Connectivity**: Check with `connectivity_plus` and `internet_connection_checker`.

Reference key files: [lib/main.dart](lib/main.dart) (entry), [lib/controller/auth_provider.dart](lib/controller/auth_provider.dart) (state example), [lib/services/api_services.dart](lib/services/api_services.dart) (API pattern).</content>
<parameter name="filePath">f:\Tech Land Flutter Project\yuva ride -user\.github\copilot-instructions.md