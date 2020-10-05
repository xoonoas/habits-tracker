import 'package:habits_tracker/repository/local/database/habit_database.dart';
import 'package:habits_tracker/repository/local/local_repository.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/local/preference/preferences.dart';

class LocalRepositoryImp extends LocalRepository {
  LocalRepositoryImp(HabitDatabase habitDatabase, Preferences preferences)
      : super(habitDatabase, preferences);

  @override
  Future<int> delete(String id) async {
    return await habitDatabase.delete(id);
  }

  @override
  Future<int> insert(HabitModel habitModel) async {
    return await habitDatabase.insert(habitModel);
  }

  @override
  Future<int> update(HabitModel habitModel) async {
    return await habitDatabase.update(habitModel);
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    return await habitDatabase.queryAllHabits();
  }

  @override
  Future<List<HabitModel>> getHabitsByStatus(int status) async {
    return await habitDatabase.queryHabitsByStatus(status);
  }

  @override
  Future<HabitModel> getHabitById(String id) async {
    return await habitDatabase.queryHabitById(id);
  }

  @override
  Future<List<HabitModel>> getAllHabitsOpen() async {
    return await habitDatabase.queryHabitsOpen();
  }

  @override
  Future<int> addCompleted(Completed completed) async {
    return await habitDatabase.addCompleted(completed);
  }

  @override
  Future<int> deleteCompleted(String id) async {
    return await habitDatabase.deleteCompleted(id);
  }

  @override
  Future<List<Completed>> getCompleteByHabitId(String id) async {
    return await habitDatabase.getCompleteByHabitId(id);
  }

  @override
  Future<List<Completed>> getNumberHabitOfDate(
      int startDate, int endDate) async {
    return await habitDatabase.getNumberHabitOfDate(startDate, endDate);
  }

  @override
  Future<Completed> getCompleteByHabitIdAndDay(String id, int day) async{
    return await habitDatabase.getCompleteByHabitIdAndDay(id,day);
  }

  @override
  Future<int> updateCompleted(Completed completed) async{
    return await habitDatabase.updateCompleted(completed);
  }
}
