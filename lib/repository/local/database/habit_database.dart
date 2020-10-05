import 'dart:async';
import 'dart:io';

import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class HabitDatabase {
  static final _DATABASE_NAME = "habit_database.db";
  static final _DATABASE_VERSION = 1;
  static final HABIT_TABLE = "habit_table";
  static final ID_COLUMN = "id";
  static final TITLE_COLUMN = "title";
  static final DES_COLUMN = "description";
  static final TIME_COLUMN = "time";
  static final START_COLUMN = "start";
  static final END_COLUMN = "end";
  static final SCHEDULE_COLUMN = "schedule";
  static final REMINDER_COLUMN = "reminder";
  static final TYPE_COLUMN = "type";
  static final COMPLETES_COLUMN = "completes";
  static final STATUS_COLUMN = "status";
  static final ICON_COLUMN = "icon";
  static final COLOR_COLUMN = "color";
  static final DELETE_COLUMN = "isDelete";
  static final COMPLETED_TABLE = "completed_table";
  static final HABIT_ID_COLUMN = "habit_id";
  static final DATE_COLUMN = "date";
  static final SKIP_COLUMN = "skip";

  static final CREATE_HABIT_TABLE = '''
    CREATE TABLE $HABIT_TABLE (
          $ID_COLUMN TEXT PRIMARY KEY,
          $TITLE_COLUMN TEXT NOT NULL,
          $DES_COLUMN TEXT,
          $TIME_COLUMN TEXT,
          $START_COLUMN INTEGER,
          $END_COLUMN INTEGER,
          $SCHEDULE_COLUMN TEXT,
          $REMINDER_COLUMN TEXT,
          $TYPE_COLUMN TEXT,
          $ICON_COLUMN TEXT,
          $COMPLETES_COLUMN TEXT,
          $STATUS_COLUMN INTEGER,
          $COLOR_COLUMN INTEGER,
          $DELETE_COLUMN INTEGER
        )
  ''';

  static final CREATE_COMPLETED_TABLE = '''
    CREATE TABLE $COMPLETED_TABLE (
          $ID_COLUMN TEXT PRIMARY KEY,
          $HABIT_ID_COLUMN TEXT NOT NULL,
          $DATE_COLUMN INTEGER,
          $SKIP_COLUMN INTEGER,
          FOREIGN KEY($HABIT_ID_COLUMN) REFERENCES $HABIT_TABLE($ID_COLUMN) ON UPDATE CASCADE ON DELETE CASCADE
        )
  ''';

  static final QUERY_HABIT = '''
    SELECT * FROM $HABIT_TABLE
    LEFT JOIN $COMPLETED_TABLE ON $HABIT_TABLE.$ID_COLUMN = $COMPLETED_TABLE.$HABIT_ID_COLUMN
  ''';

  static String queryById(id) {
    return '''
    SELECT * FROM $HABIT_TABLE, $COMPLETED_TABLE
    WHERE $HABIT_TABLE.$ID_COLUMN = $COMPLETED_TABLE.$HABIT_ID_COLUMN, $HABIT_TABLE.$ID_COLUMN = $id, $HABIT_TABLE.$DELETE_COLUMN = 0
  ''';
  }

  static String queryByStatus() {
    return '''
    SELECT * FROM $HABIT_TABLE, $COMPLETED_TABLE
    WHERE $HABIT_TABLE.$ID_COLUMN = $COMPLETED_TABLE.$HABIT_ID_COLUMN, $HABIT_TABLE.$STATUS_COLUMN = 1, $HABIT_TABLE.$DELETE_COLUMN = 0
  ''';
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _DATABASE_NAME);
    return await openDatabase(path,
        version: _DATABASE_VERSION, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(CREATE_HABIT_TABLE);
    await db.execute(CREATE_COMPLETED_TABLE);
  }

  Future<int> insert(HabitModel habitModel);

  Future<List<HabitModel>> queryAllHabits();

  Future<HabitModel> queryHabitById(String id);

  Future<List<HabitModel>> queryHabitsByStatus(int status);

  Future<int> update(HabitModel habitModel);

  Future<int> delete(String id);

  Future<List<HabitModel>> queryHabitsOpen();

  Future<int>addCompleted(Completed completed);

  Future<int> deleteCompleted(String id);

  Future<List<Completed>> getCompleteByHabitId(String id);

  Future<List<Completed>> getNumberHabitOfDate(int startDate, int endDate);

  Future<Completed> getCompleteByHabitIdAndDay(String id, int day);

  Future<int> updateCompleted(Completed completed);
}
