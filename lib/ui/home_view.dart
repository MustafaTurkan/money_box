import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

enum Views { goals, complate }

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>{
  TabController tabController;
  Localizer localizer;
  bool addGoalVisiblity = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Views.values.length,
      child: Builder(
        builder: (context) {
          tabController = DefaultTabController.of(context);
          tabController.addListener(_handlerTabView);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(AppIcons.filter),
                onPressed: () {},
              ),
              centerTitle: true,
              title: Text(localizer.appName),
              actions: [
                IconButton(
                  icon: Icon(AppIcons.cog),
                  onPressed: () {},
                )
              ],
              bottom: TabBar(
                controller: tabController,
                tabs: [
                  Tab(text: localizer.goals),
                  Tab(text: localizer.completed),
                ],
              ),
            ),
            body: Container(
                child: TabBarView(
              children: [
                ContentContainer(
                    child: Center(
                  child: Text('Goals'),
                )),
                ContentContainer(
                    child: Center(
                  child: Text('Completed'),
                ))
              ],
            )),
            floatingActionButton: addGoalVisiblity
                ? FloatingActionButton(
                    onPressed: () {},
                    child: Icon(AppIcons.plus),
                  )
                : null,
          );
        },
      ),
    );
  }

  void _handlerTabView() {
    setState(() {
      if (tabController.index == Views.goals.index) {
        addGoalVisiblity = true;
        return;
      }
      addGoalVisiblity = false;
    });
  }
}
