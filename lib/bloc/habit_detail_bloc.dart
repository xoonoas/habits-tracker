import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/session.dart';
import 'package:rxdart/rxdart.dart';

class HabitDetailBloc extends BaseBloc {
  HabitDetailBloc(HabitRepository repository, Session session) : super(repository, session);

  final _habit = BehaviorSubject<HabitModel>();

  Stream<HabitModel> get habitStream => _habit.stream;

  Sink<HabitModel> get habitSink => _habit.sink;

  @override
  void init() {}

  @override
  void reload() {
  }

  getHabitById(String id) {
    repository.getHabitsById(id).then((habit) {
      if (habit != null) {
        _habit.add(habit);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _habit.close();
  }
}
