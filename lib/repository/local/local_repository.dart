import 'package:habits_tracker/repository/local/database/habit_database.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/local/preference/preferences.dart';

abstract class LocalRepository {
  final HabitDatabase habitDatabase;
  final Preferences preferences;

  LocalRepository(this.habitDatabase, this.preferences);

  Future<int> insert(HabitModel habitModel);

  Future<List<HabitModel>> getAllHabits();

  Future<HabitModel> getHabitById(String id);

  Future<List<HabitModel>> getHabitsByStatus(int status);

  Future<int> update(HabitModel habitModel);

  Future<int> delete(String id);

  Future<List<HabitModel>> getAllHabitsOpen();

  Future<int> addCompleted(Completed completed);

  Future<int> deleteCompleted(String id);

  Future<List<Completed>> getCompleteByHabitId(String id);

  Future<List<Completed>> getNumberHabitOfDate(int startDate, int endDate);

  Future<Completed> getCompleteByHabitIdAndDay(String id, int day);

  Future<int> updateCompleted(Completed completed);
}
