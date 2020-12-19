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
  MediaQueryData mediaQuery;
  Localizer localizer;
  AppTheme appTheme;

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
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            ListTile(
                leading:GoalTileImage(goal: widget.goal),
                title: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.goal.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(
                              AppIcons.minusCircleOutline,
                              color: appTheme.colors.error,
                            ),
                            onPressed: () {})),
                    Expanded(flex: 1, child: IconButton(icon: Icon(AppIcons.plusCircleOutline), onPressed: () {}))
                  ],
                ),
                subtitle: Text(Formatter.dateToString(widget.goal.targetDate))),
            IndentDivider(),
            buildlineerRateIndicator(),
          ],
        ));
  }

  Widget buildlineerRateIndicator() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.m, horizontal: Space.l),
        child: AmountRateIndicator(
            width: mediaQuery.size.widthPercent(90),
            showValue: true,
            totalValue: widget.goal.targetAmount,
            value: widget.goal.deposited));
  }
}
