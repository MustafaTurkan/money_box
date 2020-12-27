import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class GoalRepository implements IGoalRepository{
  
  GoalRepository(this.moneyBoxDb);
  final MoneyBoxDb moneyBoxDb;

  @override
  Future<List<Goal>> getGoals() async{
      var goals=await moneyBoxDb.getGoals();
     return goals.where((e) => !e.isComplate).toList();
  }

    @override
  Future<List<Goal>> getCopletedGoals() async{
      var goals=await moneyBoxDb.getGoals();
     return goals.where((e) => e.isComplate).toList();
  }


  @override
  Future<void> add(Goal goal) async{
     await moneyBoxDb.insertGoal(goal);
  }

  @override
  Future<void> edit(Goal goal)async {
    await moneyBoxDb.updateGoal(goal);
  }

  @override
  Future<Goal> getGoal(int id) async{
    return moneyBoxDb.getGoal(id);
  }

  @override
  Future<void> delete(int id) async{
    await moneyBoxDb.deleteGoal(id);
  }

}
