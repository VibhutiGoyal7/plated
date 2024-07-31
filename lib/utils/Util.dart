import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../view/component/toastMessage.dart';

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

  if (input == "**") {
    print("object");
    return "${currencySymbol}${input}";
  }
  String amount = "";
   try{
     currencySymbol != null ? amount = "${currencySymbol}${double.parse("${input}").toStringAsFixed(2)}" : "${double.parse("${input}").toStringAsFixed(2)}";

   }catch(e)
  {
    return "${currencySymbol}${input}";
  }
  print("${input == "**"}");
  print("${input}");

  return amount;
}

bool isBalanceMoreThanAmount(String balance, String amt, BuildContext context){
  double intBalance =  extractFloat(balance);
  double inrAmt =  amt != null|| amt!="" ?extractFloat(amt) : 0;
  if(intBalance<=inrAmt){
    ToastComponent.showToast(context: context, message: 'You do not have enough balance.');
    return false;
  }else{
    return true;
  }

}
double extractFloat(String str) {
  // Regular expression to match floating-point numbers, including those with decimals and negative sign
  final regex = RegExp(r'-?\d+(\.\d+)?');
  final match = regex.firstMatch(str);
  if (match != null) {
    return double.parse(match.group(0)!);
  } else {
    throw FormatException('No floating-point number found in the string');
  }
}

String addCurrencySymbolTransaction(
    String? currencySymbol, String input, String requestType) {
  if (input.isEmpty) {
    return input;
  }
  String amount = "";
  currencySymbol != null ? amount = "${currencySymbol}${double.parse("${input}").toStringAsFixed(2)}" :  "${double.parse("${input}").toStringAsFixed(2)}";
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
