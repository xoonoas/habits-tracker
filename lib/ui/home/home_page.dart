import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habits_tracker/ads/interstitial.dart';
import 'package:habits_tracker/bloc/home_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/local_notification.dart';
import 'package:habits_tracker/navigator.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/ui/detail/habit_detail_page.dart';
import 'package:habits_tracker/ui/new/habit_new_page.dart';
import 'package:habits_tracker/ui/widgets/circle_checkbox.dart';
import 'package:habits_tracker/ui/widgets/date_picker/calendar.dart';
import 'package:habits_tracker/ui/widgets/date_picker/calendar_controller.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/calendar_style.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/days_of_week_style.dart';
import 'package:habits_tracker/ui/widgets/date_picker/customization/header_style.dart';
import 'package:habits_tracker/ui/widgets/disable_over_scroll_behavior.dart';
import 'package:habits_tracker/ui/widgets/first_habit.dart';
import 'package:habits_tracker/ui/widgets/toast.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import "package:habits_tracker/utils/ext/string_ext.dart";
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  CalendarController _calendarController;
  AnimationController _hideFabAnimation;
  final _bloc = Injection.injector.get<HomeBloc>();
  final _interstitial = Injection.injector.get<Interstitial>();
  DateTime _dayInWeek =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  StreamSubscription _subs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.setCurrentScreen(widget.runtimeType.toString());
    _interstitial.loadInterstitialAd();
    _bloc.daySelectedSink.add(_dayInWeek);
    _calendarController = CalendarController();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    _listen();
  }

  _listen() {
    _subs = _bloc.deleteHabitStream.listen((habit) {
      if (habit != null) {
        showSnackBar(
          context,
          '${habit.title} has been delete',
          label: S.of(context).undo,
          action: () {
            _bloc.deleteHabit(habit..isDelete = 0);
          },
        );
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 1) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            if (userScroll.metrics.pixels ==
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            return true;
            break;
        }
      }
    }
    return true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context).isCurrent;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _hideFabAnimation.dispose();
    _bloc.dispose();
    _subs.cancel();
    _interstitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: Container(
            child: Column(
              children: [
                _getCalendar(),
                Expanded(
                  child: _getListHabit(),
                )
              ],
            )),
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            label: Text(
              S.of(context).createHabit,
              style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white),
            ),
            onPressed: () async {
              final result = await showModalBottomPage(context, HabitNewPage());
              if (result != null) {
                _bloc.reload();
              }
            },
          ),
        ),
      ),
    );
  }

  _getCalendar() {
    return Material(
      elevation: 2.0,
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*Text(
                    "${S.of(context).goodMorning},",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontSize: 26, color: Color(0xB3000000)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Shaba",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 30,
                  ),*/
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            _dayInWeek
                                .difference(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ))
                                .inDays !=
                                0
                                ? DateFormat.yMMMM()
                                .format(_dayInWeek)
                                .toUpperCase()
                                : S.of(context).today.toUpperCase(),
                            style:
                            Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TableCalendar(
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                selectedColor: Theme.of(context).primaryColor,
                todayColor: Theme.of(context).primaryColor.withOpacity(0.5),
                markersColor: Colors.brown[700],
                outsideDaysVisible: false,
                weekdayStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w500),
                weekendStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w500),
                outsideWeekendStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w500),
                todayStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                selectedStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              initialCalendarFormat: CalendarFormat.week,
              headerVisible: false,
              headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.only(left: 16, bottom: 12),
                  formatButtonVisible: false,
                  titleTextBuilder: (selectedDate, locale) {
                    return DateFormat.yMMMM()
                        .format(selectedDate)
                        .toUpperCase();
                  },
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w500),
                  showLeftChevron: false,
                  showRightChevron: false),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: Theme.of(context).textTheme.caption,
                  weekdayStyle: Theme.of(context).textTheme.caption),
              onDaySelected: _onDaySelected,
              onVisibleDaysChanged: _onVisibleDaysChanged,
              onCalendarCreated: _onCalendarCreated,
            ),
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _dayInWeek = day;
      _bloc.daySelectedSink.add(_dayInWeek);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  _getListHabit() {
    return ScrollConfiguration(
      behavior: DisableOverScrollBehavior(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 2 / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[300])),
                margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  tabs: [
                    Tab(
                      child: Text(S.of(context).daily),
                    ),
                    Tab(
                      child: Text(S.of(context).all),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [_getDailyHabit(), _getAllHabit()]),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getHabit(List<HabitModel> habits) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = habits[index];
        return _itemHabit(item);
      },
      itemCount: habits.length,
    );
  }

  _getHabitDone(List<HabitModel> habits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).done,
          style: Theme.of(context).textTheme.headline6,
        ),
        _getHabit(habits)
      ],
    );
  }

  _itemHabit(HabitModel habit) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
        color: habit.getColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _interstitial
                  .showInterstitialAd()
                  .then((value) => _showDetailHabit(habit));
            },
            child: Ink(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: Row(
                children: [
                  ImageAssets.svgAssets(ImageAssets.serverIconMap[habit.icon],
                      width: 35,
                      height: 35,
                      color: getColorLuminance(habit.getColor(context))),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title.isEmpty ? "" : habit.title.capitalize(),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                              getColorLuminance(habit.getColor(context))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              habit.time,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                  fontSize: 14,
                                  color: getColorLuminance(
                                      habit.getColor(context))),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            if (habit.reminder != null &&
                                habit.reminder?.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    habit.reminder,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                        fontSize: 14,
                                        color: getColorLuminance(
                                            habit.getColor(context))),
                                  ),
                                ],
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !habit.isSkip(_dayInWeek.millisecondsSinceEpoch),
                    child: CircleCheckBox(
                      habit.getDayStatus(_dayInWeek),
                      size: 28,
                      selectedColor: Theme.of(context).primaryColor,
                      onTap: (checked) {
                        _bloc.updateHabit(habit,
                            checked: habit.getDayStatus(_dayInWeek));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        /*SlideAction(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.archive, color: Colors.white,),
              ),
              SizedBox(height: 5,),
              Text("Archive", style: Theme.of(context).textTheme.caption,)
            ],
          ),
        ),*/
        SlideAction(
          onTap: () {
            _bloc.skipHabit(habit);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: habit.isSkip(_dayInWeek.millisecondsSinceEpoch)
                      ? Colors.green
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  habit.isSkip(_dayInWeek.millisecondsSinceEpoch)
                      ? Icons.arrow_back
                      : Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                habit.isSkip(_dayInWeek.millisecondsSinceEpoch)
                    ? S.of(context).unskip
                    : S.of(context).skip,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
      ],
      secondaryActions: <Widget>[
        SlideAction(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                S.of(context).delete,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          onTap: () => _deleteHabit(habit),
        ),
      ],
    );
  }

  _getDailyHabit() {
    return StreamBuilder<List<HabitModel>>(
        stream: _bloc.openHabitsStream,
        builder: (context, openSnapshot) {
          return StreamBuilder<List<HabitModel>>(
              stream: _bloc.finishHabitsStream,
              builder: (context, finishSnapshot) {
                if (!openSnapshot.hasData && !finishSnapshot.hasData)
                  return Container();
                if (openSnapshot.data.isEmpty && finishSnapshot.data.isEmpty)
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FirstHabit(
                      title: S.of(context).startHomeNewHabit,
                    ),
                  );
                bool isOpen =
                    openSnapshot.hasData && openSnapshot.data.isNotEmpty;
                bool isFinish =
                    finishSnapshot.hasData && finishSnapshot.data.isNotEmpty;
                final openData = openSnapshot.data;
                final finishData = finishSnapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      isOpen ? _getHabit(openData) : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      isFinish ? _getHabitDone(finishData) : Container()
                    ],
                  ),
                );
              });
        });
  }

  _getAllHabit() {
    return StreamBuilder<List<HabitModel>>(
        stream: _bloc.habitsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          if (snapshot.data.isEmpty)
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FirstHabit(
                title: S.of(context).startHomeNewHabit,
              ),
            );
          final data = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              child: _getHabit(data),
            ),
          );
        });
  }

  _showDetailHabit(HabitModel habitModel) async {
    final result = await showModalBottomPage(context,
        HabitDetailPage(habit: habitModel, daySelect: _dayInWeek, bloc: _bloc));
    if (result != null) {
      _bloc.reload();
    }
  }

  _deleteHabit(HabitModel habitModel) {
    _bloc.deleteHabit(habitModel..isDelete = 1);
  }
}
