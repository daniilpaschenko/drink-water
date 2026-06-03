**[Читать на русском языке](README.ru.md)**

# Drink Water

A mobile app for tracking water consumption throughout the day. Developed with Flutter


## Screenshots

<table align="center">
  <tr>
    <td align="center">
      <img src="assets/screenshots/welcome.jpg" width="250" alt="Welcome"><br>
    </td>
    <td align="center">
      <img src="assets/screenshots/home.jpg" width="250" alt="Home"><br>
    </td>
    <td align="center">
      <img src="assets/screenshots/account.jpg" width="250" alt="Account"><br>
    </td>
    <td align="center">
      <img src="assets/screenshots/info.jpg" width="250" alt="Info"><br>
    </td>
  </tr>
</table>


## Functionality

- Passwordless authentication via magic link (email) or instant anonymous login
- User registration with calculation of daily water intake by formula (weight × 33 ml)
- Real-time tracking of water consumed with progress bar
- Water consumption history by day with weekly calendar
- Custom container cards with icon and volume selection
- Today's water activity with the option to view the time and delete the recording
- Profile editing - name, weight, daily goal
- Automatic counter reset to new day
- Data saving between sessions
- Localization - full support for English and Russian languages with dynamic in-app switching


## Technologies

- **Flutter** — UI framework
- **Provider** — State management
- **Firebase Auth** — Authentication
- **Cloud Firestore** — Cloud database
- **SharedPreferences** — Local storage
- **percent_indicator** — Progress bar
- **font_awesome_flutter** — Icons 
- **app_links** — Deep link handling for magic link authentication


## Development Principles

- Clean Architecture
- SOLID principles
- Repository Pattern
- Dependency Injection (Provider)
- Responsive UI - all sizes are calculated from the screen width


## Installation

### Download APK (Android)
Go to [Releases](https://github.com/daniilpaschenko/drink-water/releases) and download the APK for your device


### Build from source

**Requirements:**
- Flutter SDK 3.x+
- Dart 3.x+

```
git clone https://github.com/daniilpaschenko/drink-water.git
cd drink-water
flutter pub get
flutter run
```