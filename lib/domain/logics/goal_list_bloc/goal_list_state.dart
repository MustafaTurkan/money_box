


import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';

abstract class GoalListState {}

class GoalListloading extends GoalListState{}

class GoalListSuccesed extends GoalListState{
  GoalListSuccesed({@required this.goals});
   final List<Goal> goals;
}


class GoalListFail extends GoalListState {
  GoalListFail({@required this.message});
  final String message;
}

