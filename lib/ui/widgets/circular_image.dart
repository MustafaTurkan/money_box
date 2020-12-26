import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({Key key, this.radius=30,@required this.img}) : super(key: key);

  final Uint8List  img;
  final double radius;
  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    var emptyPhoto = Icon(
      AppIcons.camera,
    );
    return CircleAvatar(
      radius: radius,
      backgroundColor: appTheme.colors.canvas,
      backgroundImage:img == null ? null : MemoryImage(img),
      child:img == null ? emptyPhoto : null,
    );
  }
}
