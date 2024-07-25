import 'package:Payrio/model/response/GenerateOtpTPINChangeResponse.dart';
import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/generateOtpTpinChange.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
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

  late double screenWidth;
  late double screenHeight;

  List<String> _inputValues = ['', '', '', ''];

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    generateOtp();
  }

  Future<Widget> verifyOtpTpinChange(
      BuildContext context, ApiResponse apiResponse) async {
    final response =
    apiResponse.data ;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:

       ToastComponent.showToast(context: context, message: "TPIN changed successfully.");

        Navigator.pushReplacementNamed(context, '/ProfileScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        }else {
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
    GenerateOtpTPINChangeResponse response =
    apiResponse.data ;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${response.otp}");
       ToastComponent.showToast(context: context, message: response.otp);


       return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        }else {
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
    return Scaffold(
      appBar: AppBar(toolbarHeight: 65,
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
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight * 0.9,
          child: SafeArea(
            child: Column(
              children: [
                /*Image(
                  alignment: Alignment.topLeft,
                  width: screenWidth*0.9,
                  height: screenHeight*0.4,
                  image: AssetImage("assets/payment_image.png"),
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
                SizedBox(height: 38,),
                Padding(padding: const EdgeInsets.all(12.0),
                  child: _buildLabelText(
                      context, "Enter the new 4 digit TPIN", 14, false),
                ),

                SizedBox(height: 12),
                _buildTpinInput(context, screenWidth, isDarkMode),
                Spacer(),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
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
                _TPinControllers.map((controller) => controller.text).join();
                const maxDuration = Duration(seconds: 2);
                if (otp.isNotEmpty && otp.length == 6 ) {
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
                            otp: otp,);
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
                      content: Text(
                          'Please enter otp and new TPIN.'),
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

  Widget _buildOtpInput(BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
              (index) => Container(
            decoration: BoxDecoration(
                border : Border(
                    top: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    bottom: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    right: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    left: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4)),
                borderRadius: BorderRadius.circular(6)
            ),
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            width: screenWidth/8.5,
            height: 60.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                  counterText: "", // Remove the counter text
                  border: InputBorder.none

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
              (index) => Container(
            decoration: BoxDecoration(
                border : Border(
                    top: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    bottom: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    right: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4),
                    left: BorderSide(color: isDarkMode? Colors.grey : Colors.black54, width: 0.4)),
                borderRadius: BorderRadius.circular(6)
            ),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            width: screenWidth/8,
            height: 60.0,
            child: TextField(
              controller: _TPinControllers[index],
              focusNode: _tPinFocusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                  counterText: "", // Remove the counter text
                  border: InputBorder.none

              ),
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                _onHandleTpinChange(index, value);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onHandleTpinChange(int index, String value) {
    setState(() {
      _inputValues[index] = value;
    });
    if (value.isNotEmpty) {
      if (index < _tPinFocusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_tPinFocusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_tPinFocusNodes[index - 1]);
      }
    }

    String otpString = _otp.join('');
    if (otpString.length == 6) {
      isValid = true;
    } else {
      isValid = false;
    }
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
          .getOtpTPINChange(
          "/api/v1/app/customers/initiate_change_tpin");

      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false)
              .response;
      getOtpResponse(context, apiResponse);
    }
  }


}
