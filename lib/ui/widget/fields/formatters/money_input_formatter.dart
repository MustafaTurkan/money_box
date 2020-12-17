import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'utils.dart';

final RegExp _repeatingDots = RegExp(r'\.{2,}');
final RegExp _repeatingCommas = RegExp(r',{2,}');
final RegExp _repeatingSpaces = RegExp(r'\s{2,}');

class MoneyInputFormatter extends TextInputFormatter {
  MoneyInputFormatter({
    this.thousandSeparator = ThousandSeparator.comma,
    this.mantissaLength = 2,
    this.leadingSymbol = '',
    this.trailingSymbol = '',
    this.useSymbolPadding = false,
    this.onValueChange,
    this.maxTextLength,
  })  : assert(trailingSymbol != null),
        assert(leadingSymbol != null),
        assert(mantissaLength != null),
        assert(thousandSeparator != null),
        assert(useSymbolPadding != null);

  final ThousandSeparator thousandSeparator;
  final int mantissaLength;
  final String leadingSymbol;
  final String trailingSymbol;
  final bool useSymbolPadding;
  final int maxTextLength;
  final ValueChanged<double> onValueChange;

  bool isZero(String text) {
    var numeriString = Utils.toNumericString(text, allowPeriod: true);
    var value = double.tryParse(numeriString) ?? 0.0;
    return value == 0.0;
  }

  String _stripRepeatingSeparators(String input) {
    return input.replaceAll(_repeatingDots, '.').replaceAll(_repeatingCommas, ',').replaceAll(_repeatingSpaces, ' ');
  }

  bool _usesCommasForMantissa() {
    return thousandSeparator == ThousandSeparator.period ||
        thousandSeparator == ThousandSeparator.spaceAndCommaMantissa;
  }

