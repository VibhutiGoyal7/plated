import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/notificationOtpResponse.dart';
import '../../../theme/AppColor.dart';

class NotificationOtpScreen extends StatefulWidget {
  final NotificationOtpResponse? data; // Define the 'data' parameter here

  NotificationOtpScreen({Key? key, this.data}) : super(key: key);

  @override
  _NotificationOtpScreenState createState() => _NotificationOtpScreenState();
}

class _NotificationOtpScreenState extends State<NotificationOtpScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String notificationType = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
  bool isLoading = false;
  List<String> _inputValues = ['', '', '', '', '', ''];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    isValid = false;
    resendOtp = false;
    notificationType = "${widget.data?.notificationType}";
    _timer = Timer(Duration(minutes: 3), () {
      // Navigate back to the previous page
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/BottomNav");
      }
    });
    String? otpData = widget.data?.otp; // Assuming otp is a String
    if (otpData != null && otpData.length == 6) {
      _inputValues = otpData.split('').map((e) => e.trim()).toList();
      for (int i = 0; i < _inputValues.length; i++) {
        _controllers[i].text = _inputValues[i]; // Set text in controllers
      }
    }
    print("message: ${widget.data?.otp}");
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
    if (_timer != null) {
      _timer.cancel();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                      context,
                      notificationType == "deposit_otp"? "${Languages.of(context)?.labelDepositOtp}" : "${Languages.of(context)?.labelWithdrawOtp}",
                      28,
                      true),
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
              ],
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
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
      endTime: DateTime.now().add(const Duration(minutes: 2, seconds: 59)),
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

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.6),
              child: SizedBox(
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: () =>
                      {Navigator.pushReplacementNamed(context, "/BottomNav")},
                  child: Text(
                    Languages.of(context)!.labelClose,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColor.PRIMARY,
                      elevation: 3,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 24,
        )
      ],
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
