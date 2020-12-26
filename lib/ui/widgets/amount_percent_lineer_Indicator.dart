
import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class AmountPercentLineerIndicator extends StatelessWidget {
  const AmountPercentLineerIndicator({Key key,@required this.width,@required this.totalValue,@required this.value}) : super(key: key);
  
  final double width;
  final double totalValue;
  final double value;


  @override
  Widget build(BuildContext context) {
    var appTheme=context.getTheme();
    return LinearPercentIndicator(
                      width: width,
                      animation: true,
                      lineHeight: 20,
                      animationDuration: 2500,
                      backgroundColor: appTheme.colors.primaryPale.withOpacity(0.8),
                      percent: getPercent(),
                      center: Text(
                       '%${calculateRate(value, totalValue).toString()}',
                        style: appTheme.textStyles.bodyBold.copyWith(color: appTheme.colors.fontLight),
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: appTheme.colors.primary,
                    );
  }

    double calculateRate(double value, double totalValue) {
    if (totalValue == 0) {
      return 0;
    }
    return double.parse(( (value * 100) / totalValue).toStringAsFixed(2));
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