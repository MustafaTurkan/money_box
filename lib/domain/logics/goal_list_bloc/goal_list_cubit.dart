import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/ui/ui.dart';

class GoalListCubit extends Cubit<GoalListState> {
  GoalListCubit({@required this.goalRepository, @required this.goals}) : super(GoalListSuccesed(goals: goals));

  final IGoalRepository goalRepository;
  List<Goal> goals;

  Future<void> load() async {
    try {
      emit(GoalListloading());
      goals = await goalRepository.getGoals();
      emit(GoalListSuccesed(goals: goals));
    } catch (e) {
      emit(GoalListFail(message: e.toString()));
    }
  }

  void sort(SortType sortType) {
    try {
      _sortGoals(sortType);
      emit(GoalListSuccesed(goals: goals));
    } catch (e) {
      emit(GoalListFail(message: e.toString()));
    }
  }

  void _sortGoals(SortType sortType) {
    if (sortType == null) {
      return;
    }
    if (sortType == SortType.alphabetical) {
      goals.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }

    if (sortType == SortType.minGoalAmount) {
      goals.sort((a, b) => a.targetAmount.compareTo(b.targetAmount));
    }

    if (sortType == SortType.maxGoalAmount) {
      goals.sort((b, a) => a.targetAmount.compareTo(b.targetAmount));
    }
  }
}
