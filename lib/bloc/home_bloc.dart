import 'dart:async';

import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/session.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc {
  HomeBloc(HabitRepository repository, Session session) : super(repository, session);

  final _habits = BehaviorSubject<List<HabitModel>>();
  final _routines = BehaviorSubject<List<HabitModel>>();
  final _openHabits = BehaviorSubject<List<HabitModel>>();
  final _finishHabits = BehaviorSubject<List<HabitModel>>();
  final _daySelected = BehaviorSubject<DateTime>();
  final _deleteHabit = BehaviorSubject<HabitModel>();

  Stream<List<HabitModel>> get habitsStream => _habits.stream;

  Stream<List<HabitModel>> get routinesStream => _routines.stream;

  Stream<List<HabitModel>> get openHabitsStream => _openHabits.stream;

  Stream<HabitModel> get deleteHabitStream => _deleteHabit.stream;

  Sink<List<HabitModel>> get openHabitsSink => _openHabits.sink;

  Stream<List<HabitModel>> get finishHabitsStream => _finishHabits.stream;

  Sink<List<HabitModel>> get finishHabitsSink => _finishHabits.sink;

  Sink<DateTime> get daySelectedSink => _daySelected.sink;

  DateTime get daySelected => _daySelected.value;

  @override
  void dispose() {
    super.dispose();
    _openHabits.close();
    _finishHabits.close();
    _habits.close();
    _daySelected.close();
    _deleteHabit.close();
    _routines.close();
  }

  @override
  void init() {
    streamSubs.add(_getAllHabitByDay());
    _getHabitOpen();
  }

  @override
  void reload() {
    _getAllHabit();
  }

  StreamSubscription _getAllHabitByDay() {
    return _daySelected.throttleTime(Duration(microseconds: 1)).listen((event) {
      _getAllHabit();
    });
  }

  _getAllHabit() {
    repository.getAllHabits().then((data) {
      if (data == null) return;
      _habits.add(data);
      getHabitByStatus();
    });
  }

  _getHabitOpen() {
    repository.getAllHabitsOpen().then((data) {
      if (data != null) {
        _routines.add(data);
      }
    });
  }

  void getHabitByStatus() async{
    if (_habits.value == null) return;
    List<HabitModel> openHabit = [];
    List<HabitModel> finishHabit = [];
    await Future.forEach(_habits.value, (habit) async{
      await repository.getCompleteByHabitId(habit.id).then((completed) {
        habit..completes = completed;
        if (habit.schedule[daySelected.weekday - 1] == Schedule.yes &&
            daySelected.millisecondsSinceEpoch >= habit.startDay.millisecondsSinceEpoch) {
          if (!habit.getDayStatus(daySelected)) {
            openHabit.add(habit);
          } else {
            finishHabit.add(habit);
          }
        }
      });
    });
    _openHabits.add(openHabit);
    _finishHabits.add(finishHabit);
  }

  void updateHabit(HabitModel habit, {bool checked}) {
    Completed completed = Completed(habitId: habit.id, date: daySelected);
    if (checked != null) {
      Completed currentCompleted = habit.completes.firstWhere(
              (complete) => complete.date.millisecondsSinceEpoch == daySelected.millisecondsSinceEpoch, orElse: () => null);
      if (checked) {
        if (currentCompleted != null){
          repository.deleteCompleted(currentCompleted.id).then((value) {
            _getAllHabit();
          });
        }

      } else {
        repository.addCompleted(completed).then((value) {
          _getAllHabit();
        });
      }
    }
  }

  Future deleteHabit(HabitModel habitModel) async {
    repository.updateHabit(habitModel).then((value) {
      if (value != null && value >= 0 && habitModel.isDelete == 1) {
        _deleteHabit.add(habitModel);
      }
      _getAllHabit();
    });
  }

  //skip habit
  void skipHabit(HabitModel habitModel) {
    bool isSkip = habitModel.isSkip(daySelected.millisecondsSinceEpoch);
    repository.getCompleteByHabitIdAndDay(habitModel.id, daySelected.millisecondsSinceEpoch).then((data){
      if (data == null) {
        //add new
        Completed completed = Completed(habitId: habitModel.id, date: daySelected, skip: isSkip ? 0 : 1);
        repository.addCompleted(completed).then((value) {
          _getAllHabit();
        });
      } else {
        Completed completed = data..skip =  isSkip ? 0 : 1;
        repository.updateCompleted(completed).then((value) {
          _getAllHabit();
        });
      }
    });
  }
}
