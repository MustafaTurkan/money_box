import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/ui/ui.dart';

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();

  Future<bool> pushGoalAdd(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalAddView()),
    );
  }

  Future<bool> pushContributionAdd(BuildContext context,Goal goal, MobilityType mobilityType) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
          builder: (context) => ContributionAddView(
                mobilityType: mobilityType,
                goal: goal,
              )),
    );
  }

  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
