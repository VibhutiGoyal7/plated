import 'package:Payrio/model/request/createOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/response/generateTpinResponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/createOtpForEmailVerifyResponse.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/customNumberKeyboard.dart';
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
    Helper.getProfileDetails().then((profile){
      emailController.text = "${profile?.email}";
    });
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
       /* setState(() {
          isOtpBoxVisible = true;
        });*/
        ToastComponent.showToast(context: context, message: mediaList?.emailOtp);
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/VerifyEmailOtpScreen', arguments: emailController.text);
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse?.message == "${Languages.of(context)?.labelInvalidAccessToken}") {
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
        if (apiResponse?.message == "${Languages.of(context)?.labelInvalidAccessToken}") {
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
      body: Stack(
        children: [

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
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                            enabled: false,
                            style: TextStyle(
                              color: isDarkMode? AppColor.WHITE : AppColor.BLACK
                            ),
                            decoration: InputDecoration(
                              hintText: Languages.of(context)!.labelEnterEmail,
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
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(AppColor.PRIMARY),
                            ),
                            onPressed: () async {
                              hideKeyBoard();
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
                                        content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
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
                              }else {
                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                    Text('Enter valid email.'),
                                    duration: maxDuration,
                                  ),
                                );

                              }
                            },
                            child: Container(
                              child: Text(
                                Languages.of(context)!.labelSubmit,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    //if (isOtpBoxVisible) _buildVerifySection(isDarkMode)
                  ],
                ),
              ),
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
                        content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
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
                        content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
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
