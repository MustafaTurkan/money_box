import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class GoalListCubit extends Cubit<GoalListState> {
  GoalListCubit({@required this.goalRepository, @required this.goals}) : super(GoalListSuccesed(goals: goals));

  final IGoalRepository goalRepository;
  List<Goal> goals;

  Future<void> loadGloals() async {
    try {
      emit(GoalListloading());
      goals = await goalRepository.getGoals();
      emit(GoalListSuccesed(goals: goals));
    } catch (e) {
      emit(GoalListFail(message: e.toString()));
    }
  }
}
