# Party Booking Flutter

Mobile application for the Party-Fun platform built with Flutter, supporting Android and iOS.

## Tech Stack

- **Framework**: Flutter (Dart SDK >=2.6.0)
- **State management**: flutter_bloc + bloc
- **Networking**: Chopper + Dio
- **Maps**: google_maps_flutter
- **UI**: Material Design + Google Fonts + Lottie animations
- **Auth**: Shared preferences + JWT

## Setup

```bash
flutter pub get
flutter run
```

## Code Generation

```bash
# One-time build
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

## Project Structure

```
lib/
├── authentication/   # Auth BLoC
├── cart/             # Cart BLoC
├── data/             # Network & database layer
├── dish/             # Dish BLoC
├── ui/               # Screens & pages
├── widgets/          # Reusable widgets
└── main.dart
```

## Build

```bash
# Android
flutter build apk

# iOS
flutter build ios
```
