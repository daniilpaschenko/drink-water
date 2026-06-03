// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Drink Water';

  @override
  String get name => 'Name';

  @override
  String get weight => 'Weight';

  @override
  String get kg => 'kg';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get unitL => 'l';

  @override
  String get email => 'Email';

  @override
  String get wantToLogout =>
      'Are you sure you want to log out of your account?';

  @override
  String get wantToLogoutAnonymous =>
      'You are signed in anonymously. All data will be deleted on sign out. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Log out';

  @override
  String get logoutFromAccount => 'Log out of your account';

  @override
  String get welcome => 'Welcome!';

  @override
  String get register => 'Register';

  @override
  String get login => 'Log in';

  @override
  String get anonymousLogin => 'Continue anonymously';

  @override
  String get loggedInAnonymously => 'You are signed in anonymously';

  @override
  String get outOf => 'out of';

  @override
  String get success => 'Success!';

  @override
  String get aboutApp => 'About the app';

  @override
  String get aboutAppText =>
      ' — an app for tracking water consumption. It helps you monitor your daily intake by logging the amount of water you drink.';

  @override
  String get dailyGoalFormula => 'Daily intake formula';

  @override
  String get formulaRule => 'Intake = weight (kg) × 33 ml';

  @override
  String get formulaExample =>
      'For example, at 70 kg:\n70 × 33 = 2310 ml = 2.31 l';

  @override
  String get formulaLimits => 'Minimum intake: 1.5 l\nMaximum intake: 4 l';

  @override
  String get faq => 'FAQ';

  @override
  String get devContacts => 'Developer contacts';

  @override
  String get drinkWaterSlogan => 'Drink water — stay healthy';

  @override
  String get telegram => 'Telegram: @daniil_paschenko';

  @override
  String get github => 'GitHub: github.com/daniilpaschenko';

  @override
  String get addWaterPrompt => 'Add the amount of water you drank:';

  @override
  String get longPressToDelete => '(Long press on a card to delete it)';

  @override
  String get todayEntries => 'Today\'s entries';

  @override
  String get hello => 'Hello';

  @override
  String get drankToday => 'Today you drank';

  @override
  String get linkSent => 'Link sent';

  @override
  String checkEmail(String email) {
    return 'Check your inbox at $email and click the link in the email';
  }

  @override
  String get sendAgain => 'Send again';

  @override
  String get enterEmailHint =>
      'Enter your email — we\'ll send you a sign-in link';

  @override
  String get sendLink => 'Send link';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String checkEmailRegister(String email) {
    return 'Check your inbox at $email and click the link — your account will be created automatically.';
  }

  @override
  String get enterName => 'Enter your name';

  @override
  String get invalidWeight => 'Enter a valid weight (20–300 kg)';

  @override
  String ml(String amount) {
    return '$amount ml';
  }

  @override
  String get newContainer => 'New container';

  @override
  String get tapHere => 'Tap here';

  @override
  String get deleteCard => 'Delete card?';

  @override
  String confirmDeleteCard(String title) {
    return 'Are you sure you want to delete \'$title\'?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get cardTitle => 'Title';

  @override
  String get enterTitle => 'Enter title';

  @override
  String get amountMl => 'Amount (ml)';

  @override
  String get invalidMl => 'Enter between 10 and 5000 ml';

  @override
  String get icon => 'Icon';

  @override
  String get add => 'Add';

  @override
  String get unitMl => 'ml';

  @override
  String get weekMon => 'Mon';

  @override
  String get weekTue => 'Tue';

  @override
  String get weekWed => 'Wed';

  @override
  String get weekThu => 'Thu';

  @override
  String get weekFri => 'Fri';

  @override
  String get weekSat => 'Sat';

  @override
  String get weekSun => 'Sun';

  @override
  String get iconDroplet => 'Droplet';

  @override
  String get iconGlass => 'Glass';

  @override
  String get iconBottle => 'Bottle';

  @override
  String get iconMug => 'Mug';

  @override
  String get iconBucket => 'Bucket';

  @override
  String get iconPlate => 'Bowl';

  @override
  String get faqQuestion1 => 'How does the water counter work?';

  @override
  String get faqAnswer1 =>
      'The water counter resets automatically every day at midnight.';

  @override
  String get faqQuestion2 => 'Can I add my own container?';

  @override
  String get faqAnswer2 =>
      'Yes! On the home screen tap the \'New container\' card and enter a name and volume. To delete — long press the card.';

  @override
  String get defaultCardGlass => 'Glass';

  @override
  String get defaultCardBottle => 'Bottle';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';
}
