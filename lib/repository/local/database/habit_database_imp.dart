import 'package:habits_tracker/repository/local/database/habit_database.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:sqflite/sqflite.dart';

class HabitDatabaseImp extends HabitDatabase {
  HabitDatabaseImp();

  @override
  Future<int> delete(String id) async {
    Database db = await database;
    return await db.delete(HabitDatabase.HABIT_TABLE,
        where: '${HabitDatabase.ID_COLUMN} = ?', whereArgs: [id]);
  }

  @override
  Future<int> insert(HabitModel habitModel) async {
    Database db = await database;
    return db.insert(HabitDatabase.HABIT_TABLE, habitModel.toMap());
  }

  @override
  Future<List<HabitModel>> queryAllHabits() async {
    Database db = await database;
    return db.query(HabitDatabase.HABIT_TABLE,
        where: '${HabitDatabase.DELETE_COLUMN} = ?',
        whereArgs: [
          0
        ]).then(
            (data) => data.map((habit) => HabitModel.fromMap(habit)).toList());
  }

  @override
  Future<List<HabitModel>> queryHabitsByStatus(int status) async {
    Database db = await database;
    return db.query(HabitDatabase.HABIT_TABLE,
        where: '${HabitDatabase.STATUS_COLUMN} = ?',
        whereArgs: [
          status
        ]).then(
            (data) => data.map((habit) => HabitModel.fromMap(habit)).toList());
  }

  @override
  Future<int> update(HabitModel habitModel) async {
    Database db = await database;
    return await db.update(HabitDatabase.HABIT_TABLE, habitModel.toMap(),
        where: "${HabitDatabase.ID_COLUMN} = ?", whereArgs: [habitModel.id]);
  }

  @override
  Future<HabitModel> queryHabitById(String id) async {
    Database db = await database;
    return db.query(HabitDatabase.HABIT_TABLE,
        where:
        '${HabitDatabase.ID_COLUMN} = ? AND ${HabitDatabase.DELETE_COLUMN} = ?',
        whereArgs: [id, 0]).then((data) => HabitModel.fromMap(data.first));
  }

  @override
  Future<List<HabitModel>> queryHabitsOpen() async {
    Database db = await database;
    return db.query(HabitDatabase.HABIT_TABLE,
        where: '${HabitDatabase.STATUS_COLUMN} = ?',
        whereArgs: [
          1
        ]).then(
            (data) => data.map((habit) => HabitModel.fromMap(habit)).toList());
  }

  @override
  Future<int> addCompleted(Completed completed) async {
    Database db = await database;
    return db.insert(HabitDatabase.COMPLETED_TABLE, completed.toMap());
  }

  @override
  Future<int> deleteCompleted(String id) async {
    Database db = await database;
    return await db.delete(HabitDatabase.COMPLETED_TABLE,
        where: '${HabitDatabase.ID_COLUMN} = ?', whereArgs: [id]);
  }

  @override
  Future<List<Completed>> getCompleteByHabitId(String id) async {
    Database db = await database;
    return db.query(HabitDatabase.COMPLETED_TABLE,
        where: '${HabitDatabase.HABIT_ID_COLUMN} = ?',
        whereArgs: [
          id
        ]).then((data) =>
        data.map((completed) => Completed.fromMap(completed)).toList());
  }

  @override
  Future<List<Completed>> getNumberHabitOfDate(
      int startDate, int endDate) async {
    Database db = await database;
    return db.query(HabitDatabase.COMPLETED_TABLE,
        where: '${HabitDatabase.DATE_COLUMN} BETWEEN ? AND ? ',
        whereArgs: [
          startDate,
          endDate
        ]).then((data) =>
        data.map((completed) => Completed.fromMap(completed)).toList());
  }

  @override
  Future<Completed> getCompleteByHabitIdAndDay(String id, int day) async {
    Database db = await database;
    return db.query(HabitDatabase.COMPLETED_TABLE,
        where:
        '${HabitDatabase.HABIT_ID_COLUMN} = ? AND ${HabitDatabase.DATE_COLUMN} = ?',
        whereArgs: [id, day]).then((data) {
      if (data.isNotEmpty) {
        return Completed.fromMap(data?.first);
      }
      return null;
    });
  }

  @override
  Future<int> updateCompleted(Completed completed) async {
    Database db = await database;
    return await db.update(HabitDatabase.COMPLETED_TABLE, completed.toMap(),
        where: "${HabitDatabase.ID_COLUMN} = ?", whereArgs: [completed.id]);
  }
}
