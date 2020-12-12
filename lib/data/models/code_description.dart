import 'package:money_box/infrastructure/infrastructure.dart';

class CodeDescription {
  CodeDescription(this.code, this.description) {
    code ??= '';
    description ??= '';
  }
  String code;
  String description;

  bool containsIgnoreCase(String keyword) {
    if (keyword.isNullOrEmpty()) {
      return true;
    }
    return code.containsIgnoreCase(keyword) || description.containsIgnoreCase(keyword);
  }

  @override
  bool operator ==(Object other) => other is CodeDescription && code.equalsIgnoreCase(other.code);

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return description;
  }

  static CodeDescription empty = CodeDescription('','');
}
