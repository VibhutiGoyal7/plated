import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

String addCurrencySymbol(String? currencySymbol, String input) {
  if (input.isEmpty) {
    return input;
  }
  String amount = "";
  currencySymbol != null ? amount = "${currencySymbol}${input}" : "${input}";

  return amount;
}

String addCurrencySymbolTransaction(
    String? currencySymbol, String input, String requestType) {
  if (input.isEmpty) {
    return input;
  }
  String amount = "";
  currencySymbol != null ? amount = "${currencySymbol}${input}" : "${input}";
  if (requestType == "Deposit") {
    amount = "+$amount";
  } else if (requestType == "Withdraw") {
    amount = "-$amount";
  } else if (requestType == "Transfer") {
    amount = "-$amount";
  }
  return amount;
}


colorStatus(String status) {
  Color color = Colors.black;
  if (status == "Pending") {
    color = Colors.orange;
  } else if (status == "Success") {
    color = Colors.green;
  } else if (status == "Rejected") {
    color = Colors.red;
  }
  return color;
}
colorPaymentType(String status) {
  Color color = Colors.black;
  if (status == "Deposit") {
    color = Colors.green;
  } else if (status == "Withdraw") {
    color = Colors.red;
  } else if (status == "Transfer") {
    color = Colors.red;
  }
  return color;
}

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
