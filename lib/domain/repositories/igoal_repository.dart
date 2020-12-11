import 'package:money_box/data/data.dart';
abstract class IGoalRepository
{
      Future<List<Goal>> getGoals();
      Future<void> add(Goal goal);
}