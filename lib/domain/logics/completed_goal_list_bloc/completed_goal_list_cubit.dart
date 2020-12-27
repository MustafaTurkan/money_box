import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class CompletedGoalListCubit extends Cubit<CompletedGoalListState> {
  CompletedGoalListCubit({
    @required this.goals,
    @required this.goalRepository,
    @required this.contributionRepository,
  }) : super(CompletedGoalListSuccesed(goals: goals));
   List<Goal> goals;
  final IGoalRepository goalRepository;
  final IContributionRepository contributionRepository;

  Future<void> delete(int goalId) async {
    try {
      emit(CompletedGoalListloading());
      await goalRepository.delete(goalId);
      await contributionRepository.deleteContributionsByGoal(goalId);
     
       goals =await goalRepository.getCopletedGoals();
      emit(CompletedGoalListSuccesed(goals: goals));
    } catch (e) {
      emit(CompletedGoalListFail(message: e.toString()));
    }
  }
}
