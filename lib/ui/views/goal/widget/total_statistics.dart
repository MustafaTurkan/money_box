import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class TotalStatistics extends StatelessWidget {
  TotalStatistics({
    Key key,
    @required this.appTheme,
    @required this.mediaQuery,
    @required this.localizer,
    @required this.goals,
    @required this.dashboardHeight,
  }) : super(key: key);

  final AppTheme appTheme;
  final MediaQueryData mediaQuery;
  final Localizer localizer;
  final List<Goal> goals;
  final double dashboardHeight;

  @override
  Widget build(BuildContext context) {
    var totalAmount = goals.sum((e) => e.targetAmount.orDefault());
    var deposited = goals.sum((e) => e.deposited.orDefault());
    var remaining = totalAmount - deposited;
    return Card(
        child: SizedBox(
      height: dashboardHeight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(Space.m),
            child: buildAmoutCircularPercentIndicator(totalAmount, deposited),
          ),
          VerticalDivider(
            indent: Space.s,
            endIndent: Space.s,
            thickness: 0.5,
          ),
          Expanded(
              child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetFactory.columnLabelValue(
                        appTheme: appTheme, label: localizer.goalAmount, value: Formatter.moneyToString(totalAmount)),
                    IndentDivider(),
                    WidgetFactory.columnLabelValue(
                        appTheme: appTheme, label: localizer.remaining, value: Formatter.moneyToString(remaining)),
                    IndentDivider(),
                    WidgetFactory.columnLabelValue(
                        appTheme: appTheme, label: localizer.deposited, value: Formatter.moneyToString(deposited)),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }

  Widget buildAmoutCircularPercentIndicator(double totalAmount, double deposite) {
    return AmountPercentCircularIndicator(
        radius: 120,
        totalValue: totalAmount,
        value: deposite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '%${calculateRate(deposite, totalAmount).toString()}',
              style: appTheme.textStyles.bodyBold,
              textAlign: TextAlign.center,
            ),
            Text(
              localizer.completed,
              style: appTheme.textStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  double calculateRate(double value, double totalValue) {
    if (totalValue == 0) {
      return 0;
    }
    return double.parse(((value * 100) / totalValue).toStringAsFixed(2));
  }
}
