import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class Contribution {
  Contribution({this.id, this.title, this.amount, this.goalId, this.transactionDate, this.type});

  factory Contribution.fromJson(Map<String, dynamic> json) => Contribution(
      id: json.getValue<int>(ContributionString.id),
      title: json.getValue<String>(ContributionString.title),
      goalId: json.getValue<int>(ContributionString.goalId),
      type: json.getValue<int>(ContributionString.type),
      transactionDate: json.getValue<DateTime>(ContributionString.transactionDate),
      amount: json.getValue<double>(ContributionString.amount));

  final int id;
  final String title;
  final int goalId;
  final DateTime transactionDate;
  final double amount;
  final int type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        ContributionString.title: title,
        ContributionString.goalId: goalId,
        ContributionString.transactionDate: transactionDate.toString(),
        ContributionString.amount: amount,
        ContributionString.type: type
      };
}


enum ContributionType
{
  increment,//+
  decrement,//-
}