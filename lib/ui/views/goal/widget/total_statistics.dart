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
                child: buildAmoutCircularPercentIndicator(totalAmount,deposited),
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
                      children: [
                        _buildLabel(localizer.goalAmount, Formatter.moneyToString(totalAmount)),
                        _buildLabel(localizer.remaining, Formatter.moneyToString(remaining)),
                        _buildLabel(localizer.deposited, Formatter.moneyToString(deposited)),
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

  Widget _buildLabel(String label, String value) {
    var boderSide = BorderSide(
      color: appTheme.colors.divider,
      width: 0,
    );
    return Padding(
      padding: EdgeInsets.all(Space.m),
      child: ExpandedRow(
        flexs: {0: 1, 1: 2},
        children: [
          Text(
            label,
            style: appTheme.textStyles.body.copyWith(color: appTheme.colors.fontPale),
          ),
          InputDecorator(
              decoration: DenseInputDecoration(
                border: UnderlineInputBorder(
                  borderSide: boderSide,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: boderSide,
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: boderSide,
                ),
                fillColor: appTheme.colors.canvasLight,
              ),
              child: Text(value))
        ],
      ),
    );
  }

  double calculateRate(double value, double totalValue) {
    if (totalValue == 0) {
      return 0;
    }
    return (value * 100) / totalValue;
  }
}
