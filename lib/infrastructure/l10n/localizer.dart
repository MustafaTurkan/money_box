import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'locales/messages_all.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'dart:ui' as ui;

class Localizer {
  // workaroud for contextless translation
  // see https://github.com/flutter/flutter/issues/14518#issuecomment-447481671
  static Localizer instance;

  static Future<Localizer> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = Localizer();
      return instance;
    });
  }

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  String get appName => Intl.message('Money Box');
  String get goals => Intl.message('Goals');
  String get recordNotFound => Intl.message('Record not found!');
  String get noData => Intl.message('No data');
  String get dontHaveActiveGoals => Intl.message('You do not have any active goal');
  String get dontHaveCompletedGoals => Intl.message('You do not have any completed goal');
  String get anUnExpectedErrorOccurred => Intl.message('An unexpected error occurred!');
  String get addGoal => Intl.message('Add Goal');
  String get loading => Intl.message('Loading...');
  String get search => Intl.message('Search');
  String get completed => Intl.message('Completed');
  String get addPhoto => Intl.message('Add Picture');
  String get title => Intl.message('Title');
  String get goalAmount => Intl.message('Goal Amount');
  String get goalDate => Intl.message('Goal Date');
  String get congratulations => Intl.message('Congratulations you achieved your goal');
  String get ok => Intl.message('OK');
  String get yes => Intl.message('Yes');
  String get no => Intl.message('No');
  String get cancel => Intl.message('Cancel');
  String get close => Intl.message('Close');
  String get warning => Intl.message('Warning');
  String get error => Intl.message('Error');
  String get information => Intl.message('Information');
  String get question => Intl.message('Question');
  String get message => Intl.message('Message');
  String get requiredValue => Intl.message('Required');
  String get mustBeGreaterThanZero => Intl.message('Must be greater than zero');
  String get periodless => Intl.message('periodless');
  String get savingPeriod => Intl.message('Saving Period');
  String get daily => Intl.message('daily');
  String get weekly => Intl.message('weekly');
  String get monthly => Intl.message('monthly');
  String get total => Intl.message('Total');
  String get totalCompletedAmount => Intl.message('Total Completed Amount');
  String get deposited => Intl.message('Deposited');
  String get remaining => Intl.message('Remaining');
  String get note => Intl.message('Note');
  String get complatedGoals => Intl.message('Complated Goals');
  String get incrementMoney => Intl.message('Increment Money');
  String get decrementMoney => Intl.message('Decrement Money');
    String get totalDeposited => Intl.message('Total Deposited');
  String get contributions => Intl.message('Contributions');
  String get goalDeleteMessage => Intl.message('Goal is being deleted');
  String get dontFindCompletedGoal => Intl.message('You do not find a goal completed yet');
  String mustBeGreaterThanValue(String value) =>
      Intl.message('Must be greater than $value', name: 'mustBeGreaterThanValue', args: [value]);

  //dynamic text translate
  String translate(String text,
      {String desc = '',
      Map<String, Object> examples = const {},
      String locale,
      String name,
      List<Object> args,
      String meaning,
      bool skip}) {
    return Intl.message(text,
        desc: desc, examples: examples, locale: locale, name: name, args: args, meaning: meaning, skip: skip);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localizer> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocale.supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return Localizer.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localizer> old) {
    return false;
  }
}

class AppLocale with ChangeNotifier {
  AppLocale({String languageCode}) {
    if (!languageCode.isNullOrWhiteSpace() && supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      _locale = Locale(languageCode);
    }
  }

  Locale _locale;

  Locale get locale => _locale ?? ui.window.locale;

  static Iterable<Locale> get supportedLocales {
    return [const Locale('en'), const Locale('tr')];
  }

  void setLocale(Locale locale) {
    assert(locale != null);
    if (locale == null || !supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      debugPrint('Un supported App locale :${locale.languageCode}');
      //throw AppError(message: 'Un supported App locale :${locale.languageCode}');
    }
    if (_locale == null || _locale.languageCode != locale.languageCode) {
      _locale = locale;
      notifyListeners();
    }
  }
}
