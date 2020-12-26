import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class AmountPercentCircularIndicator extends StatelessWidget {
  const AmountPercentCircularIndicator(
      {Key key, @required this.child, @required this.radius, @required this.totalValue, @required this.value})
      : super(key: key);

  final double totalValue;
  final double value;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();

   

    return CircularPercentIndicator(
      radius: 120,
      lineWidth: 5,
      animation: true,
      backgroundColor: appTheme.colors.primaryPale.withOpacity(0.6),
      animationDuration: 2500,
      percent: getPercent(),
      animateFromLastPercent: true,
      center: child,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: appTheme.colors.primary,
    );
  }
  
  double getPercent()
  {
     double percent= value / totalValue;
     if(percent<0)
     {return 0;}
     if(percent>1)
     {return 1;}
     return percent;
  }
}
