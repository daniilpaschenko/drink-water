import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Drink Water'**
  String get appTitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @unitL.
  ///
  /// In en, this message translates to:
  /// **'l'**
  String get unitL;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @wantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get wantToLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutFromAccount.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account'**
  String get logoutFromAccount;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get outOf;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @aboutAppText.
  ///
  /// In en, this message translates to:
  /// **' — an app for tracking water consumption. It helps you monitor your daily intake by logging the amount of water you drink.'**
  String get aboutAppText;

  /// No description provided for @dailyGoalFormula.
  ///
  /// In en, this message translates to:
  /// **'Daily intake formula'**
  String get dailyGoalFormula;

  /// No description provided for @formulaRule.
  ///
  /// In en, this message translates to:
  /// **'Intake = weight (kg) × 33 ml'**
  String get formulaRule;

  /// No description provided for @formulaExample.
  ///
  /// In en, this message translates to:
  /// **'For example, at 70 kg:\n70 × 33 = 2310 ml = 2.31 l'**
  String get formulaExample;

  /// No description provided for @formulaLimits.
  ///
  /// In en, this message translates to:
  /// **'Minimum intake: 1.5 l\nMaximum intake: 4 l'**
  String get formulaLimits;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @devContacts.
  ///
  /// In en, this message translates to:
  /// **'Developer contacts'**
  String get devContacts;

  /// No description provided for @drinkWaterSlogan.
  ///
  /// In en, this message translates to:
  /// **'Drink water — stay healthy'**
  String get drinkWaterSlogan;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram: @daniil_paschenko'**
  String get telegram;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub: github.com/daniilpaschenko'**
  String get github;

  /// No description provided for @addWaterPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add the amount of water you drank:'**
  String get addWaterPrompt;

  /// No description provided for @longPressToDelete.
  ///
  /// In en, this message translates to:
  /// **'(Long press on a card to delete it)'**
  String get longPressToDelete;

  /// No description provided for @todayEntries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entries'**
  String get todayEntries;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @drankToday.
  ///
  /// In en, this message translates to:
  /// **'Today you drank'**
  String get drankToday;

  /// No description provided for @linkSent.
  ///
  /// In en, this message translates to:
  /// **'Link sent'**
  String get linkSent;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox at {email} and click the link in the email'**
  String checkEmail(String email);

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email — we\'ll send you a sign-in link'**
  String get enterEmailHint;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get sendLink;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @checkEmailRegister.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox at {email} and click the link — your account will be created automatically.'**
  String checkEmailRegister(String email);

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight (20–300 kg)'**
  String get invalidWeight;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'{amount} ml'**
  String ml(String amount);

  /// No description provided for @newContainer.
  ///
  /// In en, this message translates to:
  /// **'New container'**
  String get newContainer;

  /// No description provided for @tapHere.
  ///
  /// In en, this message translates to:
  /// **'Tap here'**
  String get tapHere;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete card?'**
  String get deleteCard;

  /// No description provided for @confirmDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{title}\'?'**
  String confirmDeleteCard(String title);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cardTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get cardTitle;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// No description provided for @amountMl.
  ///
  /// In en, this message translates to:
  /// **'Amount (ml)'**
  String get amountMl;

  /// No description provided for @invalidMl.
  ///
  /// In en, this message translates to:
  /// **'Enter between 10 and 5000 ml'**
  String get invalidMl;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @weekMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekMon;

  /// No description provided for @weekTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekTue;

  /// No description provided for @weekWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekWed;

  /// No description provided for @weekThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekThu;

  /// No description provided for @weekFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekFri;

  /// No description provided for @weekSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekSat;

  /// No description provided for @weekSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekSun;

  /// No description provided for @iconDroplet.
  ///
  /// In en, this message translates to:
  /// **'Droplet'**
  String get iconDroplet;

  /// No description provided for @iconGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get iconGlass;

  /// No description provided for @iconBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get iconBottle;

  /// No description provided for @iconMug.
  ///
  /// In en, this message translates to:
  /// **'Mug'**
  String get iconMug;

  /// No description provided for @iconBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket'**
  String get iconBucket;

  /// No description provided for @iconPlate.
  ///
  /// In en, this message translates to:
  /// **'Bowl'**
  String get iconPlate;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How does the water counter work?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'The water counter resets automatically every day at midnight.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Can I add my own container?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Yes! On the home screen tap the \'New container\' card and enter a name and volume. To delete — long press the card.'**
  String get faqAnswer2;

  /// No description provided for @defaultCardGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get defaultCardGlass;

  /// No description provided for @defaultCardBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get defaultCardBottle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
