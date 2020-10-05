abstract class Preferences {
  final String keyLightTheme = 'lightTheme';
  final String keyFirstOpen = 'firstOpen';
  final String keyLastShowInterstitial = 'lastShowInterstitial';
  final String keyIsShowNotification = 'isShowNotification';

  Future initPreferences();

  bool get isLightTheme;

  bool get isFirstOpen;

  int get lastShowInterstitial;

  bool get isShowNotification;

  void setLightTheme(bool isLight);

  void setFirstOpen(bool isFirst);

  void setLastShowInterstitial(int time);

  void setIsShowNotification(bool isShow);
}
