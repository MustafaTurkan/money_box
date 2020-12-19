import 'package:flutter/material.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/ui/ui.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class GoalTileImage extends StatelessWidget {
  const GoalTileImage({Key key, @required this.goal}) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    var emptyPhoto = Icon(
      AppIcons.camera,
    );
    return CircleAvatar(
      radius: 30,
      backgroundColor: appTheme.colors.canvas,
      backgroundImage: goal.img == null ? null : MemoryImage(goal.img),
      child: goal.img == null ? emptyPhoto : null,
    );
  }
}
