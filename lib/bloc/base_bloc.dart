import 'dart:async';

import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/session.dart';

abstract class BaseBloc {
  HabitRepository repository;
  Session session;

  BaseBloc(this.repository, this.session) {
    init();
  }

  final streamSubs = List<StreamSubscription>();

  void init();

  void reload();

  void dispose() {
    streamSubs.forEach((str) {
      str?.cancel();
    });
  }

  Future<void> setCurrentScreen(String name, {String className}) async {
    print('Maboy - screenName - $name');
    session.setCurrentScreen(name, className: className);
  }

}
