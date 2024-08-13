import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/api_response.dart';
import '../../../../model/request/completeP2PRequest.dart';
import '../../../../model/response/initiateP2PResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/toastMessage.dart';

class TransferOverviewScreen extends StatefulWidget {
  final InitiateP2PRequest? data;

  TransferOverviewScreen({required this.data});

  @override
  _TransferOverviewScreenState createState() => _TransferOverviewScreenState();
}

class _TransferOverviewScreenState extends State<TransferOverviewScreen> {
  bool inputValid = true;
  bool isTPINSelected = true;
  String amount = "0.00";
  String paymentValidateBy = "tpin";
  var receiverUsername;
  var senderUsername;
  bool isDarkMode = false;
  var name;
  var receiverPhoneNumber;
  var imageUrl;
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
    receiverUsername = widget.data?.receiverUsername;
    name = "${widget.data?.fullName}";
    receiverPhoneNumber = "${widget.data?.receiverPhoneNumber}";
    amount = "${widget.data?.amount}";
    Helper.getProfileDetails().then((profile) {
      senderUsername = profile?.username;
    });
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
            "${Languages.of(context)?.labelTransferScreen}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.grey),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.free_cancellation_sharp,
                            size: 28,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            color: Colors.grey,
                            width: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Languages.of(context)!
                                    .labelMoneyTransferOverview,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text("${Languages.of(context)?.labelAccountTransfer}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.1, color: Colors.grey)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Languages.of(context)?.labelTransferFrom}",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${senderUsername}",
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.account_balance,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.grey),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${Languages.of(context)?.labelTotalAmount}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "$countryCurrencySymbol${amount}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            height: 40,
                            color: Colors.grey,
                            width: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Languages.of(context)?.labelTransferTo}",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                receiverUsername,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${Languages.of(context)?.labelNotes}",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    controller: _notesController,
                                    onChanged: (value) {},
                                    enabled: true,
                                    maxLength: 100,
                                    maxLines: 2,
                                    keyboardType: TextInputType.text,
                                    onSubmitted: (value) {},
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      //counterText: "",
                                      counterStyle: TextStyle(fontSize: 11),
                                      border: InputBorder.none,
                                      hintText: '${Languages.of(context)?.labelWriteSomething}',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.edit,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isTPINSelected = true;
                            paymentValidateBy = "tpin";
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: isTPINSelected ? 0.5 : 0.3,
                                  color: isTPINSelected
                                      ? Colors.green
                                      : Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Icon(
                                Icons.pin,
                                size: 34,
                                color:
                                    isTPINSelected ? Colors.green : Colors.grey,
                              ),
                              Text(
                                "${Languages.of(context)?.labelTPIN}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isTPINSelected = false;
                            paymentValidateBy = "email_otp";
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.only(top: 15, left: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: isTPINSelected ? 0.3 : 0.5,
                                  color: isTPINSelected
                                      ? Colors.grey
                                      : Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Icon(
                                Icons.phone_android,
                                size: 34,
                                color:
                                    isTPINSelected ? Colors.grey : Colors.green,
                              ),
                              Text(
                                "Mobile Otp",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  _buildFooter(context),
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
                InitiateP2PRequest request = InitiateP2PRequest(
                  paymentValidateBy: paymentValidateBy,
                  tpin: "",
                  amount: amount,
                  receiverUsername: receiverUsername,
                  receiverPhoneNumber: receiverPhoneNumber,
                  fullName: widget.data?.fullName,
                  imageUrl: widget.data?.imageUrl,
                  notes: _notesController.text,
                );
                if (isTPINSelected) {
                  print(
                      "request ${request.receiverPhoneNumber} ${request.receiverUsername}");
                  Navigator.pushNamed(context, '/TransferTPINScreen',
                      arguments: request);
                } else {
                  _initiateTransaction();
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(color: AppColor.WHITE),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: AppColor.PRIMARY,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initiateTransaction() async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      InitiateP2PRequest request = InitiateP2PRequest(
        paymentValidateBy: paymentValidateBy,
        notes: _notesController.text,
        fullName: name,
        imageUrl: imageUrl,
        tpin: "",
        amount: amount,
        receiverUsername: receiverUsername,
        receiverPhoneNumber: receiverPhoneNumber,
      );
      print("phno ${request.receiverPhoneNumber}");
      print("username ${request.receiverUsername}");
      await Provider.of<MainViewModel>(context, listen: false)
          .initiateP2PTransaction(
              "api/v1/app/transfer_transactions/initiate_p2p_transaction",
              request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      initiateTransactionResponse(context, apiResponse);
    }
  }

  Future<Widget> initiateTransactionResponse(
      BuildContext context, ApiResponse apiResponse) async {
    InitiateP2PResponse? initiateP2PResponse =
        apiResponse.data as InitiateP2PResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("TPIN ${initiateP2PResponse?.otp}");
        if (initiateP2PResponse?.otp == null) {
          ToastComponent.showToast(context: context, message: message);
        }
        CompleteP2PRequest data = CompleteP2PRequest(
            otp: initiateP2PResponse?.otp,
            uniqueId: initiateP2PResponse?.uniqueId,
            imageUrl: imageUrl,
            fullName: name,
            amount: amount,
            paymentTransactionId: "",
            receiverPhoneNumber: receiverPhoneNumber,
            receiverUsername: receiverUsername
            //imageUrl: ""
            );
        Navigator.pushNamed(context, '/TransferOtpScreen', arguments: data);
        // Navigate to the new screen after receiving the response
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        ToastComponent.showToast(context: context, message: message);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
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
