import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class SnackBarAlert {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error({
    @required BuildContext context,
    @required String message,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool removeCurrent = true,
  }) {
    final appTheme = context.getTheme();
    return _showSnackBar(
      context,
      AppIcons.alertCircleOutline,
      appTheme.colors.error,
      message,
      behavior: behavior,
      removeCurrent: removeCurrent,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info({
    @required BuildContext context,
    @required String message,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool removeCurrent = true,
  }) {
    final appTheme = Provider.of<AppTheme>(context, listen: false);
    return _showSnackBar(
      context,
      AppIcons.informationOutline,
      appTheme.colors.info,
      message,
      behavior: behavior,
      removeCurrent: removeCurrent,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> warning({
    @required BuildContext context,
    @required String message,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool removeCurrent = true,
  }) {
    final appTheme = Provider.of<AppTheme>(context, listen: false);
    return _showSnackBar(
      context,
      AppIcons.alert,
      appTheme.colors.warning,
      message,
      behavior: behavior,
      removeCurrent: removeCurrent,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
    BuildContext context,
    IconData iconData,
    Color backgroundColor,
    String text, {
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool removeCurrent = true,
  }) {
    if (removeCurrent) {
      Scaffold.of(context).removeCurrentSnackBar();
    }

    return Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: behavior,
        content: Row(
          children: <Widget>[
            Icon(iconData, color: Colors.white),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left:  Space.s),
              child: Text(text, textAlign: TextAlign.center),
            )),
          ],
        ),
      ),
    );
  }
}
