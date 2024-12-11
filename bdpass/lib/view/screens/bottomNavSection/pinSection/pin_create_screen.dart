import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/apis/api_response.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

import '../../../../theme/AppColor.dart';
import '../../../../utils/Util.dart';
import '../../../component/custom_button_component.dart';

class PinCreateScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  PinCreateScreen({Key? key, this.data}) : super(key: key);

  @override
  _PinCreateScreenState createState() => _PinCreateScreenState();
}

class _PinCreateScreenState extends State<PinCreateScreen> {
  String dropdownValue = "";
  bool isValid = false;
  String pin = "";
  String confirmPin = "";
  bool isConfirmPin = false;
  late double screenWidth;

  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    isValid = false;
    // Attach listeners to focus nodes to keep the keyboard consistent
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      });
    }
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
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Create PIN',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Please create your new BD Pass PIN",
                    style: TextStyle(),
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: Container(
                      width: screenWidth * 0.6,
                      child: OtpPinField(
                        onSubmit: (String otp) {
                          setState(() {
                            pin = otp;
                            isConfirmPin = true;
                          });
                          print("Entered OTP: $otp");
                          // Handle the OTP submission
                        },
                        maxLength: 4,
                        otpPinFieldInputType: OtpPinFieldInputType.password,
                        otpPinFieldDecoration:
                            OtpPinFieldDecoration.roundedPinBoxDecoration,
                        otpPinFieldStyle: OtpPinFieldStyle(
                            defaultFieldBorderColor: AppColor.PRIMARY,
                            activeFieldBorderColor: Colors.grey,
                            filledFieldBackgroundColor: AppColor.PRIMARY,
                            fieldBorderRadius: 14,
                            fieldBorderWidth: 1.5,
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)
                            //borderRadius: BorderRadius.circular(10),
                            ),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        fieldWidth: 22,
                        fieldHeight: 22,
                        showCursor: false,
                        onChange: (String value) {
                          print("Current input: $value");
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  isConfirmPin
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Confirm your BD Pass PIN"),
                            SizedBox(height: 25),
                            Center(
                              child: Container(
                                width: screenWidth * 0.6,
                                child: OtpPinField(
                                  onSubmit: (String otp) {
                                    setState(() {
                                      confirmPin = otp;
                                    });
                                    print("Entered OTP: $otp");
                                    // Handle the OTP submission
                                  },
                                  maxLength: 4,
                                  otpPinFieldInputType:
                                      OtpPinFieldInputType.password,
                                  otpPinFieldDecoration: OtpPinFieldDecoration
                                      .roundedPinBoxDecoration,
                                  otpPinFieldStyle: OtpPinFieldStyle(
                                      defaultFieldBorderColor: AppColor.PRIMARY,
                                      activeFieldBorderColor: Colors.grey,
                                      filledFieldBackgroundColor:
                                          AppColor.PRIMARY,
                                      fieldBorderRadius: 14,
                                      fieldBorderWidth: 1.5,
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)
                                      //borderRadius: BorderRadius.circular(10),
                                      ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  fieldWidth: 22,
                                  fieldHeight: 22,
                                  cursorColor: Colors.black,
                                  showCursor: false,
                                  onChange: (String value) {
                                    print("Current input: $value");
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Spacer(),
            CustomButtonComponent(
                text: "${Languages.of(context)?.labelContinue}",
                isDarkMode: isDarkMode,
                screenWidth: screenWidth,
                onTap: () {
                  hideKeyBoard();
                  if(pin == confirmPin){
                    Helper.savePin(pin);
                  }
                  print("newPin: $pin :: confirmPin: $confirmPin");
                  //Navigator.pushNamed(context, "/BottomNav");
                  Navigator.pushNamed(context, "/AccountRegisteredScreen");
                }),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  bool hasUniqueCharacters(String input) {
    // Check if the input is exactly 6 characters long
    if (input.length != 6) return false;

    // Check if all characters are the same
    return !RegExp(r'^(\d)\1{5}$').hasMatch(input);
  }
}
