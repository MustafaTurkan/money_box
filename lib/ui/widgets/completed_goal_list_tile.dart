import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class CompletedGoalListTile extends StatefulWidget {
  CompletedGoalListTile({Key key, @required this.goal}) : super(key: key);
  final Goal goal;
  @override
  _CompletedGoalListTileState createState() => _CompletedGoalListTileState();
}

class _CompletedGoalListTileState extends State<CompletedGoalListTile> {
  _CompletedGoalListTileState()
      : navigator = AppService.get<AppNavigator>(),
        contributionRepository = AppService.get<IContributionRepository>();
  final double cardHeight = 210;
  final AppNavigator navigator;
  final IContributionRepository contributionRepository;
  AppTheme appTheme;
  Localizer localizer;
  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                RectangleImage(img: widget.goal.img, height: 120, width: 90),
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
    ));
  }

  Padding buildImage() {
    return Padding(
      padding: const EdgeInsets.all(Space.m),
      child: Padding(
        padding: const EdgeInsets.only(left: Space.s, right: Space.s, bottom: Space.s),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: appTheme.colors.canvas), borderRadius: appTheme.data.cardBorderRadius()),
          margin: EdgeInsets.zero,
          width: 1,
          height: 100,
          padding: EdgeInsets.all(Space.xs),
          child: Image.memory(widget.goal.img, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget buildDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetFactory.columnLabelValue(
            appTheme: appTheme, label: localizer.goalAmount, value: widget.goal.targetAmount.toCurrencyString()),
        IndentDivider(),
        WidgetFactory.columnLabelValue(
            appTheme: appTheme, label: localizer.deposited, value: widget.goal.deposited.toCurrencyString()),
        IndentDivider(),
        WidgetFactory.columnLabelValue(
            appTheme: appTheme, label: localizer.goalDate, value: Formatter.dateToString(widget.goal.targetDate)),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ContentTitle(
            icon:
                Padding(padding: const EdgeInsets.symmetric(horizontal: Space.m), child: Icon(AppIcons.filterVariant)),
            title: widget.goal.title,
            maxLines: 1,
          ),
        ),
        buildDeleteButton(),
        buildContributionButton()
      ],
    );
  }

  Widget buildContributionButton() {
    return IconButton(
        icon: Icon(
          AppIcons.homeCurrencyUsd,
          color: appTheme.colors.success,
        ),
        onPressed: () async {
          await onContributions();
        });
  }

  Widget buildDeleteButton() {
    return IconButton(
        icon: Icon(
          AppIcons.deleteOutline,
          color: appTheme.colors.error,
        ),
        onPressed: () {});
  }

  Future<void> onContributions() async {
    var result = await WaitDialog.scope<List<Contribution>>(
        context: context, call: (_) async => contributionRepository.getContributions(widget.goal.id));
    await navigator.pushCompleteContributionList(context, result);
  }
}
