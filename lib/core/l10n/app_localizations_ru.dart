// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Drink Water';

  @override
  String get name => 'Имя';

  @override
  String get weight => 'Вес';

  @override
  String get kg => 'кг';

  @override
  String get dailyGoal => 'Дневная цель';

  @override
  String get unitL => 'л';

  @override
  String get email => 'Почта';

  @override
  String get wantToLogout => 'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get wantToLogoutAnonymous =>
      'Вы вошли анонимно. При выходе все данные будут удалены. Продолжить?';

  @override
  String get cancel => 'Отмена';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutFromAccount => 'Выйти из аккаунта';

  @override
  String get welcome => 'Добро пожаловать!';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get login => 'Войти';

  @override
  String get anonymousLogin => 'Войти анонимно';

  @override
  String get loggedInAnonymously => 'Вы вошли анонимно';

  @override
  String get outOf => 'из';

  @override
  String get success => 'Успешно!';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get aboutAppText =>
      ' — приложение для отслеживания потребления воды. Оно помогает следить за дневной нормой, добавляя выпитое количество воды.';

  @override
  String get dailyGoalFormula => 'Формула дневной нормы';

  @override
  String get formulaRule => 'Норма = вес (кг) × 33 мл';

  @override
  String get formulaExample =>
      'Например, при весе 70 кг:\n70 × 33 = 2310 мл = 2.31 л';

  @override
  String get formulaLimits =>
      'Минимальная норма: 1.5 л\nМаксимальная норма: 4 л';

  @override
  String get faq => 'Частые вопросы';

  @override
  String get devContacts => 'Контакты разработчика';

  @override
  String get drinkWaterSlogan => 'Пейте воду — будете здоровы';

  @override
  String get telegram => 'Telegram: @daniil_paschenko';

  @override
  String get github => 'GitHub: github.com/daniilpaschenko';

  @override
  String get addWaterPrompt => 'Добавьте выпитое количество воды:';

  @override
  String get longPressToDelete => '(Долгое нажатие на карточку удаляет её)';

  @override
  String get todayEntries => 'Записи за сегодня';

  @override
  String get hello => 'Привет';

  @override
  String get drankToday => 'Сегодня Вы выпили';

  @override
  String get linkSent => 'Ссылка отправлена';

  @override
  String checkEmail(String email) {
    return 'Проверьте почту $email и нажмите на ссылку в письме';
  }

  @override
  String get sendAgain => 'Отправить снова';

  @override
  String get enterEmailHint => 'Введите email — туда придёт ссылка для входа';

  @override
  String get sendLink => 'Отправить ссылку';

  @override
  String get invalidEmail => 'Введите корректный email';

  @override
  String checkEmailRegister(String email) {
    return 'Проверьте почту $email и нажмите на ссылку — аккаунт создастся автоматически.';
  }

  @override
  String get enterName => 'Введите имя';

  @override
  String get invalidWeight => 'Введите корректный вес (20–300 кг)';

  @override
  String ml(String amount) {
    return '$amount мл';
  }

  @override
  String get newContainer => 'Новая тара';

  @override
  String get tapHere => 'Жми сюда';

  @override
  String get deleteCard => 'Удалить карточку?';

  @override
  String confirmDeleteCard(String title) {
    return 'Вы уверены что хотите удалить \'$title\'?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get cardTitle => 'Название';

  @override
  String get enterTitle => 'Введите название';

  @override
  String get amountMl => 'Количество (мл)';

  @override
  String get invalidMl => 'Введите от 10 до 5000 мл';

  @override
  String get icon => 'Иконка';

  @override
  String get add => 'Добавить';

  @override
  String get unitMl => 'мл';

  @override
  String get weekMon => 'Пн';

  @override
  String get weekTue => 'Вт';

  @override
  String get weekWed => 'Ср';

  @override
  String get weekThu => 'Чт';

  @override
  String get weekFri => 'Пт';

  @override
  String get weekSat => 'Сб';

  @override
  String get weekSun => 'Вс';

  @override
  String get iconDroplet => 'Капля';

  @override
  String get iconGlass => 'Стакан';

  @override
  String get iconBottle => 'Бутылка';

  @override
  String get iconMug => 'Кружка';

  @override
  String get iconBucket => 'Ведро';

  @override
  String get iconPlate => 'Тарелка';

  @override
  String get faqQuestion1 => 'Как работает счётчик воды?';

  @override
  String get faqAnswer1 =>
      'Счётчик выпитой воды сбрасывается автоматически каждый день в полночь.';

  @override
  String get faqQuestion2 => 'Можно ли добавить свою тару?';

  @override
  String get faqAnswer2 =>
      'Да! На главном экране нажмите карточку \'Новая тара\' и введите название и объём. Для удаления — долгое нажатие на карточку.';

  @override
  String get defaultCardGlass => 'Стакан';

  @override
  String get defaultCardBottle => 'Бутылка';

  @override
  String get chooseLanguage => 'Выберите свой язык';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'Английский';

  @override
  String get anonymousUserName => 'Гость';
}
