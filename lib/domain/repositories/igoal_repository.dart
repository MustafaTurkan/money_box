import 'package:money_box/data/data.dart';
abstract class IGoalRepository
{
      Future<List<Goal>> getGoals();
      Future<List<Goal>> getCopletedGoals();
      Future<void> add(Goal goal);
      Future<Goal> getGoal(int id);
      Future<void> edit(Goal goal);
      Future<void> delete(int id);
}