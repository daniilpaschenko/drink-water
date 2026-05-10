# Drink Water

A mobile app for tracking water consumption throughout the day. Developed with Flutter


## Screenshots

*will be here soon*


## Functionality

- User registration with calculation of daily water intake by formula (weight × 33 ml)
- Real-time tracking of water consumed with progress bar
- Water consumption history by day with weekly calendar
- Custom container cards with icon and volume selection
- Today's water activity with the option to view the time and delete the recording
- Profile editing - name, weight, daily goal
- Automatic counter reset to new day
- Data saving between sessions


## Architecture

The project is based on the **Repository Pattern** with **Provider** as state management.

```
lib/
├── logic/
│   ├── auth_logic.dart
│   ├── user_repository.dart
│   ├── water_repository.dart
│   └── card_repository.dart
├── models/
│   ├── custom_card.dart
│   ├── user_data.dart
│   └── water_entry.dart
├── screens/
│   ├── auth_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── account_screen.dart
│   ├── history_screen.dart
│   ├── info_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── appbar.dart
    ├── water_card.dart
    ├── water_progress_bar.dart
    ├── week_calendar.dart
    └── editable_field.dart
```


## Technologies

- **Flutter** — UI framework
- **Provider** — State management
- **Firebase Auth** — Authentication
- **Cloud Firestore** — Cloud database
- **SharedPreferences** — Local storage
- **percent_indicator** — Progress bar
- **font_awesome_flutter** — Icons 



## Development Principles

- SOLID principles
- Repository Pattern
- Dependency Injection (Provider)
- Responsive UI - all sizes are calculated from the screen width



## Launching a project

**Requirements:**
- Flutter SDK 3.x+
- Dart 3.x+

**Installation:**

```
git clone https://github.com/daniilpaschenko/drink-water.git
cd drink-water
flutter pub get
flutter run
```



## Coming soon

- Push Notifications - Reminders to drink water
- Dark Theme
- Localization - Support for multiple languages