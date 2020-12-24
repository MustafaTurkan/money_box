import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class ContributionCubit extends Cubit<ContributionState> {
  ContributionCubit({@required this.goalRepository, @required this.contributionRepository})
      : super(ContributionAddedInitial());

  IGoalRepository goalRepository;
  IContributionRepository contributionRepository;

  Future<void> add(Goal goal, Contribution contribution) async {
    if (contribution.type == ContributionType.increment.index) {
      await _incrament(goal, contribution);
      return;
    }
    await _decrement(goal, contribution);
  }

  Future<void> _decrement(Goal goal, Contribution contribution) async {
    try {
      emit(ContributionAdding());
      goal.deposited = goal.deposited - contribution.amount;
      await goalRepository.edit(goal);
      await contributionRepository.add(contribution);
      emit(ContributionAddedSucces());
    } catch (e) {
      emit(ContributionAddedFail(message: e.toString()));
    }
  }

  Future<void> _incrament(Goal goal, Contribution contribution) async {
    try {
      emit(ContributionAdding());
      goal.deposited = goal.deposited + contribution.amount;
      await goalRepository.edit(goal);
      await contributionRepository.add(contribution);
      emit(ContributionAddedSucces());
    } catch (e) {
      emit(ContributionAddedFail(message: e.toString()));
    }
  }
}
