import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat.currency(
  name: 'INR',
  locale: 'en_IN',
  symbol: '₹ ',
  decimalDigits: 1,
);

final converter = AmountToWords();

extension RupeesFormatterInt on int {
  String inRupeesFormat() {
    return currencyFormat.format(this);
  }

  String inWords() {
    return converter.convertAmountToWords(toDouble());
  }
}

extension RupeesFormatterDouble on double {
  String inRupeesFormat() {
    return currencyFormat.format(this);
  }

  String inWords() {
    return converter.convertAmountToWords(this);
  }
}

double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else {
    return value.toDouble();
  }
}
