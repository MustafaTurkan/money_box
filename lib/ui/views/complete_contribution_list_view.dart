import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class CompleteContributionListView extends StatelessWidget {
  const CompleteContributionListView({Key key, @required this.contributions}) : super(key: key);

  final List<Contribution> contributions;
  @override
  Widget build(BuildContext context) {
    var localizer = context.getLocalizer();
    var appTheme = context.getTheme();
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text(localizer.contributions)),
        body: CustomScrollView(
          slivers: [buildTitle(totalAmount(), appTheme, localizer), buildBody(appTheme)],
        ));
  }

  Widget buildTitle(double amount, AppTheme appTheme, Localizer localizer) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: FixedHeightSliverPersistentHeaderDelegate(
          height: 35,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Space.xxs),
            child: ContentTitle(
              backgroundColor: appTheme.colors.canvasLight,
              icon: WidgetFactory.emptyWidget(),
              title: localizer.totalCompletedAmount,
              leadingText: amount.toCurrencyString(),
            ),
          ),
        ));
  }

  Widget buildBody(AppTheme appTheme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return buildContributionsTile(contributions[index], appTheme);
        },
        childCount: contributions.length,
      ),
    );
  }

  Widget buildContributionsTile(Contribution contribution, AppTheme appTheme) {
    return ContributionListTile(
      appTheme: appTheme,
      contribution: contribution,
    );
  }

  double totalAmount() {
    double amount = 0;
    for (var item in contributions) {
      if (item.type == ContributionType.decrement.index) {
        amount = amount - item.amount;
      } else {
        amount = amount + item.amount;
      }
    }
    return amount;
  }
}
