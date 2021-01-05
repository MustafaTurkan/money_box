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

  Future<Goal> pushContributionAdd(BuildContext context, Goal goal, ContributionType contributionType) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => ContributionAddView(
                contributionType: contributionType,
                goal: goal,
              )),
    );
  }

  Future<bool> pushCompletedGoals(BuildContext context, List<Goal> goals) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CompleteGoalView(
                goals: goals,
              )),
    );
  }

  Future<bool> pushGoalDetail(BuildContext context, Goal goal) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GoalDetailView(
                goal: goal,
              )),
    );
  }

  Future<bool> pushCompletedContributionList(BuildContext context, List<Contribution> contributions) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => CompletedContributionListView(contributions: contributions)),
    );
  }

  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