  String _prepareDotsAndCommas(String value) {
    if (_usesCommasForMantissa()) {
      return _swapCommasAndPeriods(value);
    }
    return value;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int leadingLength = leadingSymbol.length;
    var newText = newValue.text;
    var oldText = oldValue.text;
    newText = _stripRepeatingSeparators(newText);
    oldText = _stripRepeatingSeparators(oldText);
    var usesCommaForMantissa = _usesCommasForMantissa();
    if (usesCommaForMantissa) {
      newText = _swapCommasAndPeriods(newText);
      oldText = _swapCommasAndPeriods(oldText);
      oldValue = oldValue.copyWith(text: oldText);
      newValue = newValue.copyWith(text: newText);
    }

    var isErasing = newValue.text.length < oldValue.text.length;

    TextSelection selection;

    var mantissaSymbol = '.';
    var leadingZeroWithDot = '${leadingSymbol}0$mantissaSymbol';
    var leadingZeroWithoutDot = '$leadingSymbol$mantissaSymbol';

    if (isErasing) {
      if (newValue.selection.end < leadingLength) {
        selection = TextSelection.collapsed(
          offset: leadingLength,
        );
        return TextEditingValue(
          selection: selection,
          text: _prepareDotsAndCommas(oldText),
        );
      }
    } else {
      if (maxTextLength != null) {
        if (newValue.text.length > maxTextLength) {
          var lastSeparatorIndex = oldText.lastIndexOf('.');
          var isAfterMantissa = newValue.selection.end > lastSeparatorIndex + 1;

          if (!newValue.text.contains('..')) {
            if (!isAfterMantissa) {
              return oldValue;
            }
          }
        }
      }

      if (oldValue.text.isEmpty) {
        return newValue;
      }
    }

    if (newText.startsWith(leadingZeroWithoutDot)) {
      newText = newText.replaceFirst(leadingZeroWithoutDot, leadingZeroWithDot);
    }
    _processCallback(newText);

    if (isErasing) {
      selection = newValue.selection;

      var lastSeparatorIndex = oldText.lastIndexOf('.');
      if (selection.end == lastSeparatorIndex) {
        selection = TextSelection.collapsed(
          offset: oldValue.selection.extentOffset - 1,
        );
        return TextEditingValue(
          selection: selection,
          text: _prepareDotsAndCommas(oldText),
        );
      }

      var isAfterSeparator = lastSeparatorIndex < selection.extentOffset;
      if (isAfterSeparator && lastSeparatorIndex > -1) {
        return newValue.copyWith(
          text: _prepareDotsAndCommas(newValue.text),
        );
      }
      var numSeparatorsBefore = _countSymbolsInString(
        newText,
        ',',
      );

      newText = toCurrencyString(
        newText,
        mantissaLength: mantissaLength,
        leadingSymbol: leadingSymbol,
        trailingSymbol: trailingSymbol,
        thousandSeparator: ThousandSeparator.comma,
        useSymbolPadding: useSymbolPadding,
      );
      var numSeparatorsAfter = _countSymbolsInString(
        newText,
        ',',
      );
      var selectionOffset = numSeparatorsAfter - numSeparatorsBefore;
      int offset = selection.extentOffset + selectionOffset;
      if (leadingLength > 0) {
        leadingLength = leadingSymbol.length;
        if (offset < leadingLength) {
          offset += leadingLength;
        }
      }
      selection = TextSelection.collapsed(
        offset: offset,
      );

      if (newText.contains(leadingZeroWithDot)) {
        newText = newText.replaceAll(
          leadingZeroWithDot,
          leadingZeroWithoutDot,
        );
        offset -= 1;
        if (offset < leadingLength) {
          offset = leadingLength;
        }
        selection = TextSelection.collapsed(
          offset: offset,
        );
      }

      return TextEditingValue(
        selection: selection,
        text: _prepareDotsAndCommas(newText),
      );
    }

    bool oldStartsWithLeading = leadingSymbol.isNotEmpty &&
        oldValue.text.startsWith(
          leadingSymbol,
        );

    var oldSelectionEnd = oldValue.selection.end;
    TextEditingValue value = oldSelectionEnd > -1 ? oldValue : newValue;
    String oldSubstrBeforeSelection = oldSelectionEnd > -1 ? value.text.substring(0, value.selection.end) : '';
    int numThousandSeparatorsInOldSub = _countSymbolsInString(
      oldSubstrBeforeSelection,
      ',',
    );

    var formattedValue = toCurrencyString(
      newText,
      leadingSymbol: leadingSymbol,
      mantissaLength: mantissaLength,
      thousandSeparator: ThousandSeparator.comma,
      trailingSymbol: trailingSymbol,
      useSymbolPadding: useSymbolPadding,
    );

    String newSubstrBeforeSelection = oldSelectionEnd > -1 ? formattedValue.substring(0, value.selection.end) : '';
    int numThousandSeparatorsInNewSub = _countSymbolsInString(newSubstrBeforeSelection, ',');

    int numAddedSeparators = numThousandSeparatorsInNewSub - numThousandSeparatorsInOldSub;

    bool newStartsWithLeading = leadingSymbol.isNotEmpty && formattedValue.startsWith(leadingSymbol);

    bool addedLeading = !oldStartsWithLeading && newStartsWithLeading;

    var selectionIndex = value.selection.end + numAddedSeparators;

    int wholePartSubStart = 0;
    if (addedLeading) {
      wholePartSubStart = leadingSymbol.length;
      selectionIndex += leadingSymbol.length;
    }
    var mantissaIndex = formattedValue.indexOf(mantissaSymbol);
    if (mantissaIndex > wholePartSubStart) {
      var wholePartSubstring = formattedValue.substring(
        wholePartSubStart,
        mantissaIndex,
      );
      if (selectionIndex < mantissaIndex) {
        if (wholePartSubstring == '0' || wholePartSubstring == '${leadingSymbol}0') {
          selectionIndex += 1;
        }
      }
    }

    var selectionEnd = min(
      selectionIndex + 1,
      formattedValue.length,
    );
    return TextEditingValue(
      selection: TextSelection.collapsed(
        offset: selectionEnd,
      ),
      text: _prepareDotsAndCommas(formattedValue),
    );
  }

