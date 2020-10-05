import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/session.dart';

class TabBloc extends BaseBloc {
  TabBloc(HabitRepository repository, Session session) : super(repository, session);

  bool get isFirstOpen => repository.localRepository.preferences.isFirstOpen;
  @override
  void init() {
  }

  @override
  void reload() {
  }

  void setIsFirstOpen(bool isFirstOpen) {
    repository.localRepository.preferences.setFirstOpen(isFirstOpen);
  }
}