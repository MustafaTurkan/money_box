import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/ui/ui.dart';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';

import 'infrastructure/infrastructure.dart';

class App {
  Future<void> buildAppServices() async {

    AppService.addSingleton<AppNavigator>(
      AppNavigator(),
    );
    //database
    AppService.addSingleton<MoneyBoxDb>(
      MoneyBoxDb(),
    );
    var db = AppService.get<MoneyBoxDb>();
    await db.initialize();
    //repositories
    AppService.addTransient<IGoalRepository>(
      () => GoalRepository(db),
    );

    AppService.addTransient<IContributionRepository>(
      () => ContributionRepository(db),
    );
  }

  void setSystemChromeSettings() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> run() async {
    if (kReleaseMode) {
      debugPrint = (message, {wrapWidth}) {};
    }

    WidgetsFlutterBinding.ensureInitialized();
    setSystemChromeSettings();
    await buildAppServices();
    runApp(AppWidget('Money Box'));
  }
}

class AppWidget extends StatelessWidget {
  AppWidget(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [..._providers()],
      builder: (context, child) {
        return addBetaBanner(MaterialApp(
          locale: context.get<AppLocale>(listen: true).locale,
          localizationsDelegates: _localizationsDelegates(),
          supportedLocales: _supportedLocales(),
          title: title,
          builder: _builder,
          navigatorKey: AppNavigator.key,
          navigatorObservers: [AppNavigator.routeObserver],
          home: HomeView(),
        ));
      },
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = context.getTheme(listen: true);
    if (!theme.initialized) {
      theme.setTheme(buildDefaultTheme(context));
    }

    return Theme(data: theme.data, child: child);
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];
  }

  Iterable<Locale> _supportedLocales() {
    return AppLocale.supportedLocales;
  }

  String _getUserLanguage() {
    return null;
  }

  List<SingleChildWidget> _providers() {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(
        create: (_) => AppTheme(),
      ),
      ChangeNotifierProvider<AppLocale>(
        create: (_) => AppLocale(languageCode: _getUserLanguage()),
      )
    ];
  }

  Widget addBetaBanner(Widget child) {
    return Banner(
      location: kReleaseMode ? BannerLocation.topEnd : BannerLocation.topStart,
      message: 'BETA',
      layoutDirection: TextDirection.ltr,
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}



