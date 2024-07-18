import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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


void hideKeyBoard(){
  FocusManager.instance.primaryFocus?.unfocus();
}
