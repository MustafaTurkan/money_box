import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/ui/theme/app_icons.dart';
import 'package:money_box/ui/theme/app_theme.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class ContributionAddView extends StatefulWidget {
  ContributionAddView({Key key, @required this.mobilityType}) : super(key: key);

  final MobilityType mobilityType;

  @override
  _ContributionAddViewState createState() => _ContributionAddViewState();
}

class _ContributionAddViewState extends State<ContributionAddView> {
  AppTheme appTheme;
  Localizer localizer;
  DateTime currentDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
  }

  @override
  Widget build(BuildContext context) {
    var titleText = widget.mobilityType == MobilityType.decrement ? localizer.decrementMoney : localizer.incrementMoney;
    var color = widget.mobilityType == MobilityType.decrement ? appTheme.colors.error : appTheme.colors.success;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titleText,
          style: appTheme.textStyles.title.copyWith(color: color),
        ),
            ),
      body: ContentContainer(
        margin: EdgeInsets.zero,
        child: buildForm(context),
      ),
      floatingActionButton:FloatingActionButton(onPressed:(){},backgroundColor:color,child:Icon(AppIcons.check),),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      child: ListView(
        shrinkWrap: true,
        children: [
          FieldContainer(
              padding: const EdgeInsets.all(Space.m), labelText: localizer.goalAmount, child: TextFormField()),
          FieldContainer(padding: const EdgeInsets.all(Space.m), labelText: localizer.note, child: TextFormField()),
          FieldContainer(
            padding: const EdgeInsets.all(Space.m),
            labelText: localizer.goalDate,
            child: DateField(
              value: currentDate,
              onChanged: (val) {
                setState(() {
                  currentDate = val;
                });
              },
            ),
          )
        ],
      ),
    );
  }


  


}
