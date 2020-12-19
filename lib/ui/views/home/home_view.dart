import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

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

  Widget buildEmpty() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: buildSettingButton(),
          title: Text(localizer.appName),
        ),
        body: BackgroundHint(
          iconData: AppIcons.piggyBank,
          message: localizer.dontHaveActiveGoals,
        ));
  }

  Widget buildBody(List<Goal> intialGoals) {
    if (intialGoals.isNullOrEmpty()) {
      return buildEmpty();
    }
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
              return CustomScrollView(
                controller: scrollontroller,
                slivers: [
                  TotalStatistics(
                    appTheme: appTheme,
                    mediaQuery: mediaQuery,
                    localizer: localizer,
                    goals: state.goals,
                  ),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: FixedHeightSliverPersistentHeaderDelegate(
                        height: 35,
                        child: ContentTitle(
                          backgroundColor: appTheme.colors.canvas,
                          title: localizer.goals,
                          padding: EdgeInsets.fromLTRB(Space.s, Space.m, Space.s, Space.s),
                        ),
                      )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GoalListTile(goal: state.goals[index], onDelete: null, onEdit: null);
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
