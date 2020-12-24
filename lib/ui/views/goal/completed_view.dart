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
        title: Text(localizer.complatedGoals),
      ),
      body: CustomScrollView(
        slivers: [
          
        ],
      ),
      bottomSheet:buildBottomTitle() ,
    );
  }

  Widget buildBottomTitle() {
    return ContentTitle(
      
        icon: Icon(AppIcons.check),
        backgroundColor: appTheme.colors.canvasLight,
        title: localizer.totalCompletedAmount,
        padding: EdgeInsets.fromLTRB(Space.s, Space.s, Space.s, Space.s),
        leadingText: widget.goals.sum((e) => e.deposited.orDefault()).toCurrencyString(),
      );
  }
}
