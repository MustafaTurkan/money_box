import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class CompleteGoalView extends StatefulWidget {
  CompleteGoalView({Key key, @required this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  _CompleteGoalViewState createState() => _CompleteGoalViewState();
}

class _CompleteGoalViewState extends State<CompleteGoalView> {
  _CompleteGoalViewState()
      : goalRepository = AppService.get<IGoalRepository>(),
        contributionRepository = AppService.get<IContributionRepository>();

  final double headerHeight = 35;
  final IGoalRepository goalRepository;
  final IContributionRepository contributionRepository;
  Localizer localizer;
  AppTheme appTheme;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizer.complatedGoals),
      ),
      body: BlocProvider<CompletedGoalListCubit>(
        create: (context) => CompletedGoalListCubit(
          contributionRepository: contributionRepository,
          goalRepository: goalRepository,
          goals: widget.goals,
        ),
        child: BlocBuilder<CompletedGoalListCubit, CompletedGoalListState>(
          builder: (context, state) {
            if (state is CompletedGoalListFail) {
              return BackgroundHint.unExpectedError(context);
            }
            if (state is CompletedGoalListSuccesed) {
              if (state.goals.isNullOrEmpty()) {
                return BackgroundHint(
                  iconData: AppIcons.piggyBank,
                  message: localizer.dontFindCompletedGoal,
                );
              }

              return CustomScrollView(
                slivers: [buildTitle(state.goals), buildBody(context, state.goals)],
              );
            }
            return Center(child: WidgetFactory.dotProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, List<Goal> goals) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return CompletedGoalListTile(
            goal: goals[index],
            onDelete: (id) async {
              await context.getBloc<CompletedGoalListCubit>().delete(id);
            },
          );
        },
        childCount: goals.length,
      ),
    );
  }

  Widget buildTitle(List<Goal> goals) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: FixedHeightSliverPersistentHeaderDelegate(
          height: headerHeight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Space.xxs),
            child: ContentTitle(
              backgroundColor: appTheme.colors.canvasLight,
              icon: WidgetFactory.emptyWidget(),
              title: localizer.totalDeposited,
              leadingText: goals.sum((e) => e.deposited.orDefault()).toCurrencyString(),
            ),
          ),
        ));
  }
}
