import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/ads/banner_admob.dart';
import 'package:habits_tracker/bloc/habit_detail_bloc.dart';
import 'package:habits_tracker/bloc/home_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/navigator.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/ui/new/habit_new_page.dart';
import 'package:habits_tracker/ui/widgets/appbar_bottom_sheet.dart';
import 'package:habits_tracker/ui/widgets/circle_progress_bar.dart';
import 'package:habits_tracker/ui/widgets/date_picker/calendar.dart';
import 'package:habits_tracker/ui/widgets/date_picker/calendar_controller.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/calendar_style.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/days_of_week_style.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/header_style.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import "package:habits_tracker/utils/ext/string_ext.dart";

class HabitDetailPage extends StatefulWidget {
  final HabitModel habit;
  final DateTime daySelect;
  final HomeBloc bloc;

  HabitDetailPage({@required this.habit, @required this.daySelect, this.bloc});

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage>
    with TickerProviderStateMixin {
  final _bloc = Injection.injector.get<HabitDetailBloc>();
  CalendarController _calendarController;
  AnimationController _hideFabAnimation;
  final int totalCount = 30;
  HabitModel _newHabit;
  //BannerAd _bannerAd;
  @override
  void initState() {
    super.initState();
    _bloc.setCurrentScreen(widget.runtimeType.toString());
    //_bannerAd = loadBannerAd();
    //_bannerAd?.show(anchorOffset: 10);

    _newHabit = widget.habit;
    _bloc.habitSink.add(widget.habit);
    _calendarController = CalendarController();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _hideFabAnimation.dispose();
    //_bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HabitDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar();
    return Container(
      height: MediaQuery.of(context).size.height - appbar.preferredSize.height,
      decoration: new BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          AppbarBottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            leftWidget: ImageAssets.svgAssets(ImageAssets.ic_back,
                height: 32,
                width: 32,
                color: Theme.of(context).textTheme.bodyText2.color),
            onTapLeft: () {
              if (widget.habit == _newHabit) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop(_newHabit);
              }
            },
            rightWidget: Row(
              children: [
                InkWell(
                  onTap: () async {
                    HabitModel habit = widget.habit..isDelete = 1;
                    widget.bloc
                        .deleteHabit(habit)
                        .then((value) => Navigator.of(context).pop(habit));
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    HabitModel result = await showModalBottomPage(
                        context,
                        HabitNewPage(
                          habitModel: _newHabit,
                        ));
                    if (result != null) {
                      if (result.schedule[widget.daySelect.weekday - 1] ==
                          Schedule.no) {
                        Navigator.of(context).pop(result);
                      } else {
                        _bloc.getHabitById(result.id);
                        _newHabit = result;
                      }
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _body()),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }

  _body() {
    return StreamBuilder<HabitModel>(
        stream: _bloc.habitStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final data = snapshot.data;
          return Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                _getTitleHabit(data),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: _getDetailHabit(data))
              ],
            ),
          );
        });
  }

  _getTitleHabit(HabitModel habitModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habitModel.title.capitalize(),
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 10,
        ),
        Text(convertSchedules(habitModel.schedule)),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _getTime(Icons.schedule, habitModel.time),
            SizedBox(
              width: 30,
            ),
            _getTime(Icons.alarm, habitModel.reminder),
          ],
        )
      ],
    );
  }

  _getTime(IconData icon, String time) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: 5,
        ),
        Text(time)
      ],
    );
  }

  _getDetailHabit(HabitModel habitModel) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
              _getCalendar(habitModel),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _streak(getBestStreak(habitModel.completes)),
                  _goalWeek(getBestStreakInWeek(habitModel.completes),
                      DateTime.daysPerWeek),
                ],
              ),
              SizedBox(height: 30),
              _getProgress(habitModel),
              SizedBox(height: 30),
            ]))
      ],
    );
  }

  _getCalendar(HabitModel habitModel) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: TableCalendar(
        events: _getEvents(habitModel),
        calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.horizontalSwipe,
        calendarStyle: CalendarStyle(
          selectedColor: Theme.of(context).errorColor,
          todayColor: Theme.of(context).errorColor,
          markersColor: Colors.brown[700],
          outsideDaysVisible: true,
          highlightToday: false,
          highlightSelected: false,
          weekdayStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          weekendStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          todayStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
          selectedStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
          eventDayStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        initialCalendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonTextStyle:
          TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepOrange[400],
            borderRadius: BorderRadius.circular(16.0),
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          centerHeaderTitle: true,
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white),
            weekdayStyle: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white)),
        onDaySelected: _onDaySelected,
        onVisibleDaysChanged: _onVisibleDaysChanged,
        onCalendarCreated: _onCalendarCreated,
      ),
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {});
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  _streak(int count) {
    return Column(
      children: [
        Text(
          S.of(context).currentStreak,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "$count days",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).primaryColor),
        )
      ],
    );
  }

  _goalWeek(int count, int goal) {
    return Column(
      children: [
        Text(
          S.of(context).weeklyGoal,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "$count/$goal days",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).primaryColor),
        )
      ],
    );
  }

  Widget _getProgress(HabitModel habitModel) {
    return Container(
      child: Center(
        child: CircleProgressBar(
          size: 230.0,
          backgroundColor: Colors.grey[200],
          foregroundColor: Theme.of(context).primaryColor,
          strokeWidth: 30,
          initialValue: habitModel.completes.length.toDouble() ?? 0,
          min: 0,
          max: 30,
          innerWidget: Text("${habitModel.completes.length ?? 0}/$totalCount",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Theme.of(context).accentColor)),
        ),
      ),
    );
  }

  Map<DateTime, List> _getEvents(HabitModel habitModel) {
    return Map.fromIterable(habitModel.completes,
        key: (e) => e.date, value: (e) => []);
  }
}
