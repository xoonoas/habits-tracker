import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/bloc/premium_bloc.dart';
import 'package:habits_tracker/di/inject.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PremiumPage extends StatefulWidget {
  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  PageController _pageController = PageController();
  final _bloc = Injection.injector.get<PremiumBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.setCurrentScreen(this.runtimeType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  S.of(context).upgradePremium,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _getBenefit(),
              SizedBox(
                height: 30,
              ),
              _getOptions(),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  padding:
                  EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).upgradePremium,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward, color: Colors.white)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getBenefit() {
    return Column(
      children: [
        Container(
          height: 200,
          child: PageView(
            controller: _pageController,
            children: [
              _getItemBenefit(S.of(context).unlimitedHabit,
                  S.of(context).unlitmitedContentHabit),
              _getItemBenefit(S.of(context).noAds, S.of(context).noAdsContent),
              _getItemBenefit(
                  S.of(context).moreColors, S.of(context).moreColorsContent),
              _getItemBenefit(
                  S.of(context).moreIcons, S.of(context).moreIconsContent),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 4,
          effect: WormEffect(dotWidth: 10, dotHeight: 10),
        )
      ],
    );
  }

  _getItemBenefit(String title, String content) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            Icons.all_inclusive,
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 20,
        ),
        Text(content,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Theme.of(context).textTheme.caption.color))
      ],
    );
  }

  _getOptions() {
    return Container(
      child: Row(
        children: [
          Expanded(child: _getMoneyOption(1.5, S.of(context).monthly)),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: _getMoneyOption(12, S.of(context).yearly,
                  subtitle: S.of(context).save33)),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: _getMoneyOption(20, S.of(context).lifeTime,
                  subtitle: S.of(context).bestValue)),
        ],
      ),
    );
  }

  _getMoneyOption(double money, String title, {String subtitle}) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Color(0xFFeeeeee), borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          if (subtitle != null && subtitle.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Center(
                  child: Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${NumberFormat.simpleCurrency().format(money)}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
