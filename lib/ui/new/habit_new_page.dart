import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_tracker/ads/banner_admob.dart';
import 'package:habits_tracker/bloc/habit_new_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/local_notification.dart';
import 'package:habits_tracker/repository/local/model/habit_model.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/ui/new/icon_choose_page.dart';
import 'package:habits_tracker/ui/widgets/appbar_bottom_sheet.dart';
import 'package:habits_tracker/utils/app_utils.dart';
import 'package:intl/intl.dart';

class HabitNewPage extends StatefulWidget {
  final HabitModel habitModel;

  HabitNewPage({this.habitModel});

  @override
  _HabitNewPageState createState() => _HabitNewPageState();
}

class _HabitNewPageState extends State<HabitNewPage> {
  final _bloc = Injection.injector.get<HabitNewBloc>();
  final _notification = Injection.injector.get<LocalNotification>();
  final _titleController = TextEditingController();
  final _desController = TextEditingController();
  List<int> _listSelected = [1, 1, 1, 1, 1, 1, 1];
  TimeOfDay _reminder = TimeOfDay.now();
  TimeOfDay _time = TimeOfDay.now();
  HabitModel _habit;
  DateTime _startDate =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 30);
  int _selectReminder = 0;
  int _colorPicked = 0;
  String _iconPicked = "ic_eco.svg";
  //BannerAd _bannerAd;
  @override
  void initState() {
    super.initState();
    _bloc.setCurrentScreen(widget.runtimeType.toString());
    //_bannerAd = createBannerAd()..load();
    if (widget.habitModel != null) {
      _time = stringToHour(widget.habitModel.time);
      _reminder = stringToHour(widget.habitModel.reminder);
      _listSelected = widget.habitModel.schedule;
      _startDate = widget.habitModel.startDay;
      _endDate = widget.habitModel.endDay;
    }

    _habit = widget.habitModel ?? HabitModel();

    _titleController.text = widget.habitModel?.title ?? "";

    _desController.text = widget.habitModel?.description ?? "";
  }

  @override
  void dispose() {
    _bloc.dispose();
    _titleController.dispose();
    _desController.dispose();
    //_bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_bannerAd..show(anchorOffset: 10, horizontalCenterOffset: 0);
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
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3)),
              height: 5,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
          AppbarBottomSheet(
            title: widget.habitModel == null
                ? S.of(context).createAHabit
                : S.of(context).edit,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            leftWidget: ImageAssets.svgAssets(ImageAssets.ic_back,
                height: 32,
                width: 32,
                color: Theme.of(context).textTheme.subtitle1.color),
            onTapLeft: () => Navigator.pop(context),
            rightWidget: Container(
              child: InkWell(
                  onTap: () {
                    _onSave();
                  },
                  child: Text(
                    S.of(context).save,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.blue),
                  )),
            ),
          ),
          Expanded(child: _body()),
          SizedBox(height: 60,)
        ],
      ),
    );
  }

  _body() {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 25,
              ),
              _title(),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _getDate(S.of(context).startTime, _startDate,
                        EdgeInsets.only(left: 16)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: _getDate(S.of(context).endTime, _endDate,
                        EdgeInsets.only(right: 16)),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _getTime(),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: _getReminder(),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              _schedule(),
              SizedBox(
                height: 25,
              ),
              _color(),
              //_type(),
              /*SizedBox(
            height: 20,
          ),
          _description(),*/
            ]))
      ],
    );
  }

  _title() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: _selectIcon,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.background),
                  child: ImageAssets.svgAssets(
                      ImageAssets.serverIconMap[_iconPicked],
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<bool>(
                        stream: _bloc.textErrorStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data)
                            return Container();
                          return Text(
                            S.of(context).titleNotEmpty,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Theme.of(context).errorColor),
                          );
                        }),
                    TextField(
                      controller: _titleController,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        if (text != null || text.isNotEmpty) {
                          _bloc.textErrorSink.add(true);
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.background,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: S.of(context).titleHabit,
                        hintStyle: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _description() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            child: TextFormField(
              controller: _desController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (text) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2)),
                hintText: S.of(context).description,
                contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _color() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Icon(Icons.color_lens),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              S.of(context).color,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          InkWell(
            onTap: _selectColor,
            child: Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                        color: intToColor(context, _colorPicked),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _schedule() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.date_range),
              SizedBox(
                width: 5,
              ),
              Text(
                S.of(context).schedule,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: weeksStartMon
                  .asMap()
                  .map((index, week) =>
                  MapEntry(index, _itemDayOfWeek(week, index)))
                  .values
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  _getTime() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).whatTime,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: _selectTime,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      _time.format(context),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getReminder() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).reminder,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: _showChooseReminderDialog,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.alarm),
                  SizedBox(width: 8,),
                  Text(
                    _selectReminder == 0 || _reminder == null
                        ? S.of(context).none
                        : _selectReminder == 1
                        ? S.of(context).before15
                        : _selectReminder == 2
                        ? S.of(context).before30
                        : _selectReminder == 3
                        ? S.of(context).before1h
                        : _reminder.format(context),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getDate(String title, DateTime dateTime, EdgeInsets padding) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: dateTime == _startDate ? _selectDateStart : _selectDateEnd,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timelapse),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      DateFormat.yMd().format(dateTime),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _type() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 150,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4,
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(4),
            child: Row(
              children: [Icon(Icons.android)],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }

  Widget _itemDayOfWeek(String title, int index) {
    return InkWell(
      onTap: () => _onSelected(index),
      child: Container(
        width: (MediaQuery.of(context).size.width - 53) / 7,
        margin: EdgeInsets.only(right: 3),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: _listSelected[index] == 1
                ? Theme.of(context).primaryColor
                : null,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: _listSelected[index] == 1
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                width: 1.5)),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: _listSelected[index] == 1 ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }

  void _onSelected(int index) {
    setState(() {
      if (_listSelected[index] == 0) {
        _listSelected[index] = 1;
      } else {
        _listSelected[index] = 0;
      }
    });
  }

  _showChooseReminderDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.of(context).reminder),
            children: optionReminder
                .asMap()
                .map((index, data) =>
                MapEntry(index, _reminderOption(data, index)))
                .values
                .toList(),
          );
        });
  }

  Widget _reminderOption(String data, int index) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, index);
        setState(() {
          _selectReminder = index;
          if (index == 4) {
            _selectTimeReminder();
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(data),
      ),
    );
  }

  void _selectTimeReminder() async {
    final TimeOfDay timePicker = await showTimePicker(
      context: context,
      initialTime: _reminder,
    );
    if (timePicker != null) {
      setState(() {
        _reminder = timePicker;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay timePicker = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (timePicker != null) {
      setState(() {
        _time = timePicker;
      });
    }
  }

  void _selectDateStart() async {
    final DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
        ),
        lastDate: DateTime(
          DateTime.now().year + 1,
          DateTime.now().month,
        ));
    if (datePicker != null) {
      setState(() {
        _startDate = datePicker;
      });
    }
  }

  void _selectDateEnd() async {
    final DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
        ),
        lastDate: DateTime(
          DateTime.now().year + 1,
          DateTime.now().month,
        ));
    if (datePicker != null) {
      setState(() {
        _endDate = datePicker;
      });
    }
  }

  TimeOfDay _getReminderTimer() {
    if (_selectReminder == 1) {
      return TimeOfDay(hour: _time.hour, minute: _time.minute - 15);
    } else if (_selectReminder == 2) {
      return TimeOfDay(hour: _time.hour, minute: _time.minute - 30);
    } else if (_selectReminder == 3) {
      return TimeOfDay(hour: _time.hour - 1, minute: _time.minute);
    } else if (_selectReminder == 4) {
      return _reminder;
    } else {
      return null;
    }
  }

  void _selectColor() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              children: [
                Expanded(child: Text(S.of(context).color)),
              ],
            ),
            children: listColorsPicker(context)
                .asMap()
                .map((index, data) =>
                MapEntry(index, _colorsOption(data, index)))
                .values
                .toList(),
          );
        }, routeSettings: RouteSettings(name: "color_choose_page"));
  }

  Widget _colorsOption(Color data, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _colorPicked = index;
        });
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: 200,
            height: 40,
            decoration: BoxDecoration(
                color: index != 0 ? data : null,
                borderRadius: BorderRadius.circular(8)),
            child: index == 0
                ? Center(
              child: Text(
                S.of(context).none,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontSize: 17),
              ),
            )
                : Container(),
          ),
          Container(
            height: 0.5,
            color: Theme.of(context).dividerColor,
          )
        ],
      ),
    );
  }

  void _selectIcon() async {
    String result = await showDialog(
        context: context, builder: (context) => IconChoosePage(), routeSettings: RouteSettings(name: "icon_choose_page"));
    if (result != null) {
      setState(() {
        _iconPicked = result;
      });
    }
  }

  void _onSave() async {
    _habit.title = _titleController.text ?? "";
    _habit.description = _desController.text ?? "";
    _habit.time = _time.format(context);
    _habit.startDay = _startDate;
    _habit.endDay = _endDate;
    _habit.reminder =
    _getReminderTimer() != null ? _getReminderTimer().format(context) : "";
    _habit.schedule = _listSelected;
    _habit.color = _colorPicked;
    _habit.icon = _iconPicked;
    int result = -1;
    if (widget.habitModel != null) {
      result = await _bloc.updateHabit(_habit);
    } else {
      result = await _bloc.saveHabit(_habit);
    }
    if (result != -1) {
      showNotification(result, _habit);
      Navigator.of(context).pop(_habit);
    }
  }

  void showNotification(int id, HabitModel habitModel) {
    if (_getReminderTimer() != null && _bloc.isShowNotification) {
      _notification.showDailyNotification(id, habitModel.title, S.of(context).contentNotificationReminder,
          _getReminderTimer());
    }
  }
}
