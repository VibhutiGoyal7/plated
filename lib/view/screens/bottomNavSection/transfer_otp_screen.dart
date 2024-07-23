import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/model/response/completeP2PResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/phoneVerifyResponse.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

class TransferOtpScreen extends StatefulWidget {
  final CompleteP2PRequest data;// Define the 'data' parameter here

  TransferOtpScreen({Key? key, required this.data}) : super(key: key);

  @override
  _TransferOtpScreenState createState() => _TransferOtpScreenState();
}

class _TransferOtpScreenState extends State<TransferOtpScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

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

  void _isValidOtp(String input) {
    print(input);
    if (input.isNotEmpty && input.length >= 10) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  Future<Widget> completeTransactionResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CompleteP2PResponse? completeP2PResponse =
    apiResponse.data as CompleteP2PResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("Complete Transaction ${completeP2PResponse?.amount}");
        CheckCustomerResponse prefData = CheckCustomerResponse(username: widget.data.receiverUsername,fullName:widget.data.fullName,
        phoneNumber: widget.data.receiverPhoneNumber, imageUrl: widget.data.imageUrl );
        print("PrefData ${prefData.username}");
        List<CheckCustomerResponse>? prefResponse = await Helper.getRecentP2PDetails();
       // print("prefResponse ${prefResponse?[0].username}");
        bool dataExist = false;
        if(prefResponse?.length != null) {
          for (int i = 0; i < prefResponse!.length; i++) {
            if (prefData.username == prefResponse[i].username) {
              dataExist = true;
            }
          }
        }else{
          dataExist = false;
        }
        if(!dataExist) {
          if(prefResponse!=null) {
            prefResponse.add(prefData);
            print("prefResponse ${prefResponse[0].username}");
            Helper.saveRecentP2PDetails(prefResponse);
          }else{
            List<CheckCustomerResponse>? dataList = [] ;
            Helper.saveRecentP2PDetails(dataList);

          }
        }

        ToastComponent.showToast(context: context, message: message);

        CompleteP2PRequest data = CompleteP2PRequest(
            otp: "",
            customerOtpId: widget.data.customerOtpId,
            paymentTransactionId: widget.data.paymentTransactionId,
          amount: widget.data.amount,
          imageUrl: widget.data.imageUrl,
          fullName: widget.data.fullName,
          receiverUsername: widget.data.receiverUsername,
          receiverPhoneNumber: widget.data.receiverPhoneNumber,
        );

        Navigator.pushReplacementNamed(context, '/PaymentSuccessfulScreen', arguments: data);

        return Container();
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          print(apiResponse.message);
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(context: context, message: message);
        }
        return Center(
          //child: Text('Please try again later!!!'),
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
          Navigator.of(context).pop;
        },
        child: Icon(Icons.arrow_back),
      ),),
      body: Stack(
        children: [
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ): SizedBox(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth*0.95,
                  margin: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 8),
                  child:
                  Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("To:"),
                          widget.data.receiverPhoneNumber != null ?
                          Text("${widget.data.receiverPhoneNumber}")
                          :Text("${widget.data.receiverUsername}"),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sending:"),
                          Text("${widget.data.amount}"),
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
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: _buildLabelText(context,
                                "Please enter the 6-digit otp sent to your phone number to complete the transaction.", 14, false),
                          ),
                          SizedBox(height: 4),
                          SizedBox(height: 22),
                          _buildOtpInput(context, screenWidth, isDarkMode),
                          SizedBox(height: 10),
                          /*Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24),
                            child: Row(
                              children: [
                                _buildLabelText(
                                    context,
                                    "${Languages.of(context)!.labelResendCode} ",
                                    14,
                                    true),
                                _countdownTimer(),
                                Spacer(),
                                if (resendOtp) _resendOtpButton(context)
                              ],
                            ),
                          ),*/
                          Spacer(),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _countdownTimer() {
    return TimerCountdown(
      endTime: DateTime.now().add(const Duration(minutes: 1, seconds: 0)),
      format: CountDownTimerFormat.minutesSeconds,
      enableDescriptions: false,
      spacerWidth: 2,
      timeTextStyle: TextStyle(fontWeight: FontWeight.bold),
      onEnd: () {
        setState(() {
          resendOtp = true;
        });
      },
    );
  }

  Widget _buildOtpInput(
      BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    bottom: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    right: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    left: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4)),
                borderRadius: BorderRadius.circular(6)),
            width: screenWidth / 8.1,
            height: 62.0,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (value) {
                _handleOnChange(index, value);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text(
            Languages.of(context)!.labelTandC,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),*/
        Center(
          child: SizedBox(
            width: screenWidth * 0.7,
            child: ElevatedButton(
              onPressed: () async {
                String otp =
                _controllers.map((controller) => controller.text).join();
                const maxDuration = Duration(seconds: 2);
                if (otp.isNotEmpty && otp.length == 6) {
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
                    CompleteP2PRequest completeP2PRequest = CompleteP2PRequest(
                      otp: otp,
                      customerOtpId: widget.data.customerOtpId,
                      paymentTransactionId: widget.data.paymentTransactionId
                    );
                    await Provider.of<MainViewModel>(context, listen: false)
                        .completeP2PTransaction(
                        "/api/v1/app/payment_transactions/complete_p2p_transaction",
                        completeP2PRequest);

                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    completeTransactionResponse(context, apiResponse);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter valid phone number and select country code.'),
                      duration: maxDuration,
                    ),
                  );
                }
              },
              child: Text(
                Languages.of(context)!.labelValidate,
                style:
                TextStyle(color: isValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: isValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        )
      ],
    );
  }

  void _handleOnChange(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }

    String otpString = _otp.join('');
    if (otpString.length == 6) {
      isValid = true;
    } else {
      isValid = false;
    }
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
