import 'package:flutter/material.dart';

abstract class ContributionState {}

class ContributionAddedInitial extends ContributionState {}

class ContributionAdding extends ContributionState {}

class ContributionAddedSucces extends ContributionState {}

class ContributionAddedFail extends ContributionState {
  ContributionAddedFail({@required this.message});
  final String message;
}
