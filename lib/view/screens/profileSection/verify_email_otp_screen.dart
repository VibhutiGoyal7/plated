import 'package:Payrio/model/request/createOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/response/generateTpinResponse.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/createOtpForEmailVerifyResponse.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
import '../../component/session_expired_dialog.dart';

class VerifyEmailOtpScreen extends StatefulWidget {

  final String? data;

  VerifyEmailOtpScreen({Key? key, this.data}) : super(key: key);
  @override
  _VerifyEmailOtpScreenState createState() =>
      _VerifyEmailOtpScreenState();
}

class _VerifyEmailOtpScreenState extends State<VerifyEmailOtpScreen> {
  late TextEditingController emailController;

  //late TextEditingController otpController;
  String phoneNumber = "";

  final List<String> _otp = List.generate(6, (_) => '');
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  String dropdownValue = "";
  bool isValid = false;
  bool isOtpBoxVisible = false;

  List<String> _inputValues = ['', '', '', '', '', ''];
  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    isValid = false;
    _fetchData();

    emailController = TextEditingController();
    //otpController = TextEditingController();
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }

    _fetchData();
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
    super.dispose();
  }

  Widget getEmailOtp(BuildContext context, ApiResponse apiResponse) {
    CreateOtpVerifyEmailResponse? mediaList =
    apiResponse.data as CreateOtpVerifyEmailResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("emailOtp: ${mediaList?.emailOtp}");
        setState(() {
          isOtpBoxVisible = true;
        });
        ToastComponent.showToast(context: context, message: mediaList?.emailOtp);

        //Navigator.pushNamed(context, '/BottomNav');
        return Container();
      case Status.ERROR:
        if (apiResponse?.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(
              context: context, message: apiResponse.message);
        }
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

  Future<Widget> VerifyEmailResponse(
      BuildContext context, ApiResponse apiResponse) async {
    GenerateTpinResponse? generateTpinResponse = apiResponse.data as GenerateTpinResponse?;
    print("VerifyGetMediaWidget ${apiResponse?.message}");
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse.data}");
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/ProfileScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse?.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        }else
        {
          ToastComponent.showToast(context: context, message: message);
        }
        return Center(
          //child: Text('Please try again later!!!'),
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar ( toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelVerifyEmail,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Languages.of(context)!.labelEnterOtpSentToEmail),
                        ),
                        SizedBox(height: 20),
                        _buildPhoneInput(context, screenWidth, isDarkMode),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                        child: _buildVerifySection(isDarkMode))
                  ],
                ),
              ),
            ),
            isLoading
                ? Stack(
              children: [
                // Block interaction
                ModalBarrier(
                    dismissible: false,
                    color : Colors.black.withOpacity(0.3)),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput(
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

  Widget _buildVerifySection(bool isDarkMode) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        CustomNumberKeyboard(onKeyTap: (value) async {
          if (value == "clear") {
            _handleBackspace();
          } else if (value == "submit") {
            String otp = _inputValues.map((controller) => controller).join();
            if (otp.isNotEmpty && otp.length == 6) {
              /*String otp =
                                _controllers.map((controller) => controller.text).join();*/
              if (otp.isNotEmpty) {
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
                  VerifyOtpEmailVerifyRequest request =
                  VerifyOtpEmailVerifyRequest(
                      customer: CustomerVerifyOtpEmail(
                        phoneNumber: phoneNumber,
                        email: "${widget.data}",
                        emailOtp: otp,
                      ));
                  await Provider.of<MainViewModel>(context, listen: false)
                      .VerifyOtpVerifyEmail(
                      "/api/v1/app/customers/verify_email_otp", request);
                  ApiResponse apiResponse =
                      Provider.of<MainViewModel>(context, listen: false)
                          .response;
                  VerifyEmailResponse(context, apiResponse);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Enter otp sent on your email.'),
                    duration: maxDuration,
                  ),
                );
              }
            }
          } else {
            _handleKeyTap(value);
          }
        }),
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
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        phoneNumber = profileDetails!.phoneNumber!;
      });
    });
    return profileDetails;
  }
}
