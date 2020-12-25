import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:money_box/ui/ui.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class RectangleImage extends StatelessWidget {
  const RectangleImage({Key key, @required this.img, @required this.height, @required this.width}) : super(key: key);

  final Uint8List img;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    var emptyPhoto = Icon(
      AppIcons.camera,
      size: width / 2,
    );
    return Container(
      margin: EdgeInsets.all(Space.m),
      padding: EdgeInsets.all(Space.xs),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.colors.canvas), borderRadius: appTheme.data.cardBorderRadius()),
      height: height,
      width: width,
      child: img == null ? emptyPhoto : Image.memory(img, fit: BoxFit.contain),
    );
  }
}