  void _processCallback(String value) {
    if (onValueChange != null) {
      var numericValue = Utils.toNumericString(value, allowPeriod: true);
      var val = double.tryParse(numericValue) ?? 0.0;
      onValueChange(val);
    }
  }
}

int _countSymbolsInString(String string, String symbolToCount) {
  var counter = 0;
  for (var i = 0; i < string.length; i++) {
    if (string[i] == symbolToCount) {
      counter++;
    }
  }
  return counter;
}

String toCurrencyString(
  String value, {
  int mantissaLength = 2,
  ThousandSeparator thousandSeparator = ThousandSeparator.comma,
  ShorteningPolicy shorteningPolicy = ShorteningPolicy.noShortening,
  String leadingSymbol = '',
  String trailingSymbol = '',
  bool useSymbolPadding = false,
}) {
  assert(value != null);
  assert(leadingSymbol != null);
  assert(trailingSymbol != null);
  assert(useSymbolPadding != null);
  assert(shorteningPolicy != null);
  assert(thousandSeparator != null);
  assert(mantissaLength != null);

  var swapCommasAndPreriods = false;
  String tSeparator;
  switch (thousandSeparator) {
    case ThousandSeparator.comma:
      tSeparator = ',';
      break;
    case ThousandSeparator.period:
      tSeparator = ',';
      swapCommasAndPreriods = true;
      break;
    case ThousandSeparator.none:
      tSeparator = '';
      break;
    case ThousandSeparator.spaceAndPeriodMantissa:
      tSeparator = ' ';
      break;
    case ThousandSeparator.spaceAndCommaMantissa:
      tSeparator = ' ';
      swapCommasAndPreriods = true;
      break;
  }

  value = value.replaceAll(_repeatingDots, '.');
  value = Utils.toNumericString(value, allowPeriod: mantissaLength > 0);
  var isNegative = value.contains('-');

  var parsed = double.tryParse(value) ?? 0.0;
  if (parsed == 0.0) {
    if (isNegative) {
      var containsMinus = parsed.toString().contains('-');
      if (!containsMinus) {
        value = '-${parsed.toStringAsFixed(mantissaLength).replaceFirst('0.', '.')}';
      } else {
        value = '${parsed.toStringAsFixed(mantissaLength)}';
      }
    } else {
      value = parsed.toStringAsFixed(mantissaLength);
    }
  }
  var noShortening = shorteningPolicy == ShorteningPolicy.noShortening;

  var minShorteningLength = 0;
  switch (shorteningPolicy) {
    case ShorteningPolicy.noShortening:
      break;
    case ShorteningPolicy.roundToThousands:
      minShorteningLength = 4;
      value = '${_getRoundedValue(value, 1000)}K';
      break;
    case ShorteningPolicy.roundToMillions:
      minShorteningLength = 7;
      value = '${_getRoundedValue(value, 1000000)}M';
      break;
    case ShorteningPolicy.roundToBillions:
      minShorteningLength = 10;
      value = '${_getRoundedValue(value, 1000000000)}B';
      break;
    case ShorteningPolicy.roundToTrillions:
      minShorteningLength = 13;
      value = '${_getRoundedValue(value, 1000000000000)}T';
      break;
    case ShorteningPolicy.automatic:
      // find out what shortening to use base on the length of the string
      var intValStr = (int.tryParse(value) ?? 0).toString();
      if (intValStr.length < 7) {
        minShorteningLength = 4;
        value = '${_getRoundedValue(value, 1000)}K';
      } else if (intValStr.length < 10) {
        minShorteningLength = 7;
        value = '${_getRoundedValue(value, 1000000)}M';
      } else if (intValStr.length < 13) {
        minShorteningLength = 10;
        value = '${_getRoundedValue(value, 1000000000)}B';
      } else {
        minShorteningLength = 13;
        value = '${_getRoundedValue(value, 1000000000000)}T';
      }
      break;
  }
  var list = <String>[];
  var mantissa = '';
  var split = value.split('');
  var mantissaList = <String>[];
  var mantissaSeparatorIndex = value.indexOf('.');
  if (mantissaSeparatorIndex > -1) {
    var start = mantissaSeparatorIndex + 1;
    var end = start + mantissaLength;
    for (var i = start; i < end; i++) {
      if (i < split.length) {
        mantissaList.add(split[i]);
      } else {
        mantissaList.add('0');
      }
    }
  }

  mantissa = noShortening ? _postProcessMantissa(mantissaList.join(''), mantissaLength) : '';
  var maxIndex = split.length - 1;
  if (mantissaSeparatorIndex > 0 && noShortening) {
    maxIndex = mantissaSeparatorIndex - 1;
  }
  var digitCounter = 0;
  if (maxIndex > -1) {
    for (var i = maxIndex; i >= 0; i--) {
      digitCounter++;
      list.add(split[i]);
      if (noShortening) {
        if (digitCounter % 3 == 0 && i > (isNegative ? 1 : 0)) {
          list.add(tSeparator);
        }
      } else {
        if (value.length >= minShorteningLength) {
          if (!Utils.isDigit(split[i])) {
            digitCounter = 1;
          }
          if (digitCounter % 3 == 1 && digitCounter > 1 && i > (isNegative ? 1 : 0)) {
            list.add(tSeparator);
          }
        }
      }
    }
  } else {
    list.add('0');
  }

  if (leadingSymbol.isNotEmpty) {
    if (useSymbolPadding) {
      list.add('$leadingSymbol ');
    } else {
      list.add(leadingSymbol);
    }
  }
  var reversed = list.reversed.join('');
  String result;

  if (trailingSymbol.isNotEmpty) {
    if (useSymbolPadding) {
      result = '$reversed$mantissa $trailingSymbol';
    } else {
      result = '$reversed$mantissa$trailingSymbol';
    }
  } else {
    result = '$reversed$mantissa';
  }

  if (swapCommasAndPreriods) {
    return _swapCommasAndPeriods(result);
  }
  return result;
}

