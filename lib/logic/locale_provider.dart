import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ru');
  static const String _localeKey = 'selected_locale';

  Locale get currentLocale => _currentLocale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_localeKey) ?? 'ru';
    _currentLocale = Locale(langCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _currentLocale) return;

    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}