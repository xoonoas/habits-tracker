import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:habits_tracker/ads/interstitial.dart';
import 'package:habits_tracker/bloc/habit_detail_bloc.dart';
import 'package:habits_tracker/bloc/habit_new_bloc.dart';
import 'package:habits_tracker/bloc/habit_progress_bloc.dart';
import 'package:habits_tracker/bloc/home_bloc.dart';
import 'package:habits_tracker/bloc/premium_bloc.dart';
import 'package:habits_tracker/bloc/settings_bloc.dart';
import 'package:habits_tracker/bloc/tab_bloc.dart';
import 'package:habits_tracker/local_notification.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/habit_repository_imp.dart';
import 'package:habits_tracker/repository/local/database/habit_database.dart';
import 'package:habits_tracker/repository/local/database/habit_database_imp.dart';
import 'package:habits_tracker/repository/local/local_repository.dart';
import 'package:habits_tracker/repository/local/local_repository_imp.dart';
import 'package:habits_tracker/repository/local/preference/preferences.dart';
import 'package:habits_tracker/repository/local/preference/preferences_impl.dart';
import 'package:habits_tracker/repository/remote/firebase_analytics_service.dart';
import 'package:habits_tracker/repository/remote/remote_config.dart';
import 'package:habits_tracker/repository/remote/remote_repository.dart';
import 'package:habits_tracker/repository/remote/remote_repository_imp.dart';
import 'package:habits_tracker/repository/session.dart';

class Injection {
  static Injector injector;
  static Preferences preferences = PreferencesImpl();
  static initInjection() async {
    await preferences.initPreferences();
    injector = Injector.getInjector();
    final remoteConfig = await RemoteConfigService.getInstance();
    await remoteConfig.initialise();
    injector.map<FirebaseAnalyticsService>((injector) => FirebaseAnalyticsService());
    final analyticsService = injector.get<FirebaseAnalyticsService>();
    injector.map<LocalNotification>((injector) => LocalNotification(), isSingleton: true);
    injector.map<Session>((injector) => Session(analyticsService, preferences), isSingleton: true);
    final session = injector.get<Session>();
    injector.map<Preferences>((injector) => PreferencesImpl());
    injector.map<Interstitial>((injector) => Interstitial(preferences, remoteConfig), isSingleton: true);
    injector.map<HabitDatabase>((injector) => HabitDatabaseImp(), isSingleton: true);
    final database = injector.get<HabitDatabase>();
    injector.map<LocalRepository>((injector) => LocalRepositoryImp(database, preferences), isSingleton: true);
    final localRepository = injector.get<LocalRepository>();
    injector.map<RemoteRepository>((injector) => RemoteRepositoryImp(), isSingleton: true);
    final remoteRepository = injector.get<RemoteRepository>();
    injector.map<HabitRepository>((injector) => HabitRepositoryImp(localRepository, remoteRepository, session),
        isSingleton: true);
    final repository = injector.get<HabitRepository>();
    injector.map<HomeBloc>((injector) => HomeBloc(repository, session));
    injector.map<HabitNewBloc>((injector) => HabitNewBloc(repository, session));
    injector.map<HabitDetailBloc>((injector) => HabitDetailBloc(repository, session));
    injector.map<HabitProgressBloc>((injector) => HabitProgressBloc(repository, session));
    injector.map<SettingsBloc>((injector) => SettingsBloc(repository, session));
    injector.map<PremiumBloc>((injector) => PremiumBloc(repository, session));
    injector.map<TabBloc>((injector) => TabBloc(repository, session));
  }
}
