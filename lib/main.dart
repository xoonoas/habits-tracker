import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/habits_app.dart';
import 'package:habits_tracker/local_notification.dart';
import 'package:habits_tracker/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.initInjection();
  await FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  final _pref = Injection.preferences;
  final _notifi = Injection.injector.get<LocalNotification>();
  await _notifi.initLocalNotification();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(buildTheme(_pref.isLightTheme), buildCustomColor(_pref.isLightTheme)),
    child: HabitApp(_pref.isLightTheme),
  ));
}
