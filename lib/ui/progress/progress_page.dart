import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/bloc/habit_progress_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/repository/local/model/chart_model.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/ui/widgets/circle_progress_bar.dart';
import 'package:habits_tracker/ui/widgets/first_habit.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import 'package:intl/intl.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _bloc = Injection.injector.get<HabitProgressBloc>();
  List<BarChartGroupData> showingBarGroups;

  @override
  void initState() {
    super.initState();
    _bloc.setCurrentScreen(this.runtimeType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).statistics,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 16.0, left: 10, right: 10),
          child: StreamBuilder<List<HabitModel>>(
              stream: _bloc.habitsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                final habits = snapshot.data;
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _getOverall(habits),
                        _getReport(),
                        _getTopHabit(habits),
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  _getOverall(List<HabitModel> habits) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).overall.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle2),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).totalHabit,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${habits.length}",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          S.of(context).completions,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${_bloc.habitCompletes}",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          S.of(context).incomplete,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${habits.length - _bloc.habitCompletes}",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _getCircleProgress(habits.length, _bloc.habitCompletes)
          ],
        ),
      ),
    );
  }

  _getReport() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 16),
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(S.of(context).report.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle2),
                  ),
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Theme.of(context).primaryColor,
                    labelPadding: EdgeInsets.only(left: 6, right: 6),
                    indicatorColor: Theme.of(context).primaryColor,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w400),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(S.of(context).week),
                      ),
                      Tab(
                        child: Text(S.of(context).month),
                      ),
                      Tab(
                        child: Text(S.of(context).year),
                      )
                    ],
                  )
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: 250,
                child: TabBarView(children: [
                  _getChartWeek(),
                  _getChartMonth(),
                  _getChartYear()
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getTopHabit(List<HabitModel> habits) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(S.of(context).topHabit.toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle2),
                ),
                InkWell(
                  onTap: () {
                    //Open view all habit
                  },
                  child: Text(
                    S.of(context).viewMore.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: StreamBuilder<List<HabitModel>>(
                  stream: _bloc.habitsOpenStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.isEmpty)
                      return FirstHabit(title: S.of(context).startNewHabit);
                    final data = snapshot.data;
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _itemHabit(data[index], index),
                      itemCount: data.length > 5 ? 5 : data.length,
                      separatorBuilder: (context, index) => Divider(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  _itemHabit(HabitModel habit, int index) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border:
              Border.all(width: 3, color: Theme.of(context).primaryColor)),
          child: Center(
            child: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: Text(
              "${habit.title}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
            )),
        Text(
          NumberFormat.percentPattern().format(habit.progress),
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
        )
      ],
    );
  }

  _getCircleProgress(int total, int initValue) {
    return Container(
      child: Center(
        child: CircleProgressBar(
          size: 150.0,
          backgroundColor: Colors.grey[200],
          foregroundColor: Theme.of(context).primaryColor,
          strokeWidth: 8,
          initialValue: initValue.toDouble() ?? 0,
          min: 0,
          max: total.toDouble() == 0 ? 1 : total.toDouble(),
          innerWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${total == 0 ? total : NumberFormat.percentPattern().format(initValue / total)}",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Theme.of(context).primaryColor)),
              Text(
                S.of(context).completed,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Theme.of(context).textTheme.caption.color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getChartWeek() {
    return StreamBuilder<List<ChartModel>>(
        stream: _bloc.chartWeekStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty)
            return FirstHabit(title: S.of(context).startNewHabit);
          final data = snapshot.data;
          return Container(
            padding: EdgeInsets.only(top: 50, left: 10, right: 20),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                        rod.y.toInt() == 0 ? '' : rod.y.toInt().toString(),
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                        showTitles: true,
                        textStyle: TextStyle(
                          color: const Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        margin: 20,
                        getTitles: (double value) {
                          if (value.toInt() != null) {
                            int index = (value - 1).toInt();
                            return weeksStartMon[index];
                          }
                          return "";
                        }),
                    leftTitles: SideTitles(
                        showTitles: false,
                        textStyle: TextStyle(
                            color: const Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 15,
                        reservedSize: 14,
                        getTitles: (value) {
                          if (value == 1 || value % 5 == 0 && value != 0)
                            return value.toInt().toString();
                          return '';
                        })),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: data
                    .map((e) => makeGroupData(context, e.title, e.value))
                    .toList(),
              ),
            ),
          );
        });
  }

  _getChartMonth() {
    return StreamBuilder<List<ChartModel>>(
        stream: _bloc.chartMonthStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty)
            return FirstHabit(title: S.of(context).startNewHabit);
          final data = snapshot.data;
          return Container(
            padding: EdgeInsets.only(top: 50, left: 0, right: 0),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                        rod.y.toInt() == 0 ? '' : rod.y.toInt().toString(),
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                        showTitles: true,
                        textStyle: TextStyle(
                          color: const Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        margin: 10,
                        getTitles: (double value) {
                          if (value.toInt() != null && value == 1 ||
                              value % 3 == 0 && value != 0) {
                            return value.toInt().toString();
                          }
                          return "";
                        }),
                    leftTitles: SideTitles(
                        showTitles: false,
                        textStyle: TextStyle(
                            color: const Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 32,
                        reservedSize: 14,
                        getTitles: (value) {
                          if (value == 1 || value % 5 == 0 && value != 0)
                            return value.toInt().toString();
                          return '';
                        })),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: data
                    .map((e) => makeGroupData(context, e.title, e.value,
                    width: 5, showingTooltip: true))
                    .toList(),
              ),
            ),
          );
        });
  }

  _getChartYear() {
    return StreamBuilder<List<ChartModel>>(
        stream: _bloc.chartYearStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty)
            return FirstHabit(title: S.of(context).startNewHabit);
          final data = snapshot.data;
          return Container(
            padding: EdgeInsets.only(top: 50, left: 10, right: 20),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                        rod.y.toInt() == 0 ? '' : rod.y.toInt().toString(),
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                        showTitles: true,
                        textStyle: TextStyle(
                          color: const Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        margin: 20,
                        getTitles: (double value) {
                          if (value.toInt() != null) {
                            return value.toInt().toString();
                          }
                          return "";
                        }),
                    leftTitles: SideTitles(
                        showTitles: false,
                        textStyle: TextStyle(
                            color: const Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 15,
                        reservedSize: 14,
                        getTitles: (value) {
                          if (value == 1 || value % 5 == 0 && value != 0)
                            return value.toInt().toString();
                          return '';
                        })),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: data
                    .map((e) => makeGroupData(context, e.title, e.value))
                    .toList(),
              ),
            ),
          );
        });
  }

  BarChartGroupData makeGroupData(BuildContext context, int x, double y1,
      {double width = 7, bool showingTooltip = false}) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: Theme.of(context).primaryColor,
        width: width,
      ),
    ], showingTooltipIndicators: [
      0
    ]);
  }
}
