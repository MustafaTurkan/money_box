import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:money_box/ui/ui.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class RectangleImage extends StatelessWidget {
  const RectangleImage({Key key,@required this.img,@required this.height,@required this.width}) : super(key: key);

  final Uint8List img;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    var appTheme=context.getTheme();
    var emptyPhoto = Icon(
      AppIcons.camera,
    );
    return Padding(
      padding: const EdgeInsets.only(left: Space.s, right: Space.s, bottom: Space.s),
      child:img==null?emptyPhoto:Container(
        decoration: BoxDecoration(
            border: Border.all(color: appTheme.colors.canvas), borderRadius: appTheme.data.cardBorderRadius()),
        margin: EdgeInsets.zero,
        width: width,
        height: height,
        padding: EdgeInsets.all(Space.xs),
        child: Image.memory(img, fit: BoxFit.contain),
      ),
    );
  }
}