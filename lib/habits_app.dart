import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/repository/remote/firebase_analytics_service.dart';
import 'package:habits_tracker/theme/theme.dart';
import 'package:habits_tracker/ui/onboarding/onboarding_page.dart';
import 'package:habits_tracker/ui/tab_page.dart';
import 'package:provider/provider.dart';

final localizationsDelegates = <LocalizationsDelegate>[
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class HabitApp extends StatelessWidget {
  final bool isLight;
  final _analytics = Injection.injector.get<FirebaseAnalyticsService>();
  final _pref = Injection.preferences;
  HabitApp(this.isLight);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: "Habit App",
      debugShowCheckedModeBanner: false,
      initialRoute: _pref.isFirstOpen ? '/onboarding' : '/',
      //navigatorObservers: <NavigatorObserver>[session.observer],
      theme: themeNotifier.getTheme(),
      navigatorObservers: [_analytics.analyticsObserver],
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routes: {
        '/': (context) => TabPage(),
        '/onboarding': (context) => OnboardingPage(),
      },
    );
  }
}