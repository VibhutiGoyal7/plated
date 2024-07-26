import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../view/component/toastMessage.dart';
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

bool isBalanceMoreThanAmount(String balance, String amt, BuildContext context){
  int intBalance =  extractNumber(balance);
  int inrAmt =  amt != null|| amt!="" ?extractNumber(amt) : 0;
  if(intBalance<=inrAmt){
    ToastComponent.showToast(context: context, message: 'You do not have enough balance.');
    return false;
  }else{
    return true;
  }

}

int extractNumber(String str) {
  final regex = RegExp(r'\d+');
  final match = regex.firstMatch(str);
  if (match != null) {
    return int.parse(match.group(0)!);
  } else {
    throw FormatException('No number found in the string');
  }
}


void hideKeyBoard(){
  FocusManager.instance.primaryFocus?.unfocus();
}
