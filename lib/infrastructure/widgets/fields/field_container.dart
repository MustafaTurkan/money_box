import 'package:flutter/material.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
class FieldContainer extends StatelessWidget {
  FieldContainer({@required this.child, this.labelText, this.padding});

  final String labelText;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (labelText.isNullOrWhiteSpace()) {
      return Padding(
        padding: padding ?? const EdgeInsets.all(Space.s),
        child: child,
      );
    }
    return Padding(
      padding: padding ?? const EdgeInsets.all(Space.s),
      child: Column(children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.m, 0, Space.m, Space.s),
              child: Text(
                labelText,
                textAlign: TextAlign.left,
             
              ),
            )),
        child
      ]),
    );
  }
}
