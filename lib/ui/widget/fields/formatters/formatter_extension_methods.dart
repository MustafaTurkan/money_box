import 'money_input_formatter.dart' as money;
import 'money_input_formatter.dart';

extension NumericInputFormatting on num {
  String toCurrencyString(
      {int mantissaLength = 2,
      ThousandSeparator thousandSeparator = ThousandSeparator.comma,
      ShorteningPolicy shorteningPolicy = ShorteningPolicy.noShortening,
      String leadingSymbol = '',
      String trailingSymbol = '',
      bool useSymbolPadding = false}) {
    return money.toCurrencyString(toString(),
        mantissaLength: mantissaLength,
        leadingSymbol: leadingSymbol,
        shorteningPolicy: shorteningPolicy,
        thousandSeparator: thousandSeparator,
        trailingSymbol: trailingSymbol,
        useSymbolPadding: useSymbolPadding);
  }
}

extension StringInputFormatting on String {
  String toCurrencyString(
      {int mantissaLength = 2,
      ThousandSeparator thousandSeparator = ThousandSeparator.comma,
      ShorteningPolicy shorteningPolicy = ShorteningPolicy.noShortening,
      String leadingSymbol = '',
      String trailingSymbol = '',
      bool useSymbolPadding = false}) {
    return money.toCurrencyString(toString(),
        mantissaLength: mantissaLength,
        leadingSymbol: leadingSymbol,
        shorteningPolicy: shorteningPolicy,
        thousandSeparator: thousandSeparator,
        trailingSymbol: trailingSymbol,
        useSymbolPadding: useSymbolPadding);
  }

  double amountValue() {
    return double.parse(replaceAll(RegExp(','), ''));
  }
}
