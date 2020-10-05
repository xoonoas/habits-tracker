import 'package:habits_tracker/repository/local/preference/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl extends Preferences {
  SharedPreferences _prefs;

  @override
  Future initPreferences() async =>
      _prefs = await SharedPreferences.getInstance();

  @override
  bool get isLightTheme => _prefs.getBool(keyLightTheme) ?? true;

  @override
  void setLightTheme(bool isLight) {
    _prefs.setBool(keyLightTheme, isLight);
  }

  @override
  bool get isFirstOpen => _prefs.getBool(keyFirstOpen) ?? true;

  @override
  void setFirstOpen(bool isFirst) {
    _prefs.setBool(keyFirstOpen, isFirst);
  }

  @override
  int get lastShowInterstitial =>
      _prefs.getInt(keyLastShowInterstitial) ??
          DateTime.now().millisecondsSinceEpoch;

  @override
  void setLastShowInterstitial(int time) {
    _prefs.setInt(keyLastShowInterstitial, time);
  }

  @override
  bool get isShowNotification => _prefs.getBool(keyIsShowNotification) ?? true;

  @override
  void setIsShowNotification(bool isShow) {
    _prefs.setBool(keyIsShowNotification, isShow);
  }
}
