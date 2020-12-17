import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RestrictingInputFormatter extends TextInputFormatter {
  RestrictingInputFormatter._internal();

  factory RestrictingInputFormatter.restrictFromString({
    @required String restrictedChars,
  }) {
    assert(restrictedChars != null && restrictedChars.isNotEmpty);
    var formatter = RestrictingInputFormatter._internal();
    formatter._allow = false;
    restrictedChars = formatter._escape(restrictedChars);
    formatter._restrictor = RegExp('[$restrictedChars]+');
    return formatter;
  }

  factory RestrictingInputFormatter.allowFromString({
    @required String allowedChars,
  }) {
    assert(allowedChars != null && allowedChars.isNotEmpty);
    var formatter = RestrictingInputFormatter._internal();
    formatter._allow = true;
    allowedChars = formatter._escape(allowedChars);
    formatter._restrictor = RegExp('[$allowedChars]+');
    return formatter;
  }

  RegExp _restrictor;
  bool _allow;

  String _escapeSpecialChar(String char) {
    switch (char) {
      case '[':
      case ']':
      case '(':
      case ')':
      case '^':
      case '.':
        return '\\$char';
    }
    return char;
  }

  String _escape(String text) {
    var hashSet = HashSet<String>();
    var containsSlash = text.contains('\\');
    text = text.replaceAll(RegExp(r'[\\]+'), '');
    for (var i = 0; i < text.length; i++) {
      var char = text[i];
      hashSet.add(_escapeSpecialChar(char));
    }

    var filteredString = hashSet.join('');
    if (containsSlash) {
      filteredString += '\\';
      filteredString += '\\';
    }
    return filteredString;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var selection = newValue.selection;
    var newText = newValue.text;
    if (!_allow) {
      if (_restrictor.hasMatch(newValue.text)) {
        newText = newValue.text.replaceAll(_restrictor, '');
      }
    } else {
      newText = _restrictor
          .allMatches(newValue.text)
          .map(
            (e) => newValue.text.substring(e.start, e.end),
          )
          .join('');
    }
    selection = newValue.selection;
    if (selection.end >= newText.length) {
      selection = selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }
    return TextEditingValue(
      text: newText,
      selection: selection,
    );
  }
}
