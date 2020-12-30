import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/app_navigator.dart';

class ChooseSortDialog extends StatelessWidget {
  const ChooseSortDialog({Key key, @required this.navigator, @required this.localizer}) : super(key: key);

  final AppNavigator navigator;
  final Localizer localizer;

  static Future<SortType> show(BuildContext context, AppNavigator navigator,Localizer localizer) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ChooseSortDialog(
          navigator: navigator,
          localizer:localizer
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: CardTitle(
        title: localizer.sort,
      ),
      children: [
        alphabeticalOption(context),
        IndentDivider(),
        minGoalAmountOption(context),
        IndentDivider(),
        maxGoalAmountOption(context),
      ],
    );
  }

  Widget alphabeticalOption(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        navigator.pop(context, result: SortType.alphabetical);
      },
      child: Text(localizer.byAlphabet),
    );
  }

  Widget minGoalAmountOption(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        navigator.pop(context, result: SortType.minGoalAmount);
      },
      child: Text(localizer.byMinGoalAmount),
    );
  }

  Widget maxGoalAmountOption(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        navigator.pop(context, result: SortType.maxGoalAmount);
      },
      child: Text(localizer.byMaxGoalAmount),
    );
  }
}

enum SortType { alphabetical, minGoalAmount, maxGoalAmount }
