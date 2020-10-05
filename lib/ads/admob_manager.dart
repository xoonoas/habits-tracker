import 'package:firebase_admob/firebase_admob.dart';

class AdmobManager {
  bool _isInit = false;
  String appID = FirebaseAdMob.testAppId;

  init() async {
    _isInit = await FirebaseAdMob.instance.initialize(appId: appID);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    //testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  void dispose() {
    _isInit = false;
  }
}