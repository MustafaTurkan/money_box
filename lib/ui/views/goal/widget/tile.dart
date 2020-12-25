import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class Tile extends StatefulWidget {
  Tile({Key key, @required this.goal}) : super(key: key);
  final Goal goal;
  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  final double cardHeight = 210;
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
            appTheme: appTheme, label: localizer.goalAmount, value: Formatter.moneyToString(widget.goal.targetAmount)),
        IndentDivider(),
        WidgetFactory.columnLabelValue(
            appTheme: appTheme, label: localizer.deposited, value: Formatter.moneyToString(widget.goal.deposited)),
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
        onPressed: () {});
  }

  Widget buildDeleteButton() {
    return IconButton(
        icon: Icon(
          AppIcons.deleteOutline,
          color: appTheme.colors.error,
        ),
        onPressed: () {});
  }
}
