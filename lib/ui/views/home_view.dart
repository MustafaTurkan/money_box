import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

enum Views { goals, complate }

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState() : repository = AppService.get<IGoalRepository>();

  final IGoalRepository repository;

  TabController tabController;
  Localizer localizer;
  Future<List<Goal>> futureGoals;

  @override
  void initState() {
    super.initState();
    futureGoals = repository.getGoals();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(AppIcons.cog),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(localizer.appName),
          actions: [
            IconButton(
              icon: Icon(AppIcons.playlistCheck),
              onPressed: () {},
            ),
                        IconButton(
              icon: Icon(AppIcons.filter),
              onPressed: () {},
            )
          ],
        ),
        body: ContentContainer(
          child: FutureBuilder<List<Goal>>(
              future: futureGoals,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: WidgetFactory.dotProgressIndicator());
                }
                if (snapshot.hasError) {
                  return BackgroundHint.unExpectedError(context);
                }

                return _buildGoals(snapshot.data);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(AppIcons.plus),
        ));
  }

  Widget _buildGoals(List<Goal> goals) {
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


}
