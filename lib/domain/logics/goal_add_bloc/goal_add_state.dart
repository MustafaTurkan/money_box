import 'package:flutter/material.dart';

abstract class GoalAddState {}

class GoalAddedInitial extends GoalAddState {}

class GoalAddedLoading extends GoalAddState {}

class GoalAddedSucces extends GoalAddState {}

class GoalAddedFail extends GoalAddState {
  GoalAddedFail({@required this.message});
  final String message;
}
