import 'package:habits_tracker/repository/local/local_repository.dart';
import 'package:habits_tracker/repository/remote/remote_repository.dart';
import 'package:habits_tracker/repository/session.dart';

import 'local/model/habit_model.dart';

abstract class HabitRepository {
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;
  final Session session;
  HabitRepository(this.localRepository, this.remoteRepository, this.session);

  Future<int> insertHabit(HabitModel habitModel);

  Future<List<HabitModel>> getAllHabits();

  Future<List<HabitModel>> getAllHabitsOpen();

  Future<HabitModel> getHabitsById(String id);

  Future<List<HabitModel>> getHabitsByStatus(int status);

  Future<int> updateHabit(HabitModel habitModel);

  Future<int> deleteHabit(String id);

  Future<int> deleteCompleted(String id);

  Future<int> addCompleted(Completed completed);

  Future<List<Completed>> getCompleteByHabitId(String id);

  Future<List<Completed>> getNumberHabitOfDate(int startDate, int endDate);

  Future<Completed> getCompleteByHabitIdAndDay(String id, int day);

  Future<int> updateCompleted(Completed completed);
}
