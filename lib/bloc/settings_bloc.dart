import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/session.dart';

class SettingsBloc extends BaseBloc {
  SettingsBloc(HabitRepository repository, Session session) : super(repository, session);

  bool get isShowNotification => repository.localRepository.preferences.isShowNotification;

  @override
  void init() {}

  @override
  void reload() {}

  @override
  void dispose() {
    super.dispose();
  }

  void changeTheme(int value) {
    repository.localRepository.preferences.setLightTheme(value == 0);
  }

  int get themeValue {
    if (repository.localRepository.preferences.isLightTheme ?? true) {
      return 0;
    } else {
      return 1;
    }
  }

  void setIsNotification(bool isShow) {
    repository.localRepository.preferences.setIsShowNotification(isShow);
  }
}
