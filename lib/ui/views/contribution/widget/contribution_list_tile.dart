import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/ui/theme/app_theme.dart';
import 'package:money_box/ui/ui.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class ContributionListTile extends StatelessWidget {
  const ContributionListTile({Key key, @required this.appTheme, @required this.contribution}) : super(key: key);

  final AppTheme appTheme;
  final Contribution contribution;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: kMinInteractiveDimension,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                if (!contribution.title.isNullOrEmpty()) buildNote(),
              ],
            )),
          ],
        ),
      ),
    ));
  }

  Padding buildNote() {
    return Padding(
      padding: EdgeInsets.only(top: Space.s),
      child: Text(
        contribution.title,
        overflow: TextOverflow.ellipsis,
        style: appTheme.data.textTheme.caption.copyWith(color: appTheme.colors.fontPale),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Formatter.dateToString(contribution.transactionDate),
          overflow: TextOverflow.ellipsis,
        ),
        buildAmountText(),
      ],
    );
  }

  Widget buildAmountText() {
    var textStyle = appTheme.textStyles.bodyBold;
    if (contribution.type == ContributionType.increment.index) {
      return Text(
        '+ ${contribution.amount}',
        style: textStyle.copyWith(color: color(contribution.type, appTheme)),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text('- ${contribution.amount}',
        style: textStyle.copyWith(color: color(contribution.type, appTheme)), overflow: TextOverflow.ellipsis);
  }

  Color color(int contributionType, AppTheme appTheme) {
    if (contributionType == ContributionType.decrement.index) {
      return appTheme.colors.error;
    }
    return appTheme.colors.success;
  }
}
