import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import 'package:uuid/uuid.dart';

class HabitModel extends Equatable {
  String id;
  String title;
  String description;
  String time;
  String reminder;
  DateTime startDay;
  DateTime endDay;
  List<int> schedule;
  String type;
  List<Completed> completes;
  int status;
  int isDelete;
  int color;
  String icon;

  HabitModel(
      {this.id,
        this.title,
        this.description,
        this.schedule,
        this.time,
        this.startDay,
        this.endDay,
        this.reminder,
        this.type,
        this.completes,
        this.isDelete,
        this.color,
        this.icon,
        this.status});

  bool getDayStatus(DateTime day) {
    if (completes.isEmpty) {
      return false;
    }
    Completed time = completes.firstWhere((element) {
      return element.date.millisecondsSinceEpoch ==
          DateTime(day.year, day.month, day.day).millisecondsSinceEpoch && element.skip == 0;
    }, orElse: () => null);
    if (time != null) {
      return true;
    }
    return false;
  }

  double get progress {
    return completes.length / 30;
  }

  Color getColor(BuildContext context) {
    return intToColor(context, color);
  }

  isSkip(int day) {
    if (completes.isEmpty) {
      return false;
    }
    Completed completed = completes.firstWhere(
            (element) =>
        element.date.millisecondsSinceEpoch == day && element.skip == 1,
        orElse: () => null);
    if (completed != null) {
      return true;
    }
    return false;
  }

  static HabitModel fromMap(Map<String, dynamic> map) {
    HabitModel model = HabitModel()
      ..id = map['id'] ?? ""
      ..title = map['title'] ?? ""
      ..description = map['description'] ?? ""
      ..time = map['time'] ?? ""
      ..startDay = getDate(map['start'])
      ..endDay = getDate(map['end'])
      ..reminder = map['reminder'] ?? ""
      ..type = map['type'] ?? ""
      ..status = map['status'] ?? ""
      ..color = map['color'] ?? -1
      ..icon = map['icon'] ?? "ic_ego.svg"
      ..isDelete = map['isDelete'] ?? "";
    if (map['schedule'] != null) {
      model.schedule = List.from(jsonDecode(map['schedule']));
    }
    model.completes = [];
    if (map['completes'] != null) {
      model.completes = List.from(map['completes']);
    }

    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? Uuid().v1(),
      "title": title,
      "description": description,
      "schedule": jsonEncode(schedule),
      "time": time,
      "start": startDay.millisecondsSinceEpoch,
      "end": endDay.millisecondsSinceEpoch,
      "reminder": reminder,
      "isDelete": isDelete ?? 0,
      "type": type ?? HabitType.normalType,
      "color": color ?? -1,
      "icon": icon ?? "ic_ego.svg",
      "status": status ?? HabitStatus.open,
    };
  }

  @override
  List<Object> get props => [
    id,
    title,
    description,
    schedule,
    time,
    startDay,
    endDay,
    reminder,
    type,
    completes,
    status,
    color,
    icon,
  ];
}

class Completed extends Equatable {
  String id;
  String habitId;
  DateTime date;
  int skip;

  Completed({this.id, this.habitId, this.date, this.skip});

  static Completed fromMap(Map<String, dynamic> map) {
    Completed model = Completed()
      ..id = map['id'] ?? ""
      ..habitId = map["habit_id"] ?? ""
      ..date = getDate(map['date'])
      ..skip = toInt(map['skip']);
    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? Uuid().v1(),
      "habit_id": habitId ?? "",
      "date": date.millisecondsSinceEpoch,
      "skip": skip ?? 0
    };
  }

  @override
  List<Object> get props => [id, habitId, date, skip];
}

class HabitType {
  static final int normalType = 0;
}

class HabitStatus {
  static final int open = 1;
  static final int finish = 0;
}

class Schedule {
  static final int no = 0;
  static final int yes = 1;
}
