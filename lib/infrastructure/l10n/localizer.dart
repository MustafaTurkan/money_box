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
    String get completed => Intl.message('Completed');

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
