import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class GoalDetailView extends StatefulWidget {
  GoalDetailView({Key key, @required this.goal}) : super(key: key);

  final Goal goal;

  @override
  _GoalDetailViewState createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<GoalDetailView> {
  AppTheme appTheme;
  Localizer localizer;
  MediaQueryData mediaQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
    mediaQuery = context.getMediaQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Goal Detail'),
        actions: [
          IconButton(icon: Icon(AppIcons.delete), onPressed: (){}),
               IconButton(icon: Icon(AppIcons.pencil), onPressed: (){})
        ],
      ),
      body: ContentContainer(
        child: CustomScrollView(
          slivers: [buildHeader(), buildBody(),buildContributionButton()],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SliverPersistentHeader(
        delegate: FixedHeightSliverPersistentHeaderDelegate(
            height: 320,
            child: Padding(
              padding: const EdgeInsets.all(Space.m),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ContentTitle(
                    title: widget.goal.title,
                    maxLines: 1,
                    padding: EdgeInsets.only(),
                  ),
                  IndentDivider(),
                  AmountPercentCircularIndicator(
                      lineWidth: 6,
                      radius: 200,
                      totalValue: widget.goal.targetAmount,
                      value: widget.goal.deposited,
                      child: CircularImage(radius: 80, img: widget.goal.img)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(style:ButtonStyle (backgroundColor:MaterialStateProperty.all<Color>( appTheme.colors.error)) ,onPressed: () {}, child: Icon(AppIcons.minus)),
                      ElevatedButton(style:ButtonStyle (backgroundColor:MaterialStateProperty.all<Color>( appTheme.colors.success)),onPressed: () {}, child: Icon(AppIcons.plus)),
                    ],
                  )
                ],
              ),
            )));
  }

  Widget buildBody() {
    return SliverPersistentHeader(
        delegate: FixedHeightSliverPersistentHeaderDelegate(
            height: 210,
            child: Column(
              children: [
                Divider(
                  color: appTheme.colors.fontPale,
                ),
                Row(
                  children: [
                    buildTile(localizer.goalAmount,widget.goal.targetAmount.toCurrencyString()),
                    SizedBox(
                      height: 100,
                      child: VerticalDivider(  color: appTheme.colors.fontPale,),
                    ),
                    buildTile(localizer.deposited,widget.goal.deposited.toCurrencyString())
                  ],
                ),
                Divider(  color: appTheme.colors.fontPale,),
                Row(
                  children: [
                    buildTile(localizer.remaining,(widget.goal.targetAmount-widget.goal.deposited).toCurrencyString()),
                    SizedBox(
                      height: 100,
                      child: VerticalDivider(  color: appTheme.colors.fontPale,),
                    ),
                    buildTile(localizer.goalDate,Formatter.dateToString(widget.goal.targetDate))
                  ],
                ),
                Divider(  color: appTheme.colors.fontPale,),
              ],
            )));
  }

  Widget buildTile(String title,String value) {
    return SizedBox(
        width: mediaQuery.size.widthPercent(49),
        height: 100,
        child: Padding(
          padding: EdgeInsets.all(Space.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontPale),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.xxs),
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: appTheme.textStyles.subtitle,
                ),
              )
            ],
          ),
        ));
  }


    Widget buildContributionButton() {
    return SliverPersistentHeader(
        delegate: FixedHeightSliverPersistentHeaderDelegate(
            height: 50,
           child: Padding(padding: EdgeInsets.all(Space.m),
            child: SizedBox(width: mediaQuery.size.width,
            child: ElevatedButton(onPressed: (){},child: Text(localizer.contributions)),
            ),

           )
          ));
  }

  


}
