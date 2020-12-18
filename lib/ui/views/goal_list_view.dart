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
  AppTheme appTheme;
  MediaQueryData mediaQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
    mediaQuery = context.getMediaQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: buildSettingButton(),
          centerTitle: true,
          title: Text(localizer.appName),
          actions: [buildCompleteGoalsButton(), buildFilterButton()],
        ),
        body: FutureBuilder<List<Goal>>(
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
        floatingActionButton: buildGoalAddButton());
  }

  Widget buildGoals(List<Goal> goals) {
    if (goals.isNullOrEmpty()) {
      return BackgroundHint(
        iconData: AppIcons.bullseyeArrow,
        message: localizer.dontHaveActiveGoals,
      );
    }
    return CustomScrollView(
      slivers: [
        Statistics(appTheme: appTheme, mediaQuery: mediaQuery, context: context),
      ],
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
    return FloatingActionButton(
      onPressed: () async {
        await onGoalAdd(context);
      },
      child: Icon(AppIcons.plus),
    );
  }

  Future<void> onGoalAdd(BuildContext context) async {
    await navigator.pushGoalAdd(context); //Todo:will return isAdd if true setState
    setState(() {});
  }
}

class Statistics extends StatelessWidget {
   Statistics({
    Key key,
    @required this.appTheme,
    @required this.mediaQuery,
    @required this.context,
  }) : super(key: key);

  
  final AppTheme appTheme;
  final MediaQueryData mediaQuery;
  final BuildContext context;
  final double dashboardHeight = 180;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        floating: true,
        delegate: FixedHeightSliverPersistentHeaderDelegate(
            rebuild: true,
            height: dashboardHeight,
            child: ContentContainer(
              child: Column(
                children: [
                  CardTitle(
                    backgroundColor: appTheme.colors.canvasLight,
                    title: 'Statistics',
                  ),
                  Padding(
                     padding:  EdgeInsets.only(bottom:Space.m,right: Space.l,left:Space.l),
                    child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        animation: true,
                        lineHeight: 20,
                        animationDuration: 2500,
                        backgroundColor:appTheme.colors.primaryPale.withOpacity(0.8),
                        percent: 0.4,
                        center: Text('80.0%',style: appTheme.textStyles.bodyBold.copyWith(color:appTheme.colors.fontLight),),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor:appTheme.colors.primary,
                      ),
                  ),
                        IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme, mediaQuery: mediaQuery, label: 'Total Amount', value: '250'),
                  IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme, mediaQuery: mediaQuery, label: 'Total Deposite', value: '100'),
                  IndentDivider(),
                  WidgetFactory.rowLabelValue(
                      appTheme: appTheme, mediaQuery: mediaQuery, label: 'Total Remaining', value: '150'),
              

                ],
              ),
            )));
  }
}
