import 'package:money_box/data/data.dart';
abstract class IContributionRepository
{
     Future<void> add(Contribution contribution);
     Future<List<Contribution>> getContributions(int goalId);
     Future<void> deleteContributionsByGoal(int goalId);
}