import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'Helper.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}
String nonCapitalizeString(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input.toLowerCase();
}

String convertDateFormat(String input) {
  if (input.isEmpty) {
    return input;
  }

  DateTime parsedDate = DateTime.parse(input);
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

  return formattedDate;
}

String addCurrencySymbol(String? currencySymbol, String input) {
  if (input.isEmpty) {
    return input;
  }
  String amount ="";
  currencySymbol != null ? amount = "${currencySymbol} ${input}" : "${input}";

  return amount;
}


void hideKeyBoard(){
  FocusManager.instance.primaryFocus?.unfocus();
}
