import 'dart:math';

import 'package:flutter/services.dart';

import '../../../ui.dart';



class MaskedInputFormater extends TextInputFormatter {
  MaskedInputFormater(this.mask, {this.anyCharMatcher}) : assert(mask != null);

  final String mask;
  final String _anyCharMask = '#';
  final String _onlyDigitMask = '0';
  final RegExp anyCharMatcher;
  String _lastValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var isErasing = newValue.text.length < oldValue.text.length;
    if (isErasing || _lastValue == newValue.text) {
      return newValue;
    }
    var maskedValue = applyMask(newValue.text);
    var endOffset = max(oldValue.text.length - oldValue.selection.end, 0);
    var selectionEnd = maskedValue.length - endOffset;
    _lastValue = maskedValue;
    return TextEditingValue(selection: TextSelection.collapsed(offset: selectionEnd), text: maskedValue);
  }

  bool _isMatchingRestrictor(String character) {
    if (anyCharMatcher == null) {
      return true;
    }
    return anyCharMatcher.stringMatch(character) != null;
  }

  String applyMask(String text) {
    var chars = text.split('');
    var result = <String>[];
    var maxIndex = min(mask.length, chars.length);
    var index = 0;
    for (var i = 0; i < maxIndex; i++) {
      var curChar = chars[index];
      if (curChar == mask[i]) {
        result.add(curChar);
        index++;
        continue;
      }
      if (mask[i] == _anyCharMask) {
        if (_isMatchingRestrictor(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else if (mask[i] == _onlyDigitMask) {
        if (FormatterUtils.isDigit(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else {
        result.add(mask[i]);
        result.add(curChar);
        index++;
        continue;
      }
    }

    return result.join();
  }
}
