import 'dart:io';

import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../../../../theme/AppColor.dart';
import '../../../../utils/Util.dart';
import '../../../model/response/notificationOtpResponse.dart';
import '../../../utils/Helper.dart';
import '../../component/custom_button_component.dart';

class EnterPinScreen extends StatefulWidget {
  final String? data;
  final Function() onSuccess; // Define the 'data' parameter here

  EnterPinScreen({Key? key, this.data, required this.onSuccess})
      : super(key: key);

  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String dropdownValue = "";
  bool isValid = false;
  String oldPin = "";
  String newPin = "";
  String confirmPin = "";
  late double screenWidth;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  bool? isUserAuthenticated = false;
  NotificationOtpResponse? notificationOtpResponse;
  bool _authenticationAttempted = false;
  bool _isAuthenticated = false;
  bool _authOnResume = false;
  String _authorized = 'Not Authorized';

  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    isValid = false;

    // notificationOtpResponse = widget.data;
    /*Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });*/
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16),
                      child: GestureDetector(
                          onTap: () async {
                            hideKeyBoard();
                            await Future.delayed(Duration(milliseconds: 2));
                            Navigator.pushNamed(context, "/BottomNav");
                          },
                          child: Icon(Icons.cancel_rounded)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Enter PIN',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Enter your BD Pass PIN to proceed",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: Container(
                            width: screenWidth * 0.6,
                            child: OtpPinField(
                              onSubmit: (String otp) {
                                setState(() {
                                  oldPin = otp;
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
                              cursorColor: Colors.black,
                              showCursor: false,
                              onChange: (String value) {
                                print("Current input: $value");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //Spacer(),
              Center(
                  child: GestureDetector(
                      onTap: () {
                        _initializeBiometrics();
                      },
                      child: Column(
                        children: [
                          Icon( Platform.isIOS
                              ? Icons.face :
                            Icons.fingerprint,
                            size: 45,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Platform.isAndroid ? "Tap to use biometrics" : "Tap to use Face ID",
                            style:
                                TextStyle(fontSize: 8, color: AppColor.PRIMARY),
                          )
                        ],
                      ))),
              SizedBox(
                height: 35,
              ),
              CustomButtonComponent(
                  text: "${Languages.of(context)?.labelContinue}",
                  isDarkMode: isDarkMode,
                  screenWidth: screenWidth * 0.8,
                  verticalPadding : 14,
                  onTap: widget.data != null
                      ? widget.onSuccess
                      : () {
                          hideKeyBoard();
                          print(
                              "oldPin: $oldPin :: newPin: $newPin :: confirmPin: $confirmPin");
                          Navigator.pushNamed(context, "/VerifyPhoneScreen");
                        }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeBiometrics() async {
    bool? retrievedBiometric = await Helper.getBiometric();
    bool? canCheckBiometric = retrievedBiometric;
    print('Can CheckBiometric: $canCheckBiometric');
    if (isUserAuthenticated != true) {
      if (canCheckBiometric != null && canCheckBiometric == true) {
        List<BiometricType> availableBiometric = [];
        try {
          canCheckBiometric = await auth.canCheckBiometrics;
          if (canCheckBiometric) {
            availableBiometric = await auth.getAvailableBiometrics();
          }
        } on PlatformException catch (e) {
          print(e);
        }

        if (!mounted) return;

        setState(() {
          _canCheckBiometric =
              canCheckBiometric! && availableBiometric.isNotEmpty;
        });
        print("_authenticationAttempted $_authenticationAttempted");

        if (_canCheckBiometric /*&& !_authenticationAttempted*/) {
          print("Checking Number of times");
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomBiometricScreen(
                  data: notificationOtpResponse,
                )),
          );*/
          _authenticate(); // Only call authenticate if not attempted before
        }
      } else {
        ToastComponent.showToast(
            context: context, message: Platform.isAndroid ? "Biometric is not enabled" : "Face ID is not enabled");
      }
    }
  }

  bool hasUniqueCharacters(String input) {
    // Check if the input is exactly 6 characters long
    if (input.length != 6) return false;

    // Check if all characters are the same
    return !RegExp(r'^(\d)\1{5}$').hasMatch(input);
  }

  Future<void> _authenticate() async {
    print("Called _authenticate()");
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );
      print("authenticated $authenticated");
    } on PlatformException catch (e) {
      print('Error authenticating: $e');
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticated = authenticated;
      _authOnResume = authenticated;
      print("_authOnResume $_authOnResume");
      _authorized = authenticated ? 'Authorized' : 'Failed to authenticate';
      _authenticationAttempted = true;
    });

    if (authenticated) {
      print("User authenticated successfully.");
      if (widget.data != null) {
        widget.onSuccess();
      } else {
        hideKeyBoard();
        print("oldPin: $oldPin :: newPin: $newPin :: confirmPin: $confirmPin");
        Navigator.pushNamed(context, "/VerifyPhoneScreen");
      }
    } else {
      print("User cancelled authentication.");
      //SystemNavigator.pop();
    }
  }
}
