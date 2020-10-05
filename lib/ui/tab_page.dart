import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/ads/interstitial.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/ui/home/home_page.dart';
import 'package:habits_tracker/ui/premium/premium_page.dart';
import 'package:habits_tracker/ui/progress/progress_page.dart';
import 'package:habits_tracker/ui/settings/settings_page.dart';
import 'package:habits_tracker/bloc/tab_bloc.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();

  TabPage();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int selectIndex = 0;
  final _bloc = Injection.injector.get<TabBloc>();
  final _interstitial = Injection.injector.get<Interstitial>();

  @override
  void initState() {
    super.initState();
    if (_bloc.isFirstOpen) {
      _bloc.setIsFirstOpen(!_bloc.isFirstOpen);
    }
    _interstitial.loadInterstitialAd();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _interstitial.dispose();
    super.dispose();
  }

  Widget _buildTabPage() {
    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomePage(),
        ProgressPage(),
        PremiumPage(),
        SettingsPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTabPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        type: BottomNavigationBarType.shifting,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              S.of(context).journey,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.equalizer,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              S.of(context).statistics,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: ImageAssets.svgAssets(
              ImageAssets.ic_bag,
              height: 24,
              width: 24,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              S.of(context).premium,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              S.of(context).settings,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _interstitial.showInterstitialAd().then((value) {
        setState(() {
          _tabController.index = index;
        });
      });
    } else {
      setState(() {
        _tabController.index = index;
      });
    }
  }
}
