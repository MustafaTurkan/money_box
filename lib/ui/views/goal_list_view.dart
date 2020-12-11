import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class GoalListView extends StatefulWidget {
  GoalListView({Key key}) : super(key: key);

  @override
  _GoalListViewState createState() => _GoalListViewState();
}

class _GoalListViewState extends State<GoalListView> {
  _GoalListViewState()
      : repository = AppService.get<IGoalRepository>(),
        navigator = AppService.get<AppNavigator>();

  final IGoalRepository repository;
  final AppNavigator navigator;
  Localizer localizer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: buildSettingButton(),
          centerTitle: true,
          title: Text(localizer.appName),
          actions: [
            buildCompleteGoalsButton(),
            buildFilterButton()
          ],
        ),
        body: ContentContainer(
          child: FutureBuilder<List<Goal>>(
              future: repository.getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: WidgetFactory.dotProgressIndicator());
                }
                if (snapshot.hasError) {
                  return BackgroundHint.unExpectedError(context);
                }
                return buildGoals(snapshot.data);
              }),
        ),
        floatingActionButton:buildGoalAddButton());
  }

  Widget buildGoals(List<Goal> goals) {
    if (goals.isNullOrEmpty()) {
      return BackgroundHint(
        iconData: AppIcons.piggyBank,
        message: localizer.dontHaveActiveGoals,
      );
    }
    return Center(
      child: Text('Goals'),
    );
  }

  Widget buildSettingButton() {
    return IconButton(
      icon: Icon(AppIcons.cog),
      onPressed: () {},
    );
  }

  Widget buildCompleteGoalsButton() {
    return IconButton(
      icon: Icon(AppIcons.playlistCheck),
      onPressed: () {},
    );
  }

  Widget buildFilterButton() {
    return IconButton(
      icon: Icon(AppIcons.filter),
      onPressed: () {},
    );
  }

  Widget buildGoalAddButton()
  {
    return  FloatingActionButton(
          onPressed: () async {
            await onGoalAdd(context);
          },
          child: Icon(AppIcons.plus),
        );
  }


  Future<void> onGoalAdd(BuildContext context) async {
    await navigator.pushGoalAdd(context);
    setState(() {});
  }
}
