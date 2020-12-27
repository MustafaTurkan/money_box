import 'package:money_box/data/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//logger and errorHandler will be added
class MoneyBoxDb {
  Database database;

  Future<void> initialize() async {
    database = await openDatabase(
      join(await getDatabasesPath(), DbString.name),
      onCreate: (Database db, int version) async {
        await db.execute(GoalString.createTable);
        await db.execute(ContributionString.createTable);
      },
      version: 1,
    );
  }

  Future<void> insertGoal(Goal goal) async {
    try {
      await database.insert(GoalString.tableName, goal.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Goal>> getGoals() async {
    try {
      var result = await database.query(GoalString.tableName);
      return List.generate(result.length, (index) {
        return Goal.fromJson(result[index]);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Goal> getGoal(int id) async {
    try {
      var result = await database.query(GoalString.tableName,
          columns: [
            GoalString.id,
            GoalString.title,
            GoalString.currency,
            GoalString.deposited,
            GoalString.frequency,
            GoalString.img,
            GoalString.targetAmount,
            GoalString.targetDate
          ],
          where: '${GoalString.id} = ?',
          whereArgs: <int>[id]);

      return Goal.fromJson(result.first);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteGoal(int id) async {
    try {
      await database.delete(GoalString.tableName, where: '${GoalString.id} = ?', whereArgs: <int>[id]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await database
          .update(GoalString.tableName, goal.toJson(), where: '${GoalString.id} = ?', whereArgs: <int>[goal.id]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> insertContribution(Contribution contribution) async {
    try {
      var a= contribution.toJson();
      await database.insert(ContributionString.tableName,a, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Contribution>> getContributions(int goalId) async {
    try {
      var result = await database.query(ContributionString.tableName,
          columns: [
            ContributionString.id,
            ContributionString.title,
            ContributionString.amount,
            ContributionString.goalId,
            ContributionString.transactionDate,
             ContributionString.type
          ],
          where: '${ContributionString.goalId} = ?',
          whereArgs: <int>[goalId]);

      return List.generate(result.length, (index) {
        return Contribution.fromJson(result[index]);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Contribution> getContribution(int id) async {
    try {
      var result = await database.query(ContributionString.tableName,
          columns: [
            ContributionString.id,
            ContributionString.title,
            ContributionString.amount,
            ContributionString.goalId,
            ContributionString.transactionDate
          ],
          where: '${ContributionString.id} = ?',
          whereArgs: <int>[id]);

      return Contribution.fromJson(result.first);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteContribution(int id) async {
    try {
      await database.delete(ContributionString.tableName, where: '${ContributionString.id} = ?', whereArgs: <int>[id]);
    } catch (e) {
      throw Exception(e);
    }
  }

    Future<void> deleteContributionByGoal(int goalId) async {
    try {
      await database.delete(ContributionString.tableName, where: '${GoalString.id} = ?', whereArgs: <int>[goalId]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateContribution(Contribution mobility) async {
    try {
      await database.update(ContributionString.tableName, mobility.toJson(),
          where: '${mobility.id} = ?', whereArgs: <int>[mobility.id]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