String _swapCommasAndPeriods(String input) {
  var temp = input;
  if (temp.contains('.,')) {
    temp = temp.replaceAll('.,', ',,');
  }
  temp = temp.replaceAll('.', 'PERIOD').replaceAll(',', 'COMMA');
  temp = temp.replaceAll('PERIOD', ',').replaceAll('COMMA', '.');
  return temp;
}

String _getRoundedValue(String numericString, double roundTo) {
  assert(roundTo != null && roundTo != 0.0);
  assert(numericString != null);
  var numericValue = double.tryParse(numericString) ?? 0.0;
  var result = numericValue / roundTo;

  var remainder = result.remainder(1.0);
  String prepared;
  if (remainder != 0.0) {
    prepared = result.toStringAsFixed(2);
    if (prepared[prepared.length - 1] == '0') {
      prepared = prepared.substring(0, prepared.length - 1);
    }
    return prepared;
  }
  return result.toInt().toString();
}

String _postProcessMantissa(String mantissaValue, int mantissaLength) {
  if (mantissaLength < 1) {
    return '';
  }
  if (mantissaValue.isNotEmpty) {
    return '.$mantissaValue';
  }
  return '.${List.filled(mantissaLength, '0').join('')}';
}

enum ShorteningPolicy {
  noShortening,
  roundToThousands,
  roundToMillions,
  roundToBillions,
  roundToTrillions,
  automatic
}

enum ThousandSeparator {
  comma,
  period,
  none,
  spaceAndPeriodMantissa,
  spaceAndCommaMantissa,
}
