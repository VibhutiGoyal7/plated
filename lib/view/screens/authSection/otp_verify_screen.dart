import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:payrio/model/apis/api_response.dart';
import 'package:payrio/utils/Helper.dart';
import 'package:payrio/view_model/media_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../languageSection/Languages.dart';
import '../../../languageSection/Languages.dart';
import '../../../model/response/phoneVerifyResponse.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/otpVerifyResponse.dart';
import '../../component/toastMessage.dart';

class OTPVerifyScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  OTPVerifyScreen({Key? key, this.data}) : super(key: key);

  @override
  _OTPVerifyScreenState createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";

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

  Future<Widget> getOtpResponseDataWidget(
      BuildContext context, ApiResponse apiResponse) async {
    OtpVerifyResponse? otpVerifyResponse = apiResponse.data as OtpVerifyResponse?;
    var message = otpVerifyResponse?.message.toString();
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("OtpVerify ${otpVerifyResponse?.token}");
        //Call Toast
        ToastComponent.showToast(context: context, message: message);
        final prefs = await SharedPreferences.getInstance();
        String token = "${otpVerifyResponse?.token}";
        Navigator.pushNamed(context, '/SetUpAccount');
        // Save the token
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        Helper.getUserToken();
        // Retrieve the token
        String? retrievedToken = await Helper.getUserToken();
        print('Retrieved Token: $retrievedToken');
        // Navigate to the new screen after receiving the response
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  Widget getMediaWidgetResendOtp(
      BuildContext context, ApiResponse apiResponse) {
    PhoneVerifyResponse? phoneVerifyResponse = apiResponse.data as PhoneVerifyResponse?;
    var message = phoneVerifyResponse?.message.toString();
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${phoneVerifyResponse?.mobileOtp}");
        //Call Toast
        ToastComponent.showToast(context: context, message: message);
        // Navigate to the new screen after receiving the response
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;
    return Scaffold(
      body: Container(
        width: screenWidth,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildLabelText(
                    context, Languages.of(context)!.labelWelcome, 16, false),
                SizedBox(height: 4),
                _buildLabelText(
                    context, Languages.of(context)!.labelEnterCode, 20, true),
                SizedBox(height: 4),
                _buildLabelText(
                    context,
                    "${Languages.of(context)!.labelSentCode} ${widget.data}",
                    12,
                    false),
                SizedBox(height: 22),
                _buildPhoneInput(context, screenWidth),
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                ),
                Spacer(),
                _buildFooter(context),
              ],
            ),
          ),
        ),
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

  Widget _buildPhoneInput(BuildContext context, double screenWidth) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            width: screenWidth / 8.1,
            height: 65.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              style: TextStyle(fontSize: 18),
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
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Languages.of(context)!.labelTandC,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              String otp =
                  _controllers.map((controller) => controller.text).join();
              if (otp.isNotEmpty && otp.length == 6) {
                PhoneRequest phoneRequest = PhoneRequest(
                    customer: Customer(
                        phoneNumber: widget.data.toString(), mobileOtp: otp));
                /*await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchOtpVerifyData(
                      "/api/v1/app/temp_customers/verify_customer_mobile_otp_for_signup",
                      phoneRequest);*/

                ApiResponse apiResponse =
                    Provider
                        .of<MediaViewModel>(context, listen: false)
                        .response;
                //getMediaWidget(context, apiResponse);
                Navigator.pushNamed(
                    context,
                    '/SetUpAccount'
                );
              }else{
                SnackBar(
                  content: Text("Enter 6-digit otp."),
                );
              }
            },
            child: Text(
              Languages.of(context)!.labelValidate,
              style:
                  TextStyle(color: isValid ? Colors.white : Colors.blueAccent),
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: isValid ? Colors.blueAccent : Colors.white,
                elevation: 3,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
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

  void _handleBackspace() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].text = '';
        break;
      } else if (i > 0 && _controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        break;
      }
    }
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          phoneNo = widget.data as String;
          PhoneRequest phoneRequest = PhoneRequest(
              customer: Customer(phoneNumber: phoneNo, mobileOtp: ""));
          await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchMediaData(
                      "/api/v1/app/temp_customers/initiate_customer",
                      phoneRequest);

          ApiResponse apiResponse =
              Provider.of<MediaViewModel>(context, listen: false).response;
          getMediaWidgetResendOtp(context, apiResponse);
        },
        child: Text(
          "Resend Otp",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ));
  }
/*void restartTimer() {
    countDownTimer.cancel();
    startTimer();
  }*/
}
