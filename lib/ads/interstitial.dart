import 'package:firebase_admob/firebase_admob.dart';
import 'package:habits_tracker/repository/local/preference/preferences.dart';
import 'package:habits_tracker/repository/remote/remote_config.dart';

class Interstitial {
  String interstitialID = InterstitialAd.testAdUnitId;
  InterstitialAd _interstitialAd;
  bool isReloaded = false;
  final Preferences _pref;
  final RemoteConfigService _remoteConfigService;

  Interstitial(this._pref, this._remoteConfigService);

  InterstitialAd buildInterstitialAd() {
    _interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
        } else if (event == MobileAdEvent.failedToLoad) {
          _interstitialAd..load();
        } else if (event == MobileAdEvent.closed) {
          _interstitialAd..load();
        }
        print("InterstitialAd $event");
      },
    );
    return _interstitialAd;
  }

  Future<bool> showInterstitialAd() async {
    if (isShow()) {
      return _interstitialAd.show().then((value) {
        _pref.setLastShowInterstitial(DateTime.now().millisecondsSinceEpoch);
        return value;
      });
    }
    return false;
  }

  void loadInterstitialAd() {
    if (_interstitialAd == null) {
      _interstitialAd = buildInterstitialAd();
    }
    _interstitialAd.load();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  bool isShow() {
    return DateTime.now().millisecondsSinceEpoch -
        _remoteConfigService.intervalAds * 1000 >
        _pref.lastShowInterstitial;
  }
}
