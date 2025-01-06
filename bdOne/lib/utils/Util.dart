import 'dart:io';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../languageSection/Languages.dart';
import '../model/request/shortcutItemList.dart';
import '../model/response/offersResponse.dart';
import '../theme/AppColor.dart';
import '../view/component/toastMessage.dart';
import '../view/screens/authSection/signin_screen.dart';

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
  String localTime = convertUtcDateToLocal(input);

  DateTime parsedDate = DateTime.parse(localTime);
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

  return formattedDate;
}

String convertUtcDateToLocal(String utcTime) {
  if (utcTime.isEmpty) {
    return utcTime;
  }
  DateTime utcDateTime = DateTime.parse(utcTime);

  // Convert the DateTime object to local time
  DateTime localDateTime = utcDateTime.toLocal();

  // Print the local time
  // print('Local Time: ${localDateTime.toString()}');

  return "${localDateTime.toString()}";
}

String convertDateTimeFormat(String input) {
  if (input.isEmpty) {
    return input;
  }
  String localTime = convertUtcDateToLocal(input);

  DateTime parsedDate = DateTime.parse(localTime);
  String formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(parsedDate);

  return formattedDate;
}

String convertTime(String input) {
  if (input.isEmpty) {
    return input;
  }
  String localTime = convertUtcDateToLocal(input);
  DateTime date = DateTime.parse(localTime); // Example date and time
  String formattedTime =
  DateFormat('hh:mm a').format(date); // This will output "02:30 PM"
  return formattedTime;
}

String currencyFormat(String symbol, String input, String country) {
  if (input.isEmpty) {
    return input;
  }
  double value = 0;
  //print(country);

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
      /*locale: locale,*/
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
  }else if(currencySymbol == null || currencySymbol == "null"){
    return input;
  }

  if (input == "*****") {
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
  print("${input == "*****"}");
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

bool checkMoneyOut(String transactionType, int? senderId, int? userId){
  if(nonCapitalizeString(transactionType) == nonCapitalizeString("transfer")){
    if(userId== senderId){
      return true;}
    else{
      return false;}
  }else if(nonCapitalizeString(transactionType) == nonCapitalizeString("withdraw")){
    return true;
  }else if(nonCapitalizeString(transactionType) == nonCapitalizeString("deposit")){
    return false;
  } else if(nonCapitalizeString(transactionType) == nonCapitalizeString("payin")){
    return false;
  }else {
    return true;
  }

}

String addCurrencySymbolTransaction(
    String? currencySymbol, String input, String requestType, int? userId, int? senderId) {
  if (input.isEmpty) {
    return input;
  }
  String amount = "";
  currencySymbol != null
      ? amount =
  "${currencySymbol}${double.parse("${input}").toStringAsFixed(2)}"
      : "${double.parse("${input}").toStringAsFixed(2)}";
  if (checkMoneyOut(requestType, senderId, userId)) {
    amount = "-$amount";
  } else/* if (requestType == "Withdraw")*/ {
    amount = "+$amount";
  } /*else if (requestType == "Transfer") {
    amount = "-$amount";
  } else if (requestType == "In complete") {
    amount = "-$amount";
  }*/
  return amount;
}

colorStatus(String status, BuildContext context) {
  Color color = Colors.black;
  if (status == Languages.of(context)!.labelPending) {
    color = AppColor.TEXT_YELLOW;
  } else if (status == Languages.of(context)!.labelSuccess) {
    color = AppColor.TEXT_GREEN;
  } else if (status == Languages.of(context)!.labelRejected) {
    color = AppColor.TEXT_RED;
  } else if (status == Languages.of(context)!.labelInComplete) {
    color = AppColor.TEXT_RED;
  }
  return color;
}

colorPaymentType(String status, int? userId, int? senderId) {
  Color color = Colors.black;
  if (checkMoneyOut(status, senderId, userId)) {
    color = AppColor.TEXT_RED;
  } else /*if (status == "Withdraw")*/ {
    color = AppColor.TEXT_GREEN;
  } /*else if (status == "Transfer") {
    color = Colors.red;
  } else if (status == "In complete") {
    color = Colors.grey;
  }*/
  return color;
}

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool isKeyboardOpen(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}

getShortCutList(BuildContext context) {
  List<Shortcutitemlist> _shortcutCardsList = [
    Shortcutitemlist(
        title: Languages.of(context)!.labelAddMoney,
        icon: Icons.add_rounded,
        selected: true),
    Shortcutitemlist(
        title: "Withdraw Money",
        icon: Icons.arrow_upward_sharp,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelRequestQR,
        icon: Icons.qr_code_2_sharp,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelExchange,
        icon: Icons.currency_exchange,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelTransfer,
        icon: Icons.transfer_within_a_station,
        selected: true),
    Shortcutitemlist(
        title: Languages.of(context)!.labelRewards,
        icon: Icons.gif_box,
        selected: false)
  ];

  return _shortcutCardsList;
}

getOfferList(BuildContext context) {
  final List<OfferResponse> imgList = [
    OfferResponse(
        image:
        "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
        "https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
        "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
        "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
        "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
  ];

  return imgList;
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

Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // This is the unique ID on Android devices
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor; // This is the unique ID on iOS devices
  }
  return null;
}

void copyTextToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
  // Optionally show a message to the user
  print("Text copied to clipboard: $text");
}

bool getIsTablet(BuildContext context, double screenWidth, double screenHeight)
{
  // Calculate diagonal screen size in inches
  // Get the screen width in logical pixels
  double screenWidth = MediaQuery.of(context).size.width;

  // Check if the device is in portrait mode
  bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  // Consider a typical tablet width range (e.g., between 600 and 900 logical pixels)

  //print("IsTablet ${isPortrait && screenWidth >= 600 && screenWidth <= 900}");
  return isPortrait && screenWidth >= 520 && screenWidth <= 900;


}

Future<void> showExitDialog(BuildContext context, double screenWidth, double screenHeight, BDOneDatabase database) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: Border.all(),
        title: Center(
            child: Text(
              "${Languages.of(context)?.labelExit}",
              style: TextStyle(fontSize: 20),
            )),
        content: Container(
          height: screenHeight * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor),
                      child: Icon(
                        Icons.logout_outlined,
                        size: 55,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                        Languages.of(context)!.labelPressBackToExit,
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: screenWidth * 0.6,
                    child: TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.6,
                    child: TextButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        /* Navigator.of(context).pop();
                          await Future.delayed(Duration(milliseconds: 6));
                          SystemNavigator.pop();*/
                        Helper.clearAllSharedPreferences();
                        database.personDao.clearAllCustomerDetails();
                        database.dashboardTransactionDao
                            .clearAllTransactions();
                        //database.recentCustomerDao.clearAllRecentCustomers();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => SigninScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      );
    },
  );
}

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}
