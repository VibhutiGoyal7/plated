import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../theme/AppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../component/connectivity_service.dart';

class TransferScreen extends StatefulWidget {
  final CheckCustomerResponse? data;

  TransferScreen({required this.data});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool inputValid = true;
  bool isComingSoon = true;
  String amount = "0.00";
  var userName;
  bool isDarkMode = false;
  var name;
  var phoneNo;
  var imageUrl;
  var countryCurrencySymbol;
  var country;
  String countryBalance = "";
  final TextEditingController _inputController = TextEditingController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    inputValid = false;
    userName = widget.data?.username;
    name = "${widget.data?.fullName}";
    phoneNo = "${widget.data?.phoneNumber}";
    imageUrl = "${widget.data?.imageUrl}";
    print("object ${userName}");
    Helper.getUserBalance().then((balance) {
      setState(() {
        countryBalance = balance!;
      });
    });
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
    Helper.getCountry().then((countryName) {
      setState(() {
        country = countryName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 65,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ),
          title: Text(
            Languages.of(context)!.labelMoneyTransfer,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: isComingSoon
                  ? Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          imageUrl == null
                              ? Container(
                                  height: 55,
                                  width: 55,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColor.WHITE,
                                    backgroundImage:
                                        AssetImage("assets/profile_user.png"),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    imageUrl,
                                    height: 55,
                                    width: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      // You can return any widget here to display in case of an error
                                      return Container(
                                        height: 55,
                                        width: 55,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: AppColor.WHITE,
                                          backgroundImage: AssetImage(
                                            "assets/profile_user.png",
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.white38,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            height: 55,
                                            width: 55,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                    },
                                  )),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "${Languages.of(context)!.labelPaying} ${name}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${userName}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          /* Text("${phoneNo}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: isDarkMode ? Colors.white70 : Colors.black54)),*/
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            Languages.of(context)!.labelPleaseEnterAmt,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*Text("${countryCurrencySymbol}", style: TextStyle(fontSize: 38, fontWeight: FontWeight.normal,
                                  color: Colors.grey),),*/
                              Card(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  //margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border(
                                        right: BorderSide(width: 0.2),
                                        top: BorderSide(width: 0.250),
                                        bottom: BorderSide(width: 0.2),
                                        left: BorderSide(width: 0.2),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                      controller: _inputController,
                                      autofocus: true,
                                      onChanged: (value) {
                                        /*    int balance = extractNumber(countryBalance) - extractNumber(amount);
                                        print(balance);*/
                                        setState(() {
                                          amount = value;
                                          // countryBalance = balance as String ;
                                        });
                                        _checkInputValidation();
                                      },
                                      maxLength: 6,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onSubmitted: (value) {
                                        setState(() {
                                          amount = value;
                                          // countryBalance = balance as String ;
                                        });
                                        _checkInputValidation();
                                      },
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText:
                                            Languages.of(context)?.labelZero,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*Text(
                          Languages.of(context)!.labelINR,
                          style:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                        ),*/
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          countryCurrencySymbol != null
                              ? Text(
                                  "${Languages.of(context)!.labelBalance}: ${currencyFormat(countryCurrencySymbol, countryBalance, country)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0),
                                )
                              : Text(""),
                          SizedBox(
                            height: 20,
                          ),
                          Spacer(),
                          _buildFooter(context),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        Languages.of(context)!.labelComingSoon,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
            isLoading
                ? Stack(
                    children: [
                      // Block interaction
                      ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.3)),
                      // Loader indicator
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                hideKeyBoard();
                _checkInputValidation();
                if (inputValid) {
                  InitiateP2PRequest request = InitiateP2PRequest(
                      paymentValidateBy: "",
                      tpin: "",
                      amount: amount,
                      receiverUsername: userName,
                      receiverPhoneNumber: phoneNo,
                      fullName: widget.data?.fullName,
                      imageUrl: widget.data?.imageUrl,
                      notes: "");

                  print(
                      "request ${request.receiverPhoneNumber} ${request.receiverUsername}");
                  Navigator.pushNamed(context, '/TransferOverviewScreen',
                      arguments: request);
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  void _checkInputValidation() {
    if (_inputController.text.length >= 1 &&
        amount.isNotEmpty &&
        isBalanceMoreThanAmount(countryBalance, amount, context)) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
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

  bool isNumeric(String s) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(s);
  }
}
