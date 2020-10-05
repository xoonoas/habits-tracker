import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/local/model/chart_model.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/session.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class HabitProgressBloc extends BaseBloc {

  HabitProgressBloc(HabitRepository repository, Session session) : super(repository, session);

  final _habits = BehaviorSubject<List<HabitModel>>();

  final _habitsOpen = BehaviorSubject<List<HabitModel>>();

  final _chartWeek = BehaviorSubject<List<ChartModel>>();

  final _chartMonth = BehaviorSubject<List<ChartModel>>();

  final _chartYear = BehaviorSubject<List<ChartModel>>();

  Stream<List<HabitModel>> get habitsStream => _habits.stream;

  Stream<List<HabitModel>> get habitsOpenStream => _habitsOpen.stream;

  Stream<List<ChartModel>> get chartWeekStream => _chartWeek.stream;

  Stream<List<ChartModel>> get chartMonthStream => _chartMonth.stream;

  Stream<List<ChartModel>> get chartYearStream => _chartYear.stream;

  int habitCompletes = 0;

  @override
  void init() {
    _getAllHabit();
    _getAllHabitOpen();
    _getHabitThisWeek();
    _getHabitThisMonth();
    _getHabitThisYear();
  }

  @override
  void reload() {}

  @override
  void dispose() {
    _habits.close();
    _habitsOpen.close();
    _chartWeek.close();
    _chartMonth.close();
    _chartYear.close();
    super.dispose();
  }

  _getAllHabit() {
    repository.getAllHabits().then((data) {
      if (data != null) {
        _habits.add(data);
        data.forEach((habit) {
          if (habit.status == HabitStatus.finish) {
            habitCompletes++;
          }
        });
      }
    });
  }

  _getAllHabitOpen() {
    repository.getAllHabitsOpen().then((data) {
      if (data != null) {
        data.sort((a, b) => a.completes.length.compareTo(b.completes.length));
        _habitsOpen.add(data);
      }
    });
  }

  _getHabitThisWeek() {
    DateTime first = getFirstDayOfWeek();
    int mon = first.millisecondsSinceEpoch;
    int sun =
        DateTime(first.year, first.month, first.day + 6).millisecondsSinceEpoch;
    repository.getNumberHabitOfDate(mon, sun).then((data) {
      if (data == null || data.isEmpty) return;
      List<ChartModel> charts = [];
      List<int> value = [0,0,0,0,0,0,0];
      data.forEach((completed) {
        value[completed.date.weekday-1]++;
      });
      value.asMap().forEach((index, e) {
        charts.add(ChartModel(title: index+1, value: e.toDouble()));
      });
      _chartWeek.add(charts);
    });
  }

  _getHabitThisMonth() {
    var now = new DateTime.now();
    DateTime firstDayMonth = DateTime(now.year, now.month, 1);
    var lastDayMonth = (now.month < 12) ? new DateTime(now.year, now.month + 1, 0) : new DateTime(now.year + 1, 1, 0);
    repository.getNumberHabitOfDate(firstDayMonth.millisecondsSinceEpoch, lastDayMonth.millisecondsSinceEpoch).then((data) {
      if (data == null || data.isEmpty) return;
      List<ChartModel> charts = [];
      List<int> value = List.filled(lastDayMonth.day, 0);
      data.forEach((completed) {
        value[completed.date.day-1]++;
      });
      value.asMap().forEach((index, e) {
        charts.add(ChartModel(title: index+1, value: e.toDouble()));
      });
      _chartMonth.add(charts);
    });
  }

  _getHabitThisYear() {
    var now = new DateTime.now();
    DateTime firstDay = DateTime(now.year, 1, 1);
    var lastDay = new DateTime(now.year + 1, 1, 0);
    repository.getNumberHabitOfDate(firstDay.millisecondsSinceEpoch, lastDay.millisecondsSinceEpoch).then((data) {
      if (data == null || data.isEmpty) return;
      List<ChartModel> charts = [];
      List<int> value = List.filled(12,0);
      data.forEach((completed) {
        value[completed.date.month-1]++;
      });
      value.asMap().forEach((index, e) {
        charts.add(ChartModel(title: index+1, value: e.toDouble()));
      });
      _chartYear.add(charts);
    });
  }

}
