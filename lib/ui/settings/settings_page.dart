import 'package:flutter/material.dart';
import 'package:habits_tracker/bloc/settings_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/repository/local/model/choose_model.dart';
import 'package:habits_tracker/theme/theme.dart';
import 'package:habits_tracker/ui/settings/settings_choose.dart';
import 'package:habits_tracker/ui/widgets/row_text.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _bloc = Injection.injector.get<SettingsBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.setCurrentScreen(this.runtimeType.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _body(_themeNotifier),
    );
  }

  _body(ThemeNotifier themeNotifier) {
    return Container(
      child: Column(
        children: [
          _general(themeNotifier),
          _common(),
        ],
      ),
    );
  }

  _onChangeNotification(bool value) {
    _bloc.setIsNotification(value);
  }

  _general(ThemeNotifier themeNotifier) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              S.of(context).general.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Theme.of(context).textTheme.caption.color),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          RowText(
            icons: Icon(
              Icons.notifications_active,
              color: Theme.of(context).primaryColor,
            ),
            title: S.of(context).notifications,
            next: false,
            isDivider: true,
            iconRight: Switch(
                activeColor: Theme.of(context).accentColor,
                value: _bloc.isShowNotification, onChanged: (value) => _onChangeNotification),
          ),
          RowText(
            icons: Icon(Icons.wb_sunny, color: Theme.of(context).primaryColor),
            title: S.of(context).theme,
            next: true,
            onTap: () {
              _changeTheme(themeNotifier);
            },
          )
        ],
      ),
    );
  }

  _common() {
    return Container(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          RowText(
            icons: Icon(Icons.help, color: Theme.of(context).primaryColor),
            title: S.of(context).help,
            next: true,
            isDivider: true,
          ),
          RowText(
            icons: Icon(Icons.thumb_up, color: Theme.of(context).primaryColor),
            title: S.of(context).rateApp,
            next: true,
            isDivider: true,
          ),
          RowText(
            icons: Icon(Icons.feedback, color: Theme.of(context).primaryColor),
            title: S.of(context).feedback,
            next: true,
            isDivider: true,
          ),
          RowText(
            icons: Icon(Icons.share, color: Theme.of(context).primaryColor),
            title: S.of(context).shareApp,
            next: true,
            onTap: () {
              PackageInfo.fromPlatform().then((packageInfo) => Share.share(
                  "https://play.google.com/store/apps/details?id=${packageInfo.packageName}"));
            },
          ),
        ],
      ),
    );
  }

  _changeTheme(ThemeNotifier themeNotifier) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SettingsChoose(
          selectedItem: _bloc.themeValue,
          options: [
            ChooseModel(
                title: S.of(context).light, value: 0, icon: Icons.wb_sunny),
            ChooseModel(
                title: S.of(context).dark,
                value: 1,
                icon: Icons.brightness_2)
          ],
          label: S.of(context).theme,
          changeValue: (data) {
            themeNotifier.setTheme(data.value == 0);
            _bloc.changeTheme(data.value);
          },
        ), settings: RouteSettings(name: 'theme_page')));
  }
}
