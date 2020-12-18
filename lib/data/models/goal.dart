import 'dart:typed_data';

import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class Goal {
  Goal({
    this.id,
    this.title,
    this.img,
    this.targetDate,
    this.targetAmount,
    this.deposited,
    this.currency,
    this.frequency,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
      id: json.getValue<int>(GoalString.id),
      title: json.getValue<String>(GoalString.title),
      img: json.getValue<Uint8List>(GoalString.img),
      targetDate: json.getValue<DateTime>(GoalString.targetDate),
      targetAmount: json.getValue<double>(GoalString.targetAmount),
      deposited: json.getValue<double>(GoalString.deposited),
      currency: json.getValue<String>(GoalString.currency),
      frequency: json.getValue<int>(GoalString.frequency));

  final int id;
  final String title;
  final Uint8List img;
  final DateTime targetDate;
  final double targetAmount;
  final double deposited;
  final String currency;
  final int frequency;

  Map<String, dynamic> toJson() => <String, dynamic>{
        GoalString.title: title,
        GoalString.img: img,
        GoalString.targetDate: targetDate.toString(),
        GoalString.targetAmount: targetAmount,
        GoalString.deposited: deposited,
        GoalString.currency: currency,
        GoalString.frequency: frequency,
      };
}

enum SavingPeriod { periodless, daily, weekly, monthly }
