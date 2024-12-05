import 'dart:io';

import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
import '../../component/instruction_step.dart';

class OtpVerificationScreen extends StatefulWidget {
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
  List<CountryData> countryList = [];
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
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Verify Your Mobile Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    InstructionStep(
                        icon: Icons.document_scanner_rounded,
                        title: "Step 1",
                        isActive: true,
                        iconColor: Colors.green.shade900),
                    InstructionStep(
                        icon: Icons.person_sharp,
                        title: "Step 2",
                        isActive: true,
                        iconColor: Colors.green.shade900),
                    InstructionStep(
                        icon: Icons.lock_sharp,
                        title: "Step 3",
                        isActive: false,
                        iconColor: Colors.green.shade900),
                  ],
                ),
                Text(
                  "Please enter the OTP (One Time Password) sent via SMS to mobile 971557403260",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20,
                ),

                //OTP Boxes
                _buildOtpInput(context, screenWidth, isDarkMode),

                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabelText(
                          context, "Didn't receive the OTP yet?", 11, true),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _countdownTimer(),
                          //Spacer(),
                          SizedBox(
                            width: 5,
                          ),
                          if (resendOtp) _resendOtpButton(context)
                        ],
                      )
                    ],
                  ),
                ),
                Spacer(),
                CustomNumberKeyboard(onKeyTap: (value) async {
                  if (value == "clear") {
                    _handleBackspace();
                  } else if (value == "submit") {
                    String otp =
                        _inputValues.map((controller) => controller).join();
                    Navigator.pushNamed(context, "/AccountRecoveryScreen");
                  } else {
                    _handleKeyTap(value);
                  }
                }),
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
              : SizedBox()
        ]),
      ),
    );
  }

  Widget _countdownTimer() {
    return Row(
      children: [
        TimerCountdown(
          endTime: endTime,
          format: CountDownTimerFormat.minutesSeconds,
          enableDescriptions: false,
          spacerWidth: 1,
          timeTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          onEnd: () {
            setState(() {
              resendOtp = true;
            });
          },
        ),
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
              borderRadius: BorderRadius.circular(100),
            ),
            width: screenWidth / 8.1,
            height: 52.0,
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

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {},
        child: Text(
          "Send Again",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ));
  }

  Widget _buildFooter(
      {required BuildContext context,
      required String text,
      required VoidCallback onTap}) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.8),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
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

  void _fetchData() async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCountryList("api/v1/app/customers/country_list");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCountryList(context, apiResponse);
    }
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, double height) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        //height: 60,
        width: screenWidth * height,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  //_isValidInput();
                },
                maxLength: 12,
                textAlignVertical: TextAlignVertical.top,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                onSubmitted: (value) {},
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  alignLabelWithHint: true,
                  counterText: "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[1].name}");

        countryList = countryListResponse!.countries!;
        Helper.saveCountryList(countryList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";

        print("countriess ${countryList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${countryList}");
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
}
