import 'dart:io';

import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/otpVerifyResponse.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/toastMessage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  OtpVerificationScreen({Key? key, this.data}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  late DateTime endTime;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  File? docImg;
  bool isDarkMode = false;
  bool isChecked = false;
  String selectedItem = "";
  bool isValid = false;
  bool resendOtp = false;
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');
  List<String> _inputValues = ['', '', '', '', '', ''];

  @override
  void initState() {
    super.initState();
    isValid = false;
    resendOtp = false;
    endTime = DateTime.now().add(const Duration(minutes: 1, seconds: 0));

    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
    _handleBackspaceKey();
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

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.data == "mobile"
                          ? "${Languages.of(context)?.labelVerifyYourMobileNumber}"
                          : "Verify Your Email Address",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SvgPicture.asset(
                      "assets/forgot_pass_icon.svg",
                      height: 120,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Verification Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please enter the 6 digit code sent to your email address ********r@gmail.com",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //OTP Boxes
                    _buildOtpInput(context, screenWidth, isDarkMode),

                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelText(
                            context,
                            "${Languages.of(context)?.labelDidntReceiveOtp}",
                            14,
                            true,
                            color: isDarkMode ? Colors.grey : Colors.black54,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _countdownTimer(),
                              SizedBox(
                                width: 15,
                              ),
                              if (resendOtp) _resendOtpButton(context)
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
            if (isLoading) CustomCircularProgress(),
          ]),
        ),
      ),
    );
  }

  Widget _countdownTimer() {
    return Row(
      children: [
        Icon(
          Icons.timer,
          size: 18,
          color: isDarkMode ? Colors.grey : Colors.black54,
        ),
        SizedBox(
          width: 3,
        ),
        TimerCountdown(
          endTime: endTime,
          format: CountDownTimerFormat.minutesSeconds,
          enableDescriptions: false,
          spacerWidth: 1,
          timeTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isDarkMode ? Colors.grey : Colors.black54),
          onEnd: () {
            setState(() {
              resendOtp = true;
            });
          },
        ),
      ],
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold,
      {required Color color}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
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
            margin: EdgeInsets.symmetric(horizontal: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).cardColor,
              border: Border.all(width: 0.2, color: AppColor.GREY_TEXT_COLOR),
            ),
            width: screenWidth / 8,
            height: 50.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  FocusScope.of(context).nextFocus();
                  _handleKeyTap(value);
                }
              },
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleBackspaceKey() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _controllers[i].text.isEmpty && i > 0) {
          FocusScope.of(context).previousFocus();
        }
      });
    }
  }

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {},
        child: Text(
          "${Languages.of(context)?.labelSendAgain}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColor.WHITE : Colors.black54,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: isDarkMode ? AppColor.WHITE : Colors.black54),
        ));
  }

  Future<Widget> getOtpResponseDataWidget(
      BuildContext context, ApiResponse apiResponse) async {
    OtpVerifyResponse? otpVerifyResponse =
        apiResponse.data as OtpVerifyResponse?;
    setState(() {
      isLoading = false;
    });
    var message = apiResponse.message.toString();
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : Colors.red,
        ));
      case Status.COMPLETED:
        print("OtpVerify ${otpVerifyResponse?.token}");
        //Call Toast

        ToastComponent.showToast(context: context, message: message);
        final prefs = await SharedPreferences.getInstance();
        String token = "${otpVerifyResponse?.token}";
        Navigator.pushReplacementNamed(context, '/SetUpAccount');
        // Save the token
        bool isSaved = await Helper.saveOtpToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        Helper.getOtpToken();
        // Retrieve the token
        String? retrievedToken = await Helper.getOtpToken();
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

  Widget _buildFooter(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        hideKeyBoard();
        String otp = _inputValues.map((controller) => controller).join();
        if (otp.isNotEmpty && otp.length == 5) {
          String otp = _controllers.map((controller) => controller.text).join();
          const maxDuration = Duration(seconds: 2);
          if (otp.isNotEmpty && otp.length == 6) {
            bool isConnected = await _connectivityService.isConnected();
            if (!isConnected) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${Languages.of(context)?.labelNoInternetConnection}'),
                  duration: maxDuration,
                ),
              );
            } else {
              PhoneRequest phoneRequest = PhoneRequest(
                  customer: Customer(
                      phoneNumber: widget.data.toString(),
                      mobileOtp: otp,
                      countryId: null));
              await Provider.of<MainViewModel>(context, listen: false)
                  .fetchOtpVerifyData(phoneRequest);

              ApiResponse apiResponse =
                  Provider.of<MainViewModel>(context, listen: false).response;
              getOtpResponseDataWidget(context, apiResponse);
            }
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${Languages.of(context)?.labelPleaseEnterValidPhoneNo}'),
                duration: maxDuration,
              ),
            );
          }
        }
      },
      color: AppColor.PRIMARY_ACCENT,
      minWidth: screenWidth * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        Languages.of(context)!.labelSubmit,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  void onPressedFrontImage() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      if (!mounted) return;
      setState(() {
        print("Front Image: ${pictures}");
        docImg = File(pictures.first);
        print("Front Image: $docImg");
      });
    } catch (exception) {
      // Handle exception here
    }
  }
}
