// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Create Habit`
  String get createHabit {
    return Intl.message(
      'Create Habit',
      name: 'createHabit',
      desc: '',
      args: [],
    );
  }

  /// `Title habit`
  String get titleHabit {
    return Intl.message(
      'Title habit',
      name: 'titleHabit',
      desc: '',
      args: [],
    );
  }

  /// `Current streak`
  String get currentStreak {
    return Intl.message(
      'Current streak',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Goal`
  String get weeklyGoal {
    return Intl.message(
      'Weekly Goal',
      name: 'weeklyGoal',
      desc: '',
      args: [],
    );
  }

  /// `Create a habit`
  String get createAHabit {
    return Intl.message(
      'Create a habit',
      name: 'createAHabit',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Sửa`
  String get edit {
    return Intl.message(
      'Sửa',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `What time?`
  String get whatTime {
    return Intl.message(
      'What time?',
      name: 'whatTime',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tue {
    return Intl.message(
      'Tue',
      name: 'tue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wed {
    return Intl.message(
      'Wed',
      name: 'wed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thu {
    return Intl.message(
      'Thu',
      name: 'thu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get sat {
    return Intl.message(
      'Sat',
      name: 'sat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sun {
    return Intl.message(
      'Sun',
      name: 'sun',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Hằng tuần`
  String get weekly {
    return Intl.message(
      'Hằng tuần',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning`
  String get goodMorning {
    return Intl.message(
      'Good Morning',
      name: 'goodMorning',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon`
  String get goodAfternoon {
    return Intl.message(
      'Good Afternoon',
      name: 'goodAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good Night`
  String get goodNight {
    return Intl.message(
      'Good Night',
      name: 'goodNight',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Total habit`
  String get totalHabit {
    return Intl.message(
      'Total habit',
      name: 'totalHabit',
      desc: '',
      args: [],
    );
  }

  /// `Completions`
  String get completions {
    return Intl.message(
      'Completions',
      name: 'completions',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incomplete {
    return Intl.message(
      'Incomplete',
      name: 'incomplete',
      desc: '',
      args: [],
    );
  }

  /// `Overall`
  String get overall {
    return Intl.message(
      'Overall',
      name: 'overall',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Top habits`
  String get topHabit {
    return Intl.message(
      'Top habits',
      name: 'topHabit',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Rate us`
  String get rateApp {
    return Intl.message(
      'Rate us',
      name: 'rateApp',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Share app with friends`
  String get shareApp {
    return Intl.message(
      'Share app with friends',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to premium`
  String get upgradePremium {
    return Intl.message(
      'Upgrade to premium',
      name: 'upgradePremium',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited habits`
  String get unlimitedHabit {
    return Intl.message(
      'Unlimited habits',
      name: 'unlimitedHabit',
      desc: '',
      args: [],
    );
  }

  /// `No Ads`
  String get noAds {
    return Intl.message(
      'No Ads',
      name: 'noAds',
      desc: '',
      args: [],
    );
  }

  /// `Self-improvement makes your life better by changing your habits more.`
  String get unlitmitedContentHabit {
    return Intl.message(
      'Self-improvement makes your life better by changing your habits more.',
      name: 'unlitmitedContentHabit',
      desc: '',
      args: [],
    );
  }

  /// `Get rid of all phone ads when you open the app.`
  String get noAdsContent {
    return Intl.message(
      'Get rid of all phone ads when you open the app.',
      name: 'noAdsContent',
      desc: '',
      args: [],
    );
  }

  /// `More colors`
  String get moreColors {
    return Intl.message(
      'More colors',
      name: 'moreColors',
      desc: '',
      args: [],
    );
  }

  /// `Use more colors for your habit.`
  String get moreColorsContent {
    return Intl.message(
      'Use more colors for your habit.',
      name: 'moreColorsContent',
      desc: '',
      args: [],
    );
  }

  /// `More icons`
  String get moreIcons {
    return Intl.message(
      'More icons',
      name: 'moreIcons',
      desc: '',
      args: [],
    );
  }

  /// `Use more Icons for your habit.`
  String get moreIconsContent {
    return Intl.message(
      'Use more Icons for your habit.',
      name: 'moreIconsContent',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Life-time`
  String get lifeTime {
    return Intl.message(
      'Life-time',
      name: 'lifeTime',
      desc: '',
      args: [],
    );
  }

  /// `Save 33%`
  String get save33 {
    return Intl.message(
      'Save 33%',
      name: 'save33',
      desc: '',
      args: [],
    );
  }

  /// `Best value`
  String get bestValue {
    return Intl.message(
      'Best value',
      name: 'bestValue',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Error!!`
  String get error {
    return Intl.message(
      'Error!!',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `View more`
  String get viewMore {
    return Intl.message(
      'View more',
      name: 'viewMore',
      desc: '',
      args: [],
    );
  }

  /// `Create your first habit`
  String get startNewHabit {
    return Intl.message(
      'Create your first habit',
      name: 'startNewHabit',
      desc: '',
      args: [],
    );
  }

  /// `Refresh yourself by starting with your new habits`
  String get startHomeNewHabit {
    return Intl.message(
      'Refresh yourself by starting with your new habits',
      name: 'startHomeNewHabit',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message(
      'Start Time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get endTime {
    return Intl.message(
      'End Time',
      name: 'endTime',
      desc: '',
      args: [],
    );
  }

  /// `Select time`
  String get selectTime {
    return Intl.message(
      'Select time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message(
      'None',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Before 15 minutes`
  String get before15 {
    return Intl.message(
      'Before 15 minutes',
      name: 'before15',
      desc: '',
      args: [],
    );
  }

  /// `Before 30 minutes`
  String get before30 {
    return Intl.message(
      'Before 30 minutes',
      name: 'before30',
      desc: '',
      args: [],
    );
  }

  /// `Before 1h minutes`
  String get before1h {
    return Intl.message(
      'Before 1h minutes',
      name: 'before1h',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get customTime {
    return Intl.message(
      'Custom',
      name: 'customTime',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Default color`
  String get defaultColor {
    return Intl.message(
      'Default color',
      name: 'defaultColor',
      desc: '',
      args: [],
    );
  }

  /// `Choose icon`
  String get pickIcon {
    return Intl.message(
      'Choose icon',
      name: 'pickIcon',
      desc: '',
      args: [],
    );
  }

  /// `Choose color`
  String get pickColor {
    return Intl.message(
      'Choose color',
      name: 'pickColor',
      desc: '',
      args: [],
    );
  }

  /// `Technology`
  String get technology {
    return Intl.message(
      'Technology',
      name: 'technology',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get popular {
    return Intl.message(
      'Popular',
      name: 'popular',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message(
      'Sports',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Title cannot be empty.`
  String get titleNotEmpty {
    return Intl.message(
      'Title cannot be empty.',
      name: 'titleNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Undo skip`
  String get unskip {
    return Intl.message(
      'Undo skip',
      name: 'unskip',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message(
      'Premium',
      name: 'premium',
      desc: '',
      args: [],
    );
  }

  /// `Journey`
  String get journey {
    return Intl.message(
      'Journey',
      name: 'journey',
      desc: '',
      args: [],
    );
  }

  /// `You have not completed this routine today`
  String get contentNotificationReminder {
    return Intl.message(
      'You have not completed this routine today',
      name: 'contentNotificationReminder',
      desc: '',
      args: [],
    );
  }

  /// `identify`
  String get identify {
    return Intl.message(
      'identify',
      name: 'identify',
      desc: '',
      args: [],
    );
  }

  /// `routine`
  String get routine {
    return Intl.message(
      'routine',
      name: 'routine',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `progress`
  String get progress {
    return Intl.message(
      'progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Identify which habits you want to do. It influence you for the better, not for the worse.`
  String get identifyDes {
    return Intl.message(
      'Identify which habits you want to do. It influence you for the better, not for the worse.',
      name: 'identifyDes',
      desc: '',
      args: [],
    );
  }

  /// `You need to work hard on the routine every day or every week and commit for at least 30 days.`
  String get routineDes {
    return Intl.message(
      'You need to work hard on the routine every day or every week and commit for at least 30 days.',
      name: 'routineDes',
      desc: '',
      args: [],
    );
  }

  /// `Remind yourself to follow up with daily routines to avoid forgetting them.`
  String get reminderDes {
    return Intl.message(
      'Remind yourself to follow up with daily routines to avoid forgetting them.',
      name: 'reminderDes',
      desc: '',
      args: [],
    );
  }

  /// `Keep track of your history, the progress of your habits.`
  String get progressDes {
    return Intl.message(
      'Keep track of your history, the progress of your habits.',
      name: 'progressDes',
      desc: '',
      args: [],
    );
  }

  /// `Trying something for 30 days can help on your way to creating a healthier lifestyle.`
  String get successDes {
    return Intl.message(
      'Trying something for 30 days can help on your way to creating a healthier lifestyle.',
      name: 'successDes',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Get started now`
  String get startedNow {
    return Intl.message(
      'Get started now',
      name: 'startedNow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}