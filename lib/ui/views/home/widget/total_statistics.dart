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
  }) : super(key: key);

  final AppTheme appTheme;
  final MediaQueryData mediaQuery;
  final Localizer localizer;
  final List<Goal> goals;
  final double dashboardHeight = 180;

  @override
  Widget build(BuildContext context) {
    var totalAmount = goals.sum((e) => e.targetAmount.orDefault());
    var deposited = goals.sum((e) => e.deposited.orDefault());
    var remaining = totalAmount - deposited;
    return SliverPersistentHeader(
        floating: true,
        delegate: FixedHeightSliverPersistentHeaderDelegate(
            rebuild: true,
            height: dashboardHeight,
            child: ContentContainer(
              margin: EdgeInsets.all(0),
              child: Column(
                children: [
                  CardTitle(
                    backgroundColor: appTheme.colors.canvasLight,
                    title: localizer.total,
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: Space.m, right: Space.l, left: Space.l),
                      child: AmountRateIndicator(
                          totalValue: totalAmount, value: deposited, width: mediaQuery.size.widthPercent(90))),
                  IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme,
                      mediaQuery: mediaQuery,
                      label: localizer.goalAmount,
                      value: totalAmount.toString()),
                  IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme,
                      mediaQuery: mediaQuery,
                      label: localizer.deposited,
                      value: deposited.toString()),
                  IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme,
                      mediaQuery: mediaQuery,
                      label: localizer.remaining,
                      value: remaining.toString()),
                ],
              ),
            )));
  }
}
