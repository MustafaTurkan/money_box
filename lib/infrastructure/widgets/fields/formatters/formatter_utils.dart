class FormatterUtils {
  static RegExp _digitRegex = RegExp(r'[-0-9]+');
  static RegExp _digitWithPeriodRegex = RegExp(r'[-0-9]+(\.[0-9]+)?');

  static String toNumericString(String inputString, {bool allowPeriod = false}) {
    if (inputString == null) {
      return '';
    }
    var regExp = allowPeriod ? _digitWithPeriodRegex : _digitRegex;
    return inputString.splitMapJoin(regExp, onMatch: (m) => m.group(0), onNonMatch: (nm) => '');
  }

  static bool isDigit(String character) {
    if (character == null || character.isEmpty || character.length > 1) {
      return false;
    }
    return _digitRegex.stringMatch(character) != null;
  }
}
