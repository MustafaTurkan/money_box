
import 'package:money_box/infrastructure/infrastructure.dart';

class ValueDialogResult<T> {
  ValueDialogResult(this.dialogResult, {this.value});

  final DialogResult dialogResult;

  final T value;
}
