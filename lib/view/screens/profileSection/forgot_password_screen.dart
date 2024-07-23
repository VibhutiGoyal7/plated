import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:Payrio/view/screens/authSection/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/createOtpChangePass.dart';
import '../../../model/response/createOtpChangePassResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  late double screenWidth;
  late double screenHeight;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  // final TextEditingController _isOtpBoxVisible = TextEditingController();

  final List<String> _otp = List.generate(6, (_) => '');
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  String dropdownValue = "";
  bool isValid = false;

  bool isOtpBoxVisible = false;
  bool timerUp = false;
  String responseMessage = '';
  String otp = '';

  @override
  void initState() {
    super.initState();
    isValid = false;
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
    super.dispose();
  }

  Future<Widget> generateOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CreateOtpChangePassResponse? mediaList =
        apiResponse.data as CreateOtpChangePassResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse.message}");
        print("data: ${apiResponse?.data}");
        print("otp ${mediaList?.mobileOtp}");

        ToastComponent.showToast(context: context, message: mediaList?.mobileOtp);
        ToastComponent.showToast(context: context, message: apiResponse?.message);

        setState(() {
          isOtpBoxVisible = true;
        });

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:

        if(apiResponse?.message== "Invalid access token"){
          SessionExpiredDialog.showDialogBox(context: context);}
        else{
          ToastComponent.showToast(context: context, message: apiResponse?.message);
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

  Future<Widget> verifyOtpGetWidget(BuildContext context, ApiResponse apiResponse) async {

    final mediaList = apiResponse.data ;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse?.data}");
        //Navigator.pushNamed(context, '/ProfileScreen');
        Helper.clearAllSharedPreferences();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SigninScreen()),
              (Route<dynamic> route) => false,
        );

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:

        if(apiResponse?.message== "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
          Languages.of(context)!.labelForgotPass,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Image(
                      alignment: Alignment.topLeft,
                      //width: screenWidth*0.8,
                      height: screenHeight * 0.22,
                      image: AssetImage("assets/forgot_password.png"),
                    ),
                  ),
                  _buildPhoneNumberTextField(),
                  if (isOtpBoxVisible)
                    _buildOtpInput(context, screenWidth, isDarkMode),
                  if (isOtpBoxVisible) _buildPasswordTextFields(isDarkMode),
                  SizedBox(height: 25),
                  if (isOtpBoxVisible) _buildSubmitButton(),
                  if (isLoading) CircularProgressIndicator(),
                  if (responseMessage.isNotEmpty)
                    Text(
                      responseMessage,
                      style: TextStyle(
                        color: responseMessage.contains('successfully')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              Languages.of(context)!.enterPhoneNumber,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: TextField(
                controller: _phoneNumberController,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {},
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //labelText: 'Enter your phone number',

                ),
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                print(_phoneNumberController.text);
                if (_phoneNumberController.text.isNotEmpty) {
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
                    CreateOtpChangePassRequest request =
                        CreateOtpChangePassRequest(
                            customer: CustomerGetOtpPassDetail(
                      phoneNumber: _phoneNumberController.text,
                    ));

                    await Provider.of<MainViewModel>(context, listen: false)
                        .CreateOtpChangePass(
                            "/api/v1/app/customers/generate_otp_for_forget_password",
                            request);
                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    generateOtpResponse(context, apiResponse);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter registered phone number'),
                      duration: maxDuration,
                    ),
                  );
                }
              },
              child: Text(
                Languages.of(context)!.labelSubmit,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPasswordTextFields(bool isDarkMode) {
    return Column(
      children: [
        _buildPasswordInput(
            context,
            Languages.of(context)!.labelNewPass,
            _newPasswordController,
            Icon(
              Icons.password,
              size: 18,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            newPasswordVisible,
            isDarkMode),
        _buildPasswordInput(
            context,
            Languages.of(context)!.labelConfirmPass,
            _confirmPasswordController,
            Icon(
              Icons.password,
              size: 18,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            confirmPasswordVisible,
            isDarkMode)
      ],
    );
  }
  Widget _buildPasswordInput(
      BuildContext context,
      String text,
      TextEditingController nameController,
      Icon icon,
      bool passwordVisibles,
      bool isDarkMode,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
      child: Card(
        child: Container(
          //height: 60,
          width: screenWidth*0.92,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 15.0),
                  obscureText: passwordVisibles,
                  obscuringCharacter: "*",
                  controller: nameController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    isInputValid();
                  },
                  onSubmitted: (value) {},
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: icon,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisibles
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                              () {if (text ==
                                Languages.of(context)!.labelNewPass) {
                              newPasswordVisible = !newPasswordVisible;
                            } else {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: InputBorder.none

              ),
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                _handleOnChange(index, value);
                isInputValid();
              },
            ),
          ),
        ),
      ),
    );
  }

  void isInputValid(){
    String otp =
    _controllers.map((controller) => controller.text).join();
    if (otp.isNotEmpty && otp.length ==6 && _newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text && _newPasswordController.text.length>=8) {
      isValid = true;
    }else{
      isValid = false;
    }
  }


  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width:  screenWidth * 0.7,
        child: ElevatedButton(
          onPressed: ()async {
            String otp =
            _controllers.map((controller) => controller.text).join();
            isInputValid();
            if (otp.isNotEmpty && _newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty &&
                _newPasswordController.text == _confirmPasswordController.text && _newPasswordController.text.length>=8) {

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
                print(_phoneNumberController.text);

                VerifyOtChangePassRequest request = VerifyOtChangePassRequest(
                    customer: CustomerVerifyOtpPass(
                        phoneNumber: _phoneNumberController.text,
                        password: _newPasswordController.text,
                        mobileOtp: otp));

                await Provider.of<MainViewModel>(context, listen: false)
                    .VerifyOtpChangePass(
                        "/api/v1/app/customers/verify_otp_and_change_password",
                        request);
                ApiResponse apiResponse =
                    Provider.of<MainViewModel>(context, listen: false).response;
                verifyOtpGetWidget(context, apiResponse);
              }
            }else if(_newPasswordController.text.length < 8){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password should have 8 or more characters.'),
                  duration: maxDuration,
                ),
              );

            }else if(_newPasswordController.text != _confirmPasswordController.text){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Password doesn't match"),
                  duration: maxDuration,
                ),
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please fill the details"),
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
}

