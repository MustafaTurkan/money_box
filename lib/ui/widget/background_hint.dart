import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class BackgroundHint extends StatelessWidget {
  const BackgroundHint({
    Key key,
    @required String message,
    IconData iconData,
  }) : this._(
          key: key,
          message: message,
          icon: null,
          iconData: iconData,
        );

  const BackgroundHint._({
    Key key,
    this.message,
    this.icon,
    this.iconData,
  }) : super(key: key);

  /// Use when user perform a search and result contain no data
  factory BackgroundHint.recordNotFound(BuildContext context) {
    return BackgroundHint(
      message: context.getLocalizer().recordNotFound,
      iconData: AppIcons.magnifyRemoveOutline,
    );
  }

  /// Use there is no data to render.
  factory BackgroundHint.noData(BuildContext context, [String message]) {
    return BackgroundHint(
      message: message ?? context.getLocalizer().noData,
      iconData: AppIcons.weatherWindy,
    );
  }

  /// Use when error occurred , but have to build a widget
  factory BackgroundHint.unExpectedError(BuildContext context) {
    return BackgroundHint(
      message: context.getLocalizer().anUnExpectedErrorOccurred,
      iconData: AppIcons.virusOutline,
    );
  }

  /// Use when data loading but [WaitDialog] not usable
  factory BackgroundHint.loading(BuildContext context, String message) {
    var appTheme = context.getTheme();
    return BackgroundHint._(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: Space.m),
        child: WidgetFactory.circularProgressIndicator(
            size: kMinInteractiveDimension * 0.75, color: appTheme.colors.primary),
      ),
      message: message,
    );
  }

  final String message;
  final Widget icon;
  /// The icon to display.Default value is AppIcons.lighthouseOn
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon ??
            Icon(
            
              iconData ?? AppIcons.lighthouseOn,
              color: appTheme.colors.primary.withOpacity(0.3),
              size: context.getMediaQuery().size.widthPercent(50)
            ),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(Space.s),
          child: Text(message,
              textAlign: TextAlign.center,
              style: appTheme.textStyles.title.copyWith(color: appTheme.colors.primary.withOpacity(0.3))),
        ))
      ],
    );
  }
}
