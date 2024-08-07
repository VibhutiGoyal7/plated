import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/request/initiateP2PRequest.dart';
import '../../../../model/response/checkCustomerReponse.dart';
import '../../../../model/response/completeP2PResponse.dart';
import '../../../../model/response/initiateP2PResponse.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/customNumberKeyboard.dart';
import '../../../component/session_expired_dialog.dart';
import '../../../component/toastMessage.dart';

class TransferTpinScreen extends StatefulWidget {
  final InitiateP2PRequest? data; // Define the 'data' parameter here

  TransferTpinScreen({Key? key, this.data}) : super(key: key);

  @override
  _TransferTpinScreenState createState() => _TransferTpinScreenState();
}

class _TransferTpinScreenState extends State<TransferTpinScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  String amount = "0.00";
  String paymentValidateBy = "";
  String notes = "";
  String imageUrl = "";
  var receiverUsername;
  var senderUsername;
  var name;
  var receiverPhoneNumber;
  var uniqueID;
  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
  String? currencySymbol = "";
  String? country = "";
  List<String> _inputValues = ['', '', '', ''];
  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  void _handleKeyTap(String value) {
    setState(() {
      for (int i = 0; i < _inputValues.length; i++) {
        if (_inputValues[i].isEmpty) {
          _inputValues[i] = value;
          break;
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      for (int i = _inputValues.length - 1; i >= 0; i--) {
        if (_inputValues[i].isNotEmpty) {
          _inputValues[i] = '';
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isValid = false;
    resendOtp = false;
    receiverUsername = "${widget.data?.receiverUsername}";
    paymentValidateBy = "${widget.data?.paymentValidateBy}";
    name = "${widget.data?.fullName}";
    receiverPhoneNumber = "${widget.data?.receiverPhoneNumber}";
    notes = "${widget.data?.notes}";
    amount = "${widget.data?.amount}";
    imageUrl = "${widget.data?.imageUrl}";
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        currencySymbol = symbol;
      });
    });

    Helper.getCountry().then((countryName) {
      setState(() {
        country = countryName;
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<Widget> initiateTransactionResponse(BuildContext context,
      ApiResponse apiResponse) async {
    var message = apiResponse?.message.toString();
    InitiateP2PResponse? initiateP2PResponse = apiResponse
        .data as InitiateP2PResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        CheckCustomerResponse prefData = CheckCustomerResponse(
            username: widget.data?.receiverUsername,
            fullName: widget.data?.fullName,
            phoneNumber: widget.data?.receiverPhoneNumber,
            imageUrl: widget.data?.imageUrl);
        print("PrefData ${prefData.username}");

        List<CheckCustomerResponse>? prefResponse = await Helper
            .getRecentP2PDetails();
        bool dataExist = false;
        if (prefResponse?.length != null) {
          for (int i = 0; i < prefResponse!.length; i++) {
            if (prefData.username == prefResponse[i].username) {
              dataExist = true;
            }
          }
        } else {
          dataExist = false;
        }
        if (!dataExist) {
          if (prefResponse != null) {
            prefResponse.add(prefData);
            print("prefResponse ${prefResponse[0].username}");
            Helper.saveRecentP2PDetails(prefResponse);
          } else {
            List<CheckCustomerResponse>? dataList = [];
            Helper.saveRecentP2PDetails(dataList);
          }
        }
        InitiateP2PResponse response = InitiateP2PResponse(
            fullName: name,
            amount: initiateP2PResponse?.amount,
            receiverPhoneNumber: initiateP2PResponse?.receiverPhoneNumber,
            uniqueId: initiateP2PResponse?.uniqueId,
            otp: initiateP2PResponse?.otp,
            notes: initiateP2PResponse?.notes,
            createdAt: initiateP2PResponse?.createdAt,
            customerId: initiateP2PResponse?.customerId,
            dataStatus: initiateP2PResponse?.dataStatus,
            id: initiateP2PResponse?.id,
            message: initiateP2PResponse?.message,
            receiverId: initiateP2PResponse?.receiverId,
            receiverUserName: receiverUsername,
            senderId: initiateP2PResponse?.senderId,
            status: initiateP2PResponse?.status,
            transactionMethod: initiateP2PResponse?.transactionMethod,
            transactionProvider: initiateP2PResponse?.transactionMethod,
            transactionType: initiateP2PResponse?.transactionType,
            trxDetails: initiateP2PResponse?.trxDetails,
            updatedAt: initiateP2PResponse?.updatedAt,
            imageUrl: imageUrl);

        Navigator.pushReplacementNamed(context, '/PaymentSuccessfulScreen',
            arguments: response);
        //Navigator.pushNamed(context, '/BottomNav');
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    ApiResponse apiResponse = Provider
        .of<MainViewModel>(context)
        .response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*appBar: AppBar(toolbarHeight: 65,leading:

       ),*/
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.95,
                  //height: screenHeight * 0.15,
                  margin: EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
                  child: /*_buildLabelText(context, "Transaction \nPIN ", 28, true),*/
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 2),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${Languages
                                  .of(context)
                                  ?.labelPayingTo}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(),
                            Text("${widget.data?.fullName}",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${Languages
                              .of(context)
                              ?.labelPhoneNo}"),
                          SizedBox(
                            width: 10,
                          ),
                          //Text("${widget.data?.fullName}"),

                          widget.data?.receiverPhoneNumber != null
                              ? Text("${widget.data?.receiverPhoneNumber}")
                              : Text("${widget.data?.receiverUsername}"),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${Languages
                              .of(context)
                              ?.labelSending}"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(currencyFormat(
                              "${currencySymbol}", "${widget.data?.amount}",
                              "${country}")),
                        ],
                      ),
                    ],
                  ),
                  alignment: AlignmentDirectional.center,
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.72,
                    margin: EdgeInsets.zero,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: _buildLabelText(
                                context, "${Languages
                                .of(context)
                                ?.labelEnter4DigitPin}", 20, true),
                          ),
                          SizedBox(height: 22),
                          _buildPhoneInput(context, screenWidth, isDarkMode),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.yellow.shade700,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              width: screenWidth * 0.65,
                              child: Text(
                                "${Languages
                                    .of(context)
                                    ?.labelYouAreTransferringMoneyTo}${widget
                                    .data?.receiverUsername}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                          Spacer(),
                          CustomNumberKeyboard(onKeyTap: (value) async {
                            if (value == "clear") {
                              _handleBackspace();
                            } else if (value == "submit") {
                              String tpin = _inputValues
                                  .map((controller) => controller)
                                  .join();
                              if (tpin.isNotEmpty && tpin.length == 4) {
                                _initiateTransaction(tpin);
                              }
                            } else {
                              _handleKeyTap(value);
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Stack(
            children: [
              // Block interaction
              ModalBarrier(
                  dismissible: false,
                  color: Colors.transparent),
              // Loader indicator
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
              : SizedBox(),
        ],
      ),
    );
  }


  Future<void> _initiateTransaction(String tpin) async {
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
        notes: notes,
        fullName: name,
        imageUrl: imageUrl,
        tpin: tpin,
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
          Provider
              .of<MainViewModel>(context, listen: false)
              .response;
      initiateTransactionResponse(context, apiResponse);
    }
  }

  Widget _buildPhoneInput(BuildContext context, double screenWidth,
      bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
              (index) =>
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isDarkMode ? Colors.grey : Colors.black54,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                width: screenWidth / 8.1,
                height: 62.0,
                child: Center(
                  child: Text(
                    _inputValues[index],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
