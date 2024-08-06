import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../languageSection/Languages.dart';
import '../model/request/shortcutItemList.dart';
import '../view/component/toastMessage.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  if (input.contains("_")) {
    var replacedInput = input.replaceAll("_", " ");
    input = replacedInput;
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
String convertDateTimeFormat(String input) {
  if (input.isEmpty) {
    return input;
  }

  DateTime parsedDate = DateTime.parse(input);
  String formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(parsedDate);

  return formattedDate;
}

String convertTime(String input) {
  if (input.isEmpty) {
    return input;
  }

  DateTime date = DateTime.parse(input); // Example date and time
  String formattedTime =
      DateFormat('hh:mm a').format(date); // This will output "02:30 PM"
  return formattedTime;
}

String currencyFormat(String symbol, String input, String country) {
  if (input.isEmpty) {
    return input;
  }
  double value = 0;
  print(country);

  var locale;

  if (country == "India") {
    locale = 'en_IN';
  } else if (country == "Bangladesh") {
    locale = 'bn_BD';
  } else if (country == "Saudi Arabi") {
    locale = 'ar_SA';
  }
  final formatter;
  try {
    value = double.parse(input);
  } catch (e) {
    return "${symbol}${input}";
  }
  if (country == "") {
    formatter = NumberFormat.currency(
      symbol: "${symbol}",
      decimalDigits: 2,
    );
  } else {
    formatter = NumberFormat.currency(
      locale: locale,
      symbol: "${symbol}",
      decimalDigits: 2,
    );
  }
  return "${formatter.format(value)}";
}

String convertDateMonthFormat(String input) {
  if (input.isEmpty) {
    return input;
  }
  DateTime date = DateTime.parse(input);
  String day = DateFormat('d').format(date);
  String month = DateFormat('MMM').format(date);
  return '$day\n$month';
  // return formattedDate;
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
  try {
    currencySymbol != null
        ? amount =
            "${currencySymbol}${double.parse("${input}").toStringAsFixed(2)}"
        : "${double.parse("${input}").toStringAsFixed(2)}";
  } catch (e) {
    return "${currencySymbol}${input}";
  }
  print("${input == "**"}");
  print("${input}");

  return amount;
}

bool isBalanceMoreThanAmount(String balance, String amt, BuildContext context) {
  double intBalance = extractFloat(balance);
  double inrAmt = amt != null || amt != "" ? extractFloat(amt) : 0;
  if (intBalance <= inrAmt) {
    ToastComponent.showToast(
        context: context, message: 'You do not have enough balance.');
    return false;
  } else {
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
  currencySymbol != null
      ? amount =
          "${currencySymbol}${double.parse("${input}").toStringAsFixed(2)}"
      : "${double.parse("${input}").toStringAsFixed(2)}";
  if (requestType == "Deposit") {
    amount = "+$amount";
  } else if (requestType == "Withdraw") {
    amount = "-$amount";
  } else if (requestType == "Transfer") {
    amount = "-$amount";
  } else if (requestType == "In complete") {
    amount = "-$amount";
  }
  return amount;
}

colorStatus(String status, BuildContext context) {
  Color color = Colors.black;
  if (status == Languages.of(context)!.labelPending) {
    color = Colors.orange;
  } else if (status == Languages.of(context)!.labelSuccess) {
    color = Colors.green;
  } else if (status == Languages.of(context)!.labelRejected) {
    color = Colors.red;
  } else if (status == Languages.of(context)!.labelInComplete) {
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
  } else if (status == "In complete") {
    color = Colors.grey;
  }
  return color;
}

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

getShortCutList(BuildContext context) {
  List<Shortcutitemlist> _shortcutCardsList = [
    Shortcutitemlist(
        title: Languages.of(context)!.labelAddMoney,
        icon: Icons.add_rounded,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelWithdraw,
        icon: Icons.call_made,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelRequestQR,
        icon: Icons.send,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelExchange,
        icon: Icons.currency_exchange,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelRewards,
        icon: Icons.gif_box,
        selected: false)
  ];

  return _shortcutCardsList;
}

/*

void _fetchKycStatus() async {
  setState(() {
    isApiLoading = true;
  });

  bool isConnected = await _connectivityService.isConnected();
  if (!isConnected) {
    setState(() {
      isApiLoading = false;
      isInternetConnected = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Languages.of(context)!.labelNoInternetConnection),
          duration: maxDuration,
        ),
      );
    });
  } else {
    //await Future.delayed(Duration(milliseconds: 1));
    await Provider.of<MainViewModel>(context, listen: false)
        .kycStatusData("/api/v1/app/customers/check_customer_kyc_status");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getKycStatus(context, apiResponse);
  }
}*/
