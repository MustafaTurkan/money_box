



import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';

abstract class CompletedGoalListState {}

class CompletedGoalListloading extends CompletedGoalListState {}

class CompletedGoalListSuccesed extends CompletedGoalListState {
 CompletedGoalListSuccesed({@required this.goals});
  final List<Goal> goals;
}

class CompletedGoalListFail extends CompletedGoalListState {
  CompletedGoalListFail({@required this.message});
  final String message;
}
