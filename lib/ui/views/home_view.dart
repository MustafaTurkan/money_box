import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState()
      : repository = AppService.get<IGoalRepository>(),
        navigator = AppService.get<AppNavigator>();

  final IGoalRepository repository;
  final AppNavigator navigator;
  ScrollController scrollontroller = ScrollController();
  Localizer localizer;
  AppTheme appTheme;
  MediaQueryData mediaQuery;
  Future<List<Goal>> futureGoal;
  bool showGoalAddButton = true;
  double dashboardHeight = 165;

  @override
  void initState() {
    super.initState();
    scrollontrollerListener();
    futureGoal = repository.getGoals();
  }

  @override
  void dispose() {
    scrollontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
    mediaQuery = context.getMediaQuery();
    dashboardHeight = math.max(dashboardHeight, mediaQuery.size.shortestSidePercent(35));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
      future: futureGoal,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return buildLoading();
        }
        if (snapshot.hasError) {
          return buildError();
        }
        return buildBody(snapshot.data);
      },
    );
  }

  Widget buildLoading() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(localizer.appName),
        ),
        body: Center(child: WidgetFactory.dotProgressIndicator()));
  }

  Widget buildError() {
    return Scaffold(
        appBar: AppBar(
          leading: buildSettingButton(),
          centerTitle: true,
          title: Text(localizer.appName),
        ),
        body: BackgroundHint.unExpectedError(context));
  }

  Widget buildBody(List<Goal> intialGoals) {
    return BlocProvider<GoalListCubit>(
      create: (context) => GoalListCubit(goalRepository: repository, goals: intialGoals),
      child: Scaffold(
        appBar: AppBar(
          leading: buildSettingButton(),
          centerTitle: true,
          title: Text(localizer.appName),
          actions: [buildCompleteGoalsButton(), buildFilterButton()],
        ),
        body: BlocBuilder<GoalListCubit, GoalListState>(
          builder: (context, state) {
            if (state is GoalListFail) {
              return BackgroundHint.unExpectedError(context);
            }
            if (state is GoalListSuccesed) {
              if (state.goals.isNullOrEmpty()) {
                return BackgroundHint(
                  iconData: AppIcons.piggyBank,
                  message: localizer.dontHaveActiveGoals,
                );
              }

              return CustomScrollView(
                controller: scrollontroller,
                slivers: [
                  SliverPersistentHeader(
                      delegate: FixedHeightSliverPersistentHeaderDelegate(
                    height: 32,
                    child: ContentTitle(
                      icon: Icon(AppIcons.chartArc),
                      backgroundColor: appTheme.colors.canvas,
                      title: localizer.total,
                      padding: EdgeInsets.fromLTRB(Space.s, Space.s, Space.s, Space.s),
                    ),
                  )),
                  SliverPersistentHeader(
                      //  floating: true,
                      delegate: FixedHeightSliverPersistentHeaderDelegate(
                          rebuild: true,
                          height: dashboardHeight,
                          child: TotalGoalDashboard(
                            appTheme: appTheme,
                            dashboardHeight: dashboardHeight,
                            goals: state.goals,
                            localizer: localizer,
                            mediaQuery: mediaQuery,
                          ))),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: FixedHeightSliverPersistentHeaderDelegate(
                        height: 32,
                        child: ContentTitle(
                          icon: Icon(AppIcons.formatListBulletedSquare),
                          backgroundColor: appTheme.colors.canvas,
                          title: localizer.goals,
                          padding: EdgeInsets.fromLTRB(Space.s, Space.s, Space.s, Space.s),
                        ),
                      )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GoalListTile(
                            goal: state.goals[index],
                            onAddContribution: (goal) async {
                              if (goal.targetAmount <= goal.deposited) {
                                SnackBarAlert.info(context: context, message: localizer.congratulations);
                              }
                              await context.getBloc<GoalListCubit>().loadGloals();
                            });
                      },
                      childCount: state.goals.length,
                    ),
                  )
                ],
              );
            }
            return Center(child: WidgetFactory.dotProgressIndicator());
          },
        ),
        floatingActionButton: showGoalAddButton ? buildGoalAddButton() : null,
      ),
    );
  }

  Widget buildSettingButton() {
    return IconButton(
      icon: Icon(AppIcons.cog),
      onPressed: () {},
    );
  }

  Widget buildCompleteGoalsButton() {
    return BlocBuilder<GoalListCubit, GoalListState>(builder: (context, state) {
      if (state is GoalListSuccesed) {
        return IconButton(
          icon: Icon(AppIcons.playlistCheck),
          onPressed: () async {
            var result =
                await WaitDialog.scope<List<Goal>>(context: context, call: (_) async => repository.getCopletedGoals());

            if (result.isNullOrEmpty()) {
              await MessageDialog.info(context: context, message: localizer.dontFindCompletedGoal);
              return;
            }
            await navigator.pushCompletedGoals(context, result);
          },
        );
      }
      return WidgetFactory.emptyWidget();
    });
  }

  Widget buildFilterButton() {
    return IconButton(
      icon: Icon(AppIcons.filter),
      onPressed: () {},
    );
  }

  Widget buildGoalAddButton() {
    if (!showGoalAddButton) {
      return null;
    }

    return Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () async {
            await onGoalAdd(context);
          },
          child: Icon(
            AppIcons.bullseyeArrow,
            size: 32,
          ),
        );
      },
    );
  }

  void scrollontrollerListener() {
    scrollontroller.addListener(() {
      if (scrollontroller.position.userScrollDirection == ScrollDirection.reverse) {
        if (showGoalAddButton) {
          setState(() {
            showGoalAddButton = false;
          });
        }
      }
      if (scrollontroller.position.userScrollDirection == ScrollDirection.forward) {
        if (!showGoalAddButton) {
          setState(() {
            showGoalAddButton = true;
          });
        }
      }
    });
  }

  Future<void> onGoalAdd(BuildContext context) async {
    var isAdded = await navigator.pushGoalAdd(context);
    if (isAdded != null) {
      await context.getBloc<GoalListCubit>().loadGloals();
    }
  }
}
