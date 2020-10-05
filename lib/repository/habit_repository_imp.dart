import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/local/local_repository.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/repository/remote/remote_repository.dart';
import 'package:habits_tracker/repository/session.dart';

class HabitRepositoryImp extends HabitRepository {
  HabitRepositoryImp(
      LocalRepository localRepository, RemoteRepository remoteRepository, Session session)
      : super(localRepository, remoteRepository, session);

  @override
  Future<int> deleteHabit(String id) async {
    return await localRepository.delete(id);
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    return await localRepository.getAllHabits();
  }

  @override
  Future<List<HabitModel>> getHabitsByStatus(int status) async {
    return await localRepository.getHabitsByStatus(status);
  }

  @override
  Future<int> insertHabit(HabitModel habitModel) async {
    return await localRepository.insert(habitModel);
  }

  @override
  Future<int> updateHabit(HabitModel habitModel) async {
    return await localRepository.update(habitModel);
  }

  @override
  Future<HabitModel> getHabitsById(String id) async {
    return await localRepository.getHabitById(id);
  }

  @override
  Future<List<HabitModel>> getAllHabitsOpen() async {
    return await localRepository.getAllHabitsOpen();
  }

  @override
  Future<int> addCompleted(Completed completed) async {
    return await localRepository.addCompleted(completed);
  }

  @override
  Future<int> deleteCompleted(String id) async {
    return await localRepository.deleteCompleted(id);
  }

  @override
  Future<List<Completed>> getCompleteByHabitId(String id) async {
    return await localRepository.getCompleteByHabitId(id);
  }

  @override
  Future<List<Completed>> getNumberHabitOfDate(int startDate, int endDate) async{
    return await localRepository.getNumberHabitOfDate(startDate, endDate);
  }

  @override
  Future<Completed> getCompleteByHabitIdAndDay(String id, int day) async{
    return await localRepository.getCompleteByHabitIdAndDay(id,day);
  }

  @override
  Future<int> updateCompleted(Completed completed) async{
    return await localRepository.updateCompleted(completed);
  }
}
