import 'package:bloc/bloc.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class ContributionCubit extends Cubit<ContributionState> {
  ContributionCubit() : super(ContributionAddedInitial());

  IGoalRepository goalRepository;
  IMobilityRepository mobilityRepository;

  Future<void> decrement(Goal goal, Mobility mobility) async {
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

  Future<void> incrament(Goal goal, Mobility mobility) async {
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
