import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/otpVerifyResponse.dart';
import '../../../model/response/phoneVerifyResponse.dart';
import '../../component/CustomNumberKeyboard.dart';
import '../../component/toastMessage.dart';

class TpinCreateScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  TpinCreateScreen({Key? key, this.data}) : super(key: key);

  @override
  _TpinCreateScreenState createState() => _TpinCreateScreenState();
}

class _TpinCreateScreenState extends State<TpinCreateScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
  String _input = '';
  List<String> _inputValues = ['', '', '', ''];

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
    OtpVerifyResponse? otpVerifyResponse =
        apiResponse.data as OtpVerifyResponse?;
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
        Navigator.pushReplacementNamed(context, '/SetUpAccount');
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

        Navigator.pushNamed(context, '/SetUpAccount');
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
          child: Text('Search for the song by Artist'),
        );
    }
  }

  Widget getMediaWidgetResendOtp(
      BuildContext context, ApiResponse apiResponse) {
    PhoneVerifyResponse? phoneVerifyResponse =
        apiResponse.data as PhoneVerifyResponse?;
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
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight * 0.15,
              margin: EdgeInsets.zero,
              child: _buildLabelText(context, "Transaction \nPIN ", 28, true),
              alignment: AlignmentDirectional.center,
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.72,
                margin: EdgeInsets.zero,
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: _buildLabelText(context,
                            "Enter 4 digit TPIN", 20, true),
                      ),
                      SizedBox(height: 22),
                      _buildPhoneInput(context, screenWidth , isDarkMode),
                      SizedBox(height: 10),
                      Spacer(),
                      CustomNumberKeyboard(onKeyTap: (value) {
                        if (value == '⌫') {
                          _handleBackspace();
                        } else {
                          _handleKeyTap(value);
                        }
                      }),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildPhoneInput(BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
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


  Widget _buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: screenWidth * 0.7,
            //margin: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () async {
                String otp =
                    _controllers.map((controller) => controller.text).join();
                if (otp.isNotEmpty && otp.length == 6) {
                  PhoneRequest phoneRequest = PhoneRequest(
                      customer: Customer(
                          phoneNumber: widget.data.toString(),
                          mobileOtp: otp,
                          countryId: null));
                  await Provider.of<MainViewModel>(context, listen: false)
                      .fetchOtpVerifyData(
                          "/api/v1/app/temp_customers/verify_customer_mobile_otp_for_signup",
                          phoneRequest);

                  ApiResponse apiResponse =
                      Provider.of<MainViewModel>(context, listen: false).response;
                  getOtpResponseDataWidget(context, apiResponse);
                } else {
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

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          phoneNo = widget.data as String;
          PhoneRequest phoneRequest = PhoneRequest(
              customer: Customer(
                  phoneNumber: phoneNo, mobileOtp: "", countryId: null));
          await Provider.of<MainViewModel>(context, listen: false)
              .fetchMediaData(
                  "/api/v1/app/temp_customers/initiate_customer", phoneRequest);

          ApiResponse apiResponse =
              Provider.of<MainViewModel>(context, listen: false).response;
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
