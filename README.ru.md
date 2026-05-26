# Drink Water

[Read this in English](README.md)

Мобильное приложение для отслеживания потребления воды в течение дня. Разработано с использованием Flutter


## Скриншоты

*скоро здесь будут*


## Функционал

- Беспарольная аутентификация через ссылку, которая приходит на почту
- Регистрация пользователя с расчётом дневной нормы воды по формуле (вес × 33 мл)
- Отслеживание выпитой воды в реальном времени с индикатором прогресса
- История потребления воды по дням с календарём на неделю
- Пользовательские карточки ёмкостей с возможностью выбора иконки и объёма
- Активность за сегодня с возможностью удаления записи и просмотра времени добавления
- Редактирование профиля: имя, вес, дневная цель
- Автоматический сброс счётчика при наступлении нового дня
- Сохранение данных между сессиями
- Локализация: полная поддержка английского и русского языков с динамическим переключением внутри приложения


## Технологии

- **Flutter** — UI-фреймворк
- **Provider** — управление состоянием (state management)
- **Firebase Auth** — аутентификация
- **Cloud Firestore** — облачная база данных
- **SharedPreferences** — локальное хранилище
- **percent_indicator** — индикатор прогресса
- **font_awesome_flutter** — иконки
- **app_links** — обработка Deep Link для аутентификации через magic link


## Принципы разработки

- Принципы SOLID
- Repository Pattern
- Внедрение зависимостей (Dependency Injection через Provider)
- Адаптивный интерфейс (Responsive UI) — все размеры рассчитываются относительно ширины экрана


## Запуск проекта

**Требования:**
- Flutter SDK 3.x+
- Dart 3.x+

**Установка:**

```
git clone https://github.com/daniilpaschenko/drink-water.git
cd drink-water
flutter pub get
flutter run
```

## Архитектура

Проект построен на базе **Repository Pattern** с использованием **Provider** в качестве менеджера состояния.

```
lib/
├── core/
│   └── constants.dart
├── l10n/
│   ├── app_en.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_ru.dart
│   ├── app_localizations.dart
│   └── app_ru.dart
├── logic/
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
│   ├── login_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── appbar.dart
    ├── water_card.dart
    ├── water_progress_bar.dart
    ├── water_entry_tile.dart
    ├── week_calendar.dart
    ├── home_body.dart
    ├── info_section.dart
    ├── faq_item.dart
    ├── login_form.dart
    ├── register_form.dart
    └── editable_field.dart
```