import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class GoalListTile extends StatefulWidget {
  GoalListTile({Key key, @required this.goal, @required this.onDelete, @required this.onEdit}) : super(key: key);
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  _GoalListTileState createState() => _GoalListTileState();
}

class _GoalListTileState extends State<GoalListTile> {
  _GoalListTileState() : navigator = AppService.get<AppNavigator>();

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
    return Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(Space.m),
              child: GoalTileImage(goal: widget.goal),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: buildTitle(),
                      ),
                      Spacer(),
                      Expanded(child: buildDecrementButton(context)),
                      Expanded(child: buildIncrementButton(context))
                    ],
                  ),
                  IndentDivider(),
                  SizedBox(
                    height: Space.s,
                  ),
                  buildlineerRateIndicator(),
                  SizedBox(
                    height: Space.s,
                  ),
                ],
              ),
            )
          ],
        ));
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

  Widget buildTitle() {
    return Text(
      widget.goal.title,
      style: appTheme.textStyles.body,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildlineerRateIndicator() {
    return AmountPercentLineerIndicator(
        width: mediaQuery.size.widthPercent(75), totalValue: widget.goal.targetAmount, value: widget.goal.deposited);
  }

  Future<void> onDecrement(BuildContext context) async {
    var mobility = await navigator.pushContributionAdd(context, MobilityType.decrement);
    if (mobility != null) {}
  }

  Future<void> onIncrement(BuildContext context) async {
    var mobility = await navigator.pushContributionAdd(context, MobilityType.increment);

    if (mobility != null) {}
  }
}
