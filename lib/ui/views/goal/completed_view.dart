import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class CompleteView extends StatefulWidget {
  CompleteView({Key key, @required this.goals}) : super(key: key);

  final List<Goal> goals;

  @override
  _CompleteViewState createState() => _CompleteViewState();
}

class _CompleteViewState extends State<CompleteView> {
  
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
              return Tile(goal: widget.goals[index]);
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
