import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class GoalRepository implements IGoalRepository{
  
  GoalRepository(this.moneyBoxDb);
  final MoneyBoxDb moneyBoxDb;

}
