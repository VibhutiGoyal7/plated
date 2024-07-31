import 'package:Payrio/model/response/GenerateOtpTPINChangeResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/generateOtpTpinChange.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

class ChangeTpinScreen extends StatefulWidget {
  @override
  _ChangeTpinScreenState createState() => _ChangeTpinScreenState();
}

class _ChangeTpinScreenState extends State<ChangeTpinScreen> {
  String token = "";

  final List<String> _otp = List.generate(6, (_) => '');
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<FocusNode> _tPinFocusNodes = List.generate(4, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<TextEditingController> _TPinControllers =
      List.generate(4, (index) => TextEditingController());
  bool isValid = false;
  bool isOtpEntered = false;

  late double screenWidth;
  late double screenHeight;
  late String otp;
  late String tpin;

  List<String> _inputTpinValues = ['', '', '', ''];
  List<String> _inputOtpValues = ['', '', '', '', '', ''];

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    generateOtp();
  }

  void _handleKeyTap(String value) {
    setState(() {
      if (isOtpEntered) {
        for (int i = 0; i < _inputTpinValues.length; i++) {
          if (_inputTpinValues[i].isEmpty) {
            _inputTpinValues[i] = value;
            break;
          }
        }
      } else {
        for (int i = 0; i < _inputOtpValues.length; i++) {
          if (_inputOtpValues[i].isEmpty) {
            _inputOtpValues[i] = value;
            break;
          }
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      if (isOtpEntered) {
        for (int i = _inputTpinValues.length - 1; i >= 0; i--) {
          if (_inputTpinValues[i].isNotEmpty) {
            _inputTpinValues[i] = '';
            break;
          }
        }
      } else {
        for (int i = _inputOtpValues.length - 1; i >= 0; i--) {
          if (_inputOtpValues[i].isNotEmpty) {
            _inputOtpValues[i] = '';
            break;
          }
        }
      }
    });
  }

  Future<Widget> verifyOtpTpinChange(
      BuildContext context, ApiResponse apiResponse) async {
    final response = apiResponse.data;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        ToastComponent.showToast(
            context: context, message: "TPIN changed successfully.");

        Navigator.pushReplacementNamed(context, '/ProfileScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(context: context, message: message);
        }
        return Center(
            // child: Text('Please try again later!!!'),
            );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  Future<Widget> getOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    GenerateOtpTPINChangeResponse? response =
        apiResponse.data as GenerateOtpTPINChangeResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${response?.otp}");
        ToastComponent.showToast(context: context, message: response?.otp);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(context: context, message: message);
        }
        return Center(
            // child: Text('Please try again later!!!'),
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
    screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Change TPIN",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          height: screenHeight * 0.9,
          child: SafeArea(
            child: Column(
              children: [
               /* Center(
                  child: Image(
                    alignment: Alignment.topLeft,
                    //width: screenWidth*0.8,
                    height: screenHeight * 0.16,
                    image: AssetImage("assets/forgot_password.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),*/
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Please enter the 6-digit otp which has been sent to your phone number",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                _buildOtpInput(context, screenWidth, isDarkMode),
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 18.0),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColor.PRIMARY),
                      ),
                      onPressed: () async {
                        otp = _inputOtpValues
                            .map((controller) => controller)
                            .join();
                        if (otp.length == 6 && otp.isNotEmpty) {
                          setState(() {
                            isOtpEntered = true;
                          });
                        }
                      },
                      child: Text(
                        Languages.of(context)!.labelSubmit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                isOtpEntered
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: _buildLabelText(context,
                                "Enter the new 4 digit TPIN", 14, false),
                          ),

                          SizedBox(height: 10),
                          _buildTpinInput(context, screenWidth, isDarkMode),
                          SizedBox(height: 10),
                          //Spacer(),
                        ],
                      )
                    : SizedBox(
                        height: 80,
                      ),

                Spacer(),
                CustomNumberKeyboard(onKeyTap: (value) async {
                  if (value == "clear") {
                    _handleBackspace();
                  } else if (value == "submit") {
                    tpin =
                        _inputTpinValues.map((controller) => controller).join();
                    otp =
                        _inputOtpValues.map((controller) => controller).join();
                    if (otp.isNotEmpty &&
                        otp.length == 6 &&
                        tpin.isNotEmpty &&
                        tpin.length == 4) {
                      if (otp.isNotEmpty &&
                          otp.length == 6 &&
                          tpin.isNotEmpty &&
                          tpin.length == 4) {
                        setState(() {
                          isLoading = true;
                        });

                        bool isConnected =
                            await _connectivityService.isConnected();
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
                          VerifyOtpTPinChange request = VerifyOtpTPinChange(
                            tpin: tpin,
                            otp: otp,
                          );
                          await Provider.of<MainViewModel>(context,
                                  listen: false)
                              .verifyOtpTPinChange(
                                  "/api/v1/app/customers/change_tpin_using_otp",
                                  request);

                          ApiResponse apiResponse =
                              Provider.of<MainViewModel>(context, listen: false)
                                  .response;
                          verifyOtpTpinChange(context, apiResponse);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter otp and new TPIN.'),
                            duration: maxDuration,
                          ),
                        );
                      }
                    }
                  } else {
                    _handleKeyTap(value);
                  }
                })

                //_buildFooter(context),
              ],
            ),
          ),
        ),
      ),
      isLoading
          ? Stack(
              children: [
                ModalBarrier(
                    dismissible: false, color: Colors.transparent),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : SizedBox(),
    ]);
  }

  Widget _buildFooter(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.7,
            child: ElevatedButton(
              onPressed: () async {
                String otp =
                    _controllers.map((controller) => controller.text).join();
                String tpin =
                    _TPinControllers.map((controller) => controller.text)
                        .join();
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
                    VerifyOtpTPinChange request = VerifyOtpTPinChange(
                      tpin: tpin,
                      otp: otp,
                    );
                    await Provider.of<MainViewModel>(context, listen: false)
                        .verifyOtpTPinChange(
                            "/api/v1/app/customers/change_tpin_using_otp",
                            request);

                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    verifyOtpTpinChange(context, apiResponse);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter otp and new TPIN.'),
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
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                //isKeypadVisible = true;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              width: screenWidth / 8.1,
              height: 58.0,
              child: Center(
                child: Text(
                  _inputOtpValues[index],
                  style: TextStyle(fontSize: 20),
                ),
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
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTpinInput(
      BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                // isKeypadVisible = true;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              width: screenWidth / 8.1,
              height: 58.0,
              child: Center(
                child: Text(
                  _inputTpinValues[index],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateOtp() async {
    const maxDuration = Duration(seconds: 2);
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
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
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .getOtpTPINChange("/api/v1/app/customers/initiate_change_tpin");

      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getOtpResponse(context, apiResponse);
    }
  }
}
