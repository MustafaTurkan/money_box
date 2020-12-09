import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Localizer localizer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer=context.getLocalizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(localizer.appName),),
    );
  }
}