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
        await db.execute(MobilityString.createTable);
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

  Future<void> insertMobility(Mobility mobility) async {
    try {
      await database.insert(MobilityString.tableName, mobility.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Mobility>> getMobilities(int goalId) async {
    try {
      var result = await database.query(MobilityString.tableName,
          columns: [
            MobilityString.id,
            MobilityString.title,
            MobilityString.amount,
            MobilityString.goalId,
            MobilityString.transactionDate
          ],
          where: '${MobilityString.goalId} = ?',
          whereArgs: <int>[goalId]);

      return List.generate(result.length, (index) {
        return Mobility.fromJson(result[index]);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Mobility> getMobility(int id) async {
    try {
      var result = await database.query(MobilityString.tableName,
          columns: [
            MobilityString.id,
            MobilityString.title,
            MobilityString.amount,
            MobilityString.goalId,
            MobilityString.transactionDate
          ],
          where: '${MobilityString.id} = ?',
          whereArgs: <int>[id]);

      return Mobility.fromJson(result.first);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteMobility(int id) async {
    try {
      await database.delete(MobilityString.tableName, where: '${MobilityString.id} = ?', whereArgs: <int>[id]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateMobility(Mobility mobility) async {
    try {
      await database.update(MobilityString.tableName, mobility.toJson(),
          where: '${mobility.id} = ?', whereArgs: <int>[mobility.id]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
