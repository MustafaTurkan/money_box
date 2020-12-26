import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class CompleteGoalView extends StatefulWidget {
  CompleteGoalView({Key key, @required this.goals}) : super(key: key);

  final List<Goal> goals;

  @override
  _CompleteGoalViewState createState() => _CompleteGoalViewState();
}

class _CompleteGoalViewState extends State<CompleteGoalView> {
  
  final double headerHeight=35;
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
      body: CustomScrollView(
        slivers: [
          buildTitle(),
          buildBody()
        ],
      ),
    );
  }

  Widget buildBody() {
    return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CompletedGoalListTile(goal: widget.goals[index]);
            },
            childCount: widget.goals.length,
          ),
        );
  }

  Widget buildTitle() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: FixedHeightSliverPersistentHeaderDelegate(
          height:headerHeight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Space.xxs),
            child: ContentTitle(
              backgroundColor: appTheme.colors.canvasLight,
              icon: WidgetFactory.emptyWidget(),
              title: localizer.totalCompletedAmount,
              leadingText: widget.goals.sum((e) => e.deposited.orDefault()).toCurrencyString(),
            ),
          ),
        ));
  }
}