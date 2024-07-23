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
import '../../component/session_expired_dialog.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenContentState createState() =>
      _VerifyEmailScreenContentState();
}

class _VerifyEmailScreenContentState extends State<VerifyEmailScreen> {
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
        // Navigate to the new screen after receiving the response
        //Navigator.pushNamed(context, '/BottomNav');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse?.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(
              context: context, message: apiResponse?.message);
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelVerifyEmail,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      Languages.of(context)!.labelVerifyYourEmail,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Languages.of(context)!.verifyEmailSubTitle,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: Languages.of(context)!.labelEnterEmail,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            onPressed: () async {
                              if (emailController.text.isNotEmpty &&
                                  EmailValidator.validate(
                                      emailController.text)) {
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
                                  CreateOtpEmailVerifyRequest request =
                                      CreateOtpEmailVerifyRequest(
                                          customer: CustomerGetOtpEmailDetail(
                                    phoneNumber: phoneNumber,
                                    email: emailController.text,
                                  ));
                                  await Provider.of<MainViewModel>(context,
                                          listen: false)
                                      .CreateOtpVerifyEmail(
                                          "/api/v1/app/customers/generate_otp_for_email",
                                          request);
                                  ApiResponse apiResponse =
                                      Provider.of<MainViewModel>(context,
                                              listen: false)
                                          .response;
                                  getEmailOtp(context, apiResponse);
                                }
                              }
                            },
                            child: Container(
                              child: Text(
                                Languages.of(context)!.labelSubmit,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    if (isOtpBoxVisible) _buildVerifySection(isDarkMode)
                  ],
                ),
              ),
            ),
          ),
        ],
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
            width: screenWidth / 8.5,
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
            height: 60.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: InputBorder.none,
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

  Widget _buildVerifySection(bool isDarkMode) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Languages.of(context)!.labelEnterOtpSentToEmail),
        ),
        _buildPhoneInput(context, screenWidth, isDarkMode),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextButton(
            onPressed: () async {
              String otp =
                  _controllers.map((controller) => controller.text).join();
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
                    email: emailController.text,
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
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Enter otp sent on your email.'),
                    duration: maxDuration,
                  ),
                );
              }
            },
            child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Validate")),
          ),
        ),
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
