import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/response/initiateP2PResponse.dart';
import 'package:Payrio/view/screens/bottomNavSection/transfer_otp_screen.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
import '../../component/toastMessage.dart';

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

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
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
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
        if(initiateP2PResponse?.otp!=null){
          ToastComponent.showToast(
              context: context, message: initiateP2PResponse?.otp);
        }else {
          ToastComponent.showToast(
              context: context, message: message);
        }
        CompleteP2PRequest data = CompleteP2PRequest(paymentTransactionId: initiateP2PResponse?.paymentTransactionId,
            customerOtpId: initiateP2PResponse?.customerOtpId,amount: widget.data?.amount,
            receiverUsername: widget.data?.receiverUsername, receiverPhoneNumber: widget.data?.receiverPhoneNumber,
            fullName:widget.data?.fullName, imageUrl: widget.data?.imageUrl
        );

        InitiateP2PRequest data1 = InitiateP2PRequest(tpin: '', amount: widget.data?.amount,
          receiverUsername: widget.data?.receiverUsername, receiverPhoneNumber: widget.data?.receiverPhoneNumber,);

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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),),
      body: Stack(
        children: [

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth*0.95,
                  //height: screenHeight * 0.15,
                  margin: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 8),
                  child: /*_buildLabelText(context, "Transaction \nPIN ", 28, true),*/
                  Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("To:"),
                          widget.data?.receiverPhoneNumber != null ?
                          Text("${widget.data?.receiverPhoneNumber}"):
                          Text("${widget.data?.receiverUsername}"),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sending:"),
                          Text("${widget.data?.amount}"),
                        ],
                      ),
                    ],
                  )
                  ,
                  alignment: AlignmentDirectional.center,
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.72,
                    margin: EdgeInsets.zero,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: _buildLabelText(
                                context, "Enter 4 digit TPIN", 20, true),
                          ),
                          SizedBox(height: 22),
                          _buildPhoneInput(context, screenWidth, isDarkMode),
                          SizedBox(height: 10),
                          SizedBox(height: 30,),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),color: Colors.yellow.shade700,),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              width: screenWidth*0.55,
                              child: Text("You are transferring money to ${widget.data?.receiverUsername}",
                                textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 13),),
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
    );
  }

  Future<void> _initiateTransaction( String tpin) async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      InitiateP2PRequest request = InitiateP2PRequest(tpin: tpin, amount: widget.data?.amount,
        receiverUsername: null, receiverPhoneNumber: widget.data?.receiverPhoneNumber,  );
      print("phno ${request?.receiverPhoneNumber}");
      print("username ${request?.receiverUsername}");
      await Provider.of<MainViewModel>(context, listen: false)
          .initiateP2PTransaction(
          "/api/v1/app/payment_transactions/initiate_p2p_transaction",
          request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false)
              .response;
      initiateTransactionResponse(context, apiResponse);
    }
  }

  Widget _buildPhoneInput(
      BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
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
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
