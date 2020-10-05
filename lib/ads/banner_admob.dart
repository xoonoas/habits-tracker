import 'package:firebase_admob/firebase_admob.dart';

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    //targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

BannerAd loadBannerAd() {
  return createBannerAd()..load();
}
