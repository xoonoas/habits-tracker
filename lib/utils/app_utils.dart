import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final googlePlayLink = "https://play.google.com/store/apps/details?id=";
final List<String> weeksStartMon = [
  S.current.mon,
  S.current.tue,
  S.current.wed,
  S.current.thu,
  S.current.fri,
  S.current.sat,
  S.current.sun
];
final List<String> weeksStartSun = [
  S.current.sun,
  S.current.mon,
  S.current.tue,
  S.current.wed,
  S.current.thu,
  S.current.fri,
  S.current.sat
];

final List<String> optionReminder = [
  S.current.none,
  S.current.before15,
  S.current.before30,
  S.current.before1h,
  S.current.customTime,
];

List<Color> listColorsPicker(BuildContext context) {
  return [
    Theme.of(context).cardColor,
    Provider.of<ThemeNotifier>(context).customColor.colorRed,
    Provider.of<ThemeNotifier>(context).customColor.colorPink,
    Provider.of<ThemeNotifier>(context).customColor.colorPurple,
    Provider.of<ThemeNotifier>(context).customColor.colorIndigo,
    Provider.of<ThemeNotifier>(context).customColor.colorCyan,
    Provider.of<ThemeNotifier>(context).customColor.colorGreen,
    Provider.of<ThemeNotifier>(context).customColor.colorYellow,
    Provider.of<ThemeNotifier>(context).customColor.colorOrange,
    Provider.of<ThemeNotifier>(context).customColor.colorBrown,
  ];
}

Color intToColor(BuildContext context, int index) {
  switch (index) {
    case 0:
      return Theme.of(context).cardColor;
    case 1:
      return Provider.of<ThemeNotifier>(context).customColor.colorRed;
    case 2:
      return Provider.of<ThemeNotifier>(context).customColor.colorPink;
    case 3:
      return Provider.of<ThemeNotifier>(context).customColor.colorPurple;
    case 4:
      return Provider.of<ThemeNotifier>(context).customColor.colorIndigo;
    case 5:
      return Provider.of<ThemeNotifier>(context).customColor.colorCyan;
    case 6:
      return Provider.of<ThemeNotifier>(context).customColor.colorGreen;
    case 7:
      return Provider.of<ThemeNotifier>(context).customColor.colorYellow;
    case 8:
      return Provider.of<ThemeNotifier>(context).customColor.colorOrange;
    case 9:
      return Provider.of<ThemeNotifier>(context).customColor.colorBrown;
    default:
      return Theme.of(context).cardColor;
  }
}

List<String> devicesIcon = [
  'ic_airplane.svg',
  'ic_camera.svg',
  'ic_camera2.svg',
  'ic_desktop_mac.svg',
  'ic_keyboard.svg',
  'ic_laptop.svg',
  'ic_mic.svg',
  'ic_mouse.svg',
  'ic_refrigerator.svg',
  'ic_phone_close.svg',
  'ic_smartphone.svg',
  'ic_speaker.svg',
  'ic_tivi.svg',
  'ic_train.svg',
  'ic_voice.svg',
  'ic_watch.svg',
  'ic_acong.svg',
  'ic_call.svg',
  'ic_headset.svg',
];

List<String> sportIcon = [
  'ic_basketball.svg',
  'ic_cycling.svg',
  'ic_fitness.svg',
  'ic_football.svg',
  'ic_golf.svg',
  'ic_motor.svg',
  'ic_motorbike.svg',
  'ic_rugby.svg',
  'ic_tennis.svg',
  'ic_volleyball.svg',
  'ic_yoga.svg',
  'ic_soccer.svg',
  'ic_cricket.svg',
];

List<String> emotionIcon = [
  'ic_child.svg',
  'ic_circle_avatar.svg',
  'ic_emoticon.svg',
];

List<String> otherIcon = [
  'ic_article.svg',
  'ic_bar_chart.svg',
  'ic_beach.svg',
  'ic_color.svg',
  'ic_comment.svg',
  'ic_alarm.svg',
  'ic_anchor.svg',
  'ic_book.svg',
  'ic_brush.svg',
  'ic_clef.svg',
  'ic_cloud.svg',
  'ic_eco.svg',
  'ic_error.svg',
  'ic_event.svg',
  'ic_explore.svg',
  'ic_eyes.svg',
  'ic_face.svg',
  'ic_fire.svg',
  'ic_flag.svg',
  'ic_folder.svg',
  'ic_grass.svg',
  'ic_heart.svg',
  'ic_identity.svg',
  'ic_invert.svg',
  'ic_language.svg',
  'ic_mail.svg',
  'ic_menu_book.svg',
  'ic_money.svg',
  'ic_moon.svg',
  'ic_pets.svg',
  'ic_picture.svg',
  'ic_polymer.svg',
  'ic_restaurant.svg',
  'ic_school.svg',
  'ic_scissors.svg',
  'ic_shopping.svg',
  'ic_snowball.svg',
  'ic_sopha.svg',
  'ic_spa.svg',
  'ic_star.svg',
  'ic_sunny.svg',
  'ic_thumb.svg',
  'ic_umbrella.svg',
  'ic_verified.svg',
  'ic_virus.svg',
  'ic_volume.svg',
  'ic_wash.svg',
  'ic_whistle.svg',
  'ic_child.svg',
  'ic_circle_avatar.svg',
  'ic_emoticon.svg',
];

