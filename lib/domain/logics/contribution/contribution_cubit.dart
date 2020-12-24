import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class ContributionCubit extends Cubit<ContributionState> {
  ContributionCubit({@required this.goalRepository, @required this.mobilityRepository})
      : super(ContributionAddedInitial());

  IGoalRepository goalRepository;
  IMobilityRepository mobilityRepository;

  Future<void> add(Goal goal, Mobility mobility) async {
    if (mobility.type == MobilityType.increment.index) {
      await _incrament(goal, mobility);
      return;
    }
    await _decrement(goal, mobility);
  }

  Future<void> _decrement(Goal goal, Mobility mobility) async {
    try {
      emit(ContributionAdding());
      goal.deposited = goal.deposited - mobility.amount;
      await goalRepository.edit(goal);
      await mobilityRepository.add(mobility);
      emit(ContributionAddedSucces());
    } catch (e) {
      emit(ContributionAddedFail(message: e.toString()));
    }
  }

  Future<void> _incrament(Goal goal, Mobility mobility) async {
    try {
      emit(ContributionAdding());
      goal.deposited = goal.deposited + mobility.amount;
      await goalRepository.edit(goal);
      await mobilityRepository.add(mobility);
      emit(ContributionAddedSucces());
    } catch (e) {
      emit(ContributionAddedFail(message: e.toString()));
    }
  }
}
