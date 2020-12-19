import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class Mobility {
  Mobility({this.id, this.title, this.amount, this.goalId, this.transactionDate, this.type});

  factory Mobility.fromJson(Map<String, dynamic> json) => Mobility(
      id: json.getValue<int>(MobilityString.id),
      title: json.getValue<String>(MobilityString.title),
      goalId: json.getValue<int>(MobilityString.goalId),
      type: json.getValue<int>(MobilityString.type),
      transactionDate: json.getValue<DateTime>(MobilityString.transactionDate),
      amount: json.getValue<double>(MobilityString.amount));

  final int id;
  final String title;
  final int goalId;
  final DateTime transactionDate;
  final double amount;
  final int type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        MobilityString.title: title,
        MobilityString.goalId: goalId,
        MobilityString.transactionDate: transactionDate.toString(),
        MobilityString.amount: amount,
        MobilityString.type: type
      };
}


enum MobilityType
{
  increment,//+
  decrement,//-
}