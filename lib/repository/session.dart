import 'package:habits_tracker/repository/local/preference/preferences.dart';
import 'package:habits_tracker/repository/remote/firebase_analytics_service.dart';

class Session {
  final FirebaseAnalyticsService analyticsService;
  final Preferences _preferences;

  Session(this.analyticsService, this._preferences);

  Future<void> setCurrentScreen(String name, {String className}) async {
    await analyticsService.analytics?.setCurrentScreen(
      screenName: name,
      screenClassOverride: className ?? name,
    );
  }

}