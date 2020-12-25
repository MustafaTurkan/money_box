import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/theme/app_theme.dart';
import 'package:money_box/ui/ui.dart';

class CompleteContributionListView extends StatelessWidget {
  const CompleteContributionListView({Key key, @required this.contributions}) : super(key: key);

  final List<Contribution> contributions;
  @override
  Widget build(BuildContext context) {
    var localizer = context.getLocalizer();
    var appTheme = context.getTheme();
    return Scaffold(
        appBar: AppBar( 
          centerTitle: true,
          title: Text(localizer.contributions)),
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
            padding: const EdgeInsets.only(bottom:Space.xs),
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
    var child = contribution.title.isNullOrEmpty()
        ? buildTileChild(contribution, appTheme)
        : buildTileChildWithTitle(contribution, appTheme);
    return Card( child: child);
  }

  Widget buildTileChild(Contribution contribution, AppTheme appTheme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.m, vertical: Space.l),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Formatter.dateToString(contribution.transactionDate)),
              buildAmountText(contribution, appTheme)
            ],
          ),
        )
      ],
    );
  }

  Widget buildTileChildWithTitle(Contribution contribution, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0, left: Space.m, right: Space.m, top: Space.m),
          child: Text(contribution.title, style: appTheme.textStyles.subtitle),
        ),
        
        Padding(
          padding: const EdgeInsets.all(Space.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Formatter.dateToString(contribution.transactionDate)),
              buildAmountText(contribution, appTheme)
            ],
          ),
        )
      ],
    );
  }

  Widget buildAmountText(Contribution contribution, AppTheme appTheme) {
    var textStyle = appTheme.textStyles.bodyBold;
    if (contribution.type == ContributionType.increment.index) {
      return Text(
        '+ ${contribution.amount}',
        style: textStyle.copyWith(color: color(contribution.type, appTheme)),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text('- ${contribution.amount}',
        style: textStyle.copyWith(color: color(contribution.type, appTheme)), overflow: TextOverflow.ellipsis);
  }

  Color color(int contributionType, AppTheme appTheme) {
    if (contributionType == ContributionType.decrement.index) {
      return appTheme.colors.error.lighten(0.3);
    }
    return appTheme.colors.success.lighten(0.3);
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
