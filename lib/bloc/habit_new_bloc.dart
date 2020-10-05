import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/session.dart';
import 'package:rxdart/rxdart.dart';

class HabitNewBloc extends BaseBloc {

  HabitNewBloc(HabitRepository repository, Session session) : super(repository, session);

  final _textError = BehaviorSubject<bool>();

  Stream<bool> get textErrorStream => _textError.stream;

  Sink<bool> get textErrorSink => _textError.sink;

  bool get isShowNotification =>
      repository.localRepository.preferences.isShowNotification;

  @override
  void dispose() {
    _textError.close();
    super.dispose();
  }

  @override
  void init() {}

  @override
  void reload() {}

  Future<int> saveHabit(HabitModel habit) async {
    if (!_validateHabit(habit)) {
      _textError.add(false);
      return -1;
    }
    _textError.add(true);
    return repository.insertHabit(habit);
  }

  Future<int> updateHabit(HabitModel habit) async {
    if (!_validateHabit(habit)) {
      _textError.add(false);
      return -1;
    }
    _textError.add(true);
    return repository.updateHabit(habit);
  }

  _validateHabit(HabitModel habit) {
    if (habit.title == null || habit.title.isEmpty) {
      return false;
    }
    return true;
  }
}
