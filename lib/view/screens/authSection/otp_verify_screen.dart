import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/otpVerifyResponse.dart';
import '../../../model/response/phoneVerifyResponse.dart';
import '../../../theme/AppColor.dart';
import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
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
  late double screenWidth;
  bool isLoading = false;
  List<String> _inputValues = ['', '', '', '','',''];
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
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
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
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
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
          child: Text(''),
        );
    }
  }

  Widget getResendOtpResponse(BuildContext context, ApiResponse apiResponse) {
    PhoneVerifyResponse? phoneVerifyResponse =
        apiResponse.data as PhoneVerifyResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
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
        ToastComponent.showToast(
            context: context, message: apiResponse?.message);
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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.15,
                  margin: EdgeInsets.zero,
                  child: _buildLabelText(
                      context, "OTP \n VERIFICATION ", 28, true),
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
                          /*_buildLabelText(context,
                              Languages.of(context)!.labelWelcome, 16, false),

                          SizedBox(height: 4),*/
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: _buildLabelText(
                                  context,
                                  Languages.of(context)!.labelEnterCode,
                                  14,
                                  true),
                            ),
                          ),
                          SizedBox(height: 4),
                          Center(
                            child: _buildLabelText(
                                context,
                                "${Languages.of(context)!.labelSentCode} ${widget.data}",
                                12,
                                false),
                          ),
                          SizedBox(height: 22),
                          _buildOtpInput(context, screenWidth, isDarkMode),

                          SizedBox(height: 10),
                          Padding(
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
                          ),
                          Spacer(),
                          CustomNumberKeyboard(onKeyTap: (value) async {
                            if (value == "clear") {
                              _handleBackspace();
                            } else if (value == "submit") {
                              String otp = _inputValues
                                  .map((controller) => controller)
                                  .join();
                              if (otp.isNotEmpty && otp.length == 6) {
                                /*String otp =
                                _controllers.map((controller) => controller.text).join();*/
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
                                        Provider.of<MainViewModel>(context, listen: false)
                                            .response;
                                    getOtpResponseDataWidget(context, apiResponse);
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
                              }
                            } else {
                              _handleKeyTap(value);
                            }
                          }),
                          //_buildFooter(context),
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

  Widget _countdownTimer() {
    return TimerCountdown(
      endTime: DateTime.now().add(const Duration(minutes: 1, seconds: 0)),
      format: CountDownTimerFormat.minutesSeconds,
      enableDescriptions: false,
      spacerWidth: 2,
      timeTextStyle: TextStyle(fontWeight: FontWeight.w600),
      onEnd: () {
        setState(() {
          resendOtp = true;
        });
      },
    );
  }

  Widget _buildOtpInput(BuildContext context, double screenWidth, bool isDarkMode) {
    return  Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
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

  void _handleOnChange(int index, String value) {
    setState(() {
      _otp[index] = value;
    });

    // Move focus based on input
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


  /* Widget _buildOtpInput(
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
*/

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index].unfocus();
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  void _handleTextChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index].unfocus();
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                      Provider.of<MainViewModel>(context, listen: false)
                          .response;
                  getOtpResponseDataWidget(context, apiResponse);
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
        SizedBox(
          height: 24,
        )
      ],
    );
  }
/*

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
*/

/*  void _handleBackspace() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].text = '';
        break;
      } else if (i > 0 && _controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        break;
      }
    }
  }*/

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

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          phoneNo = widget.data as String;
          PhoneRequest phoneRequest = PhoneRequest(
              customer: Customer(
                  phoneNumber: phoneNo, mobileOtp: "", countryId: null));
          await Provider.of<MainViewModel>(context, listen: false)
              .PhoneVerifyData(
                  "/api/v1/app/temp_customers/initiate_customer", phoneRequest);

          ApiResponse apiResponse =
              Provider.of<MainViewModel>(context, listen: false).response;
          getResendOtpResponse(context, apiResponse);
        },
        child: Text(
          "Resend Otp",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ));
  }
/*void restartTimer() {
    countDownTimer.cancel();
    startTimer();
  }*/
}
