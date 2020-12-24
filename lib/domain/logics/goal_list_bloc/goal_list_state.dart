import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';

abstract class GoalListState {}

class GoalListloading extends GoalListState {}

class GoalListSuccesed extends GoalListState {
  GoalListSuccesed({@required this.goals});
  final List<Goal> goals;

  List<Goal> get endlessGoals {
    return goals.where((e) => !e.isComplate).toList();
  }

  List<Goal> get completedGoals {
    return goals.where((e) => e.isComplate).toList();
  }
}

class GoalListFail extends GoalListState {
  GoalListFail({@required this.message});
  final String message;
}
