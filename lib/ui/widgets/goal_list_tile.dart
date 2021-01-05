import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class GoalListTile extends StatefulWidget {
  GoalListTile({Key key, @required this.goal, @required this.onAddContribution, @required this.onTab})
      : super(key: key);
  final Goal goal;
  final Function(Goal) onAddContribution;
  final Function(Goal) onTab;
  @override
  _GoalListTileState createState() => _GoalListTileState();
}

class _GoalListTileState extends State<GoalListTile> {
  _GoalListTileState() : navigator = AppService.get<AppNavigator>();

  final double cardHeight = 136;
  MediaQueryData mediaQuery;
  Localizer localizer;
  AppTheme appTheme;
  AppNavigator navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mediaQuery = context.getMediaQuery();
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTab(widget.goal);
      },
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: Space.xxs, vertical: Space.xs),
          child: SizedBox(
            height: cardHeight,
            child: Column(
              children: [
                buildTitle(context),
                IndentDivider(),
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Space.m),
                        child: CircularImage(
                          img: widget.goal.img,
                          radius: 35,
                        ),
                      ),
                      VerticalDivider(
                        indent: Space.s,
                        endIndent: Space.s,
                        thickness: 0.5,
                      ),
                      Expanded(child: buildDetail())
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ContentTitle(
            title: widget.goal.title,
            maxLines: 1,
          ),
        ),
        buildDecrementButton(context),
        buildIncrementButton(context),
      ],
    );
  }

  Widget buildDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetFactory.columnLabelValue(
            appTheme: appTheme, label: localizer.goalAmount, value: widget.goal.targetAmount.toCurrencyString()),
        //IndentDivider(),
        buildlineerRateIndicator()
      ],
    );
  }

  Widget buildlineerRateIndicator() {
    return Padding(
      padding: EdgeInsets.all(Space.m),
      child: AmountPercentLineerIndicator(
          width: mediaQuery.size.widthPercent(65), totalValue: widget.goal.targetAmount, value: widget.goal.deposited),
    );
  }

  Widget buildIncrementButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          AppIcons.plusCircleOutline,
          color: appTheme.colors.success,
        ),
        onPressed: () async {
          await onIncrement(context);
        });
  }

  Widget buildDecrementButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          AppIcons.minusCircleOutline,
          color: appTheme.colors.error,
        ),
        onPressed: () async {
          await onDecrement(context);
        });
  }

  Future<void> onDecrement(BuildContext context) async {
    var result = await navigator.pushContributionAdd(context, widget.goal, ContributionType.decrement);
    if (result != null) {
      widget.onAddContribution(result);
    }
  }

  Future<void> onIncrement(BuildContext context) async {
    var result = await navigator.pushContributionAdd(context, widget.goal, ContributionType.increment);
    if (result != null) {
      widget.onAddContribution(result);
    }
  }
}