Color getColorLuminance(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

String convertSchedules(List<int> schedules) {
  String result = "";
  int count = 0;
  if (schedules[0] == 1) {
    result += S.current.mon;
    count++;
  }
  if (schedules[1] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.tue;
    count++;
  }
  if (schedules[2] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.wed;
    count++;
  }
  if (schedules[3] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.thu;
    count++;
  }
  if (schedules[4] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.fri;
    count++;
  }
  if (schedules[5] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.sat;
    count++;
  }
  if (schedules[6] == 1) {
    if (result.isNotEmpty) result += "-";
    result += S.current.sun;
    count++;
  }
  if (count == 7) {
    return "${S.current.daily}, ${S.current.mon} - ${S.current.sun}";
  } else {
    return "${S.current.weekly}, $result";
  }
}

DateTime getFirstDayOfWeek() {
  DateTime today = DateTime.now();
  int day = (today.weekday + 6) % 7;
  return today.subtract(Duration(days: day));
}

int getBestStreakInWeek(List<Completed> completes) {
  DateTime firstDay = getFirstDayOfWeek();
  int mon = DateTime(firstDay.year, firstDay.month, firstDay.day)
      .millisecondsSinceEpoch;
  int tue = DateTime(firstDay.year, firstDay.month, firstDay.day + 1)
      .millisecondsSinceEpoch;
  int wed = DateTime(firstDay.year, firstDay.month, firstDay.day + 2)
      .millisecondsSinceEpoch;
  int thu = DateTime(firstDay.year, firstDay.month, firstDay.day + 3)
      .millisecondsSinceEpoch;
  int fri = DateTime(firstDay.year, firstDay.month, firstDay.day + 4)
      .millisecondsSinceEpoch;
  int sat = DateTime(firstDay.year, firstDay.month, firstDay.day + 5)
      .millisecondsSinceEpoch;
  int sun = DateTime(firstDay.year, firstDay.month, firstDay.day + 6)
      .millisecondsSinceEpoch;
  int streakWeek = 0;
  completes.forEach((e) {
    if (e.date.millisecondsSinceEpoch == mon ||
        e.date.millisecondsSinceEpoch == tue ||
        e.date.millisecondsSinceEpoch == wed ||
        e.date.millisecondsSinceEpoch == thu ||
        e.date.millisecondsSinceEpoch == fri ||
        e.date.millisecondsSinceEpoch == sat ||
        e.date.millisecondsSinceEpoch == sun) {
      streakWeek += 1;
    }
  });
  return streakWeek;
}

int getBestStreak(List<Completed> completes) {
  int bestStreak = 0;
  if (completes.isNotEmpty) {
    int i = 0;
    while (i < completes.length) {
      int current_streak = 1;
      while (i < completes.length - 1 &&
          completes[i + 1].date.millisecondsSinceEpoch ==
              completes[i].date.millisecondsSinceEpoch + 86400000) {
        current_streak += 1;
        i += 1;
      }
      if (current_streak == 1) {
        i += 1;
      }
      bestStreak = max(bestStreak, current_streak);
    }
  }
  return bestStreak;
}

TimeOfDay stringToHour(String hour) {
  if (hour == null || hour.isEmpty) return null;
  final format = DateFormat.Hm();
  return TimeOfDay.fromDateTime(format.parse(hour));
}

double toDouble(value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  double result;
  if (value is num) {
    result = value.toDouble();
  } else if (value is String && value.isNotEmpty) {
    result = double.tryParse(value);
  }
  return result ?? defaultValue;
}

int toInt(value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  int result;
  if (value is num) {
    result = value.toInt();
  } else if (value is String && value.isNotEmpty) {
    result = int.tryParse(value);
  }
  return result ?? defaultValue;
}

bool toBool(value, [bool defaultValue = false]) {
  if (value == null) return defaultValue;

  if (value is bool) {
    return value;
  }
  final String strValue = value.toString()?.toLowerCase();
  if (strValue == 'true' || strValue == '1') {
    return true;
  } else if (strValue == 'false' || strValue == '0') {
    return false;
  }
  return defaultValue;
}

DateTime getDate(value) {
  if (value == null) return null;
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is num || toDouble(value) > 0) {
    return _getDateFromUnixTimeStamp(value.toString());
  } else if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }
  try {
    return value.toDate();
  } catch (e) {
    return null;
  }
}

_getDateFromUnixTimeStamp(String unixTime) {
  if (unixTime == null || unixTime.isEmpty) return null;
  if (unixTime.length <= 10) {
    return DateTime.fromMillisecondsSinceEpoch(
        toDouble(unixTime).toInt() * 1000);
  } else {
    return DateTime.fromMillisecondsSinceEpoch(toDouble(unixTime).toInt());
  }
}
