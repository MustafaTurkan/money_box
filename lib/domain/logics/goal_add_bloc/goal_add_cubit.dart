import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class GoalAddCubit extends Cubit<GoalAddState> {
  GoalAddCubit({@required this.goalRepository}) : super(GoalAddedInitial());

  final IGoalRepository goalRepository;
  
  Future<void> add(Goal goal) async {
    try {
      emit(GoalAddedLoading());
      await goalRepository.add(goal);
      emit(GoalAddedSucces());
    } catch (e) {
      emit(GoalAddedFail(message: e.toString()));
    }
  }
}
