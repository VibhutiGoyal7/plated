import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../utils/Helper.dart';
import '../../../model/response/transactionListReponse.dart';
import '../../component/connectivity_service.dart';

class TransactionOverviewScreen extends StatefulWidget {
  final TransactionDetails? data;

  TransactionOverviewScreen({required this.data});

  @override
  _TransactionOverviewScreenState createState() =>
      _TransactionOverviewScreenState();
}

class _TransactionOverviewScreenState extends State<TransactionOverviewScreen> {
  bool inputValid = true;
  bool isTPINSelected = true;
  String amount = "0.00";
  String paymentValidateBy = "tpin";
  bool isDarkMode = false;
  var name;
  var countryCurrencySymbol;
  var country;
  String countryBalance = "";
  final TextEditingController _notesController = TextEditingController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    inputValid = false;
    Helper.getProfileDetails().then((profile) {});
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
    TransactionDetails? transactionDetails = widget.data;
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
            "Transaction Overview",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  IntrinsicHeight(
                    child: Container(
                      width: screenWidth,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.2, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(
                                    transactionDetails?.transactionType ==
                                                "${Languages.of(context)?.statusWithdraw}" ||
                                            transactionDetails
                                                    ?.transactionType ==
                                                "${Languages.of(context)?.statusTransfer}"
                                        ? Icons.call_made
                                        : Icons.call_received,
                                    size: 20,
                                    color: colorStatus(
                                        capitalizeFirstLetter(
                                            "${transactionDetails?.status}"),
                                        context)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${capitalizeFirstLetter("${transactionDetails?.transactionType}")}",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                addCurrencySymbolTransaction(
                                    countryCurrencySymbol,
                                    "${transactionDetails?.amount}",
                                    capitalizeFirstLetter("${transactionDetails?.transactionType}")),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: transactionDetails?.status == "in_complete"? Colors.grey : colorPaymentType(capitalizeFirstLetter(
                                        "${transactionDetails?.transactionType}")))
                              ),
                              Text(
                                  "${convertDateTimeFormat("${transactionDetails?.createdAt}")}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        "${transactionDetails?.customerId}" != "null"
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Customer Id",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "${transactionDetails?.customerId}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    width: screenWidth * 0.85,
                                    height: 0.3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        "${transactionDetails?.username}" != "null"
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "User name",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "${transactionDetails?.username}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    width: screenWidth * 0.85,
                                    height: 0.3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            : SizedBox(),

                        "${transactionDetails?.phoneNumber}" != "null" ?
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "${transactionDetails?.phoneNumber}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  width: screenWidth * 0.85,
                                  height: 0.3,
                                  color: Colors.grey,
                                ),
                              ],
                            )
                            :SizedBox(),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "${transactionDetails?.email}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: screenWidth * 0.85,
                          height: 0.3,
                          color: Colors.grey,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment method",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "${capitalizeFirstLetter("${transactionDetails?.status}")}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorStatus(
                                      capitalizeFirstLetter(
                                          "${transactionDetails?.status}"),
                                      context)),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: screenWidth * 0.85,
                          height: 0.3,
                          color: Colors.grey,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment ID",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "${transactionDetails?.id}",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
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
