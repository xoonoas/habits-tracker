import 'package:habits_tracker/bloc/base_bloc.dart';
import 'package:habits_tracker/repository/habit_repository.dart';
import 'package:habits_tracker/repository/session.dart';

class PremiumBloc extends BaseBloc {
  PremiumBloc(HabitRepository repository, Session session) : super(repository, session);

  @override
  void init() {
  }

  @override
  void reload() {
  }

  @override
  void dispose() {
    super.dispose();
  }

}