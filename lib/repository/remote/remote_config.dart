import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

const String interval_admob = "interval_admob";
const String app_update = "app_update";

class RemoteConfigService {
  final defaults = <String, dynamic>{
    'interval_admob': 30,
    'app_update': '{"versionCode":1, versionName: "1.0.0", "url": ""}',
  };
  final RemoteConfig remoteConfig;
  static RemoteConfigService _instance;

  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance =
          RemoteConfigService(remoteConfig: await RemoteConfig.instance);
    }
    return _instance;
  }

  RemoteConfigService({this.remoteConfig});

  Future initialise() async {
    try {
      await remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  Future _fetchAndActivate() async {
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
  }

  int get intervalAds => remoteConfig.getInt(interval_admob);

  AppUpdate getUpdateApp() {
    final update = remoteConfig.getString(app_update);
    try {
      if (update.isNotEmpty) {
        return AppUpdate.fromJson(update);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class AppUpdate {
  int versionCode;
  String versionName;
  String url;

  AppUpdate({this.versionCode, this.versionName, this.url});

  factory AppUpdate.fromJson(String str) => AppUpdate.fromMap(json.decode(str));

  factory AppUpdate.fromMap(Map<String, dynamic> json) {
    return AppUpdate(
      versionCode: json["versionCode"] == null ? '' : json["versionCode"],
      versionName: json["versionName"] == null ? '' : json["versionName"],
      url: json["url"] == null ? '' : json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "versionCode": versionCode,
      "versionName": versionName,
      "url": url,
    };
  }
}
