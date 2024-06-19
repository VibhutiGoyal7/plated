import 'package:flutter/material.dart';
import 'package:payrio/model/request/verifyOtpChangePass.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/createOtpChangePass.dart';
import '../../../model/response/createOtpChangePassResponse.dart';
import '../../../view_model/media_view_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // final TextEditingController _isOtpBoxVisible = TextEditingController();

  final List<String> _otp = List.generate(6, (_) => '');
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  String dropdownValue = "";
  bool isValid = false;

  bool isLoading = false;
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

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    CreateOtpChangePassResponse? mediaList =
        apiResponse.data as CreateOtpChangePassResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse.message}");
        print("data: ${apiResponse?.data}");
        print("otp ${mediaList?.mobileOtp}");

        setState(() {
          isOtpBoxVisible = true;
        });

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  Future<Widget> verifyOtpGetWidget(BuildContext context, ApiResponse apiResponse) async {
    final mediaList = apiResponse.data ;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse?.data}");
        Navigator.pushNamed(context, '/ProfileScreen');

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildPhoneNumberTextField(),
              if (isOtpBoxVisible) _buildPhoneInput(context, screenWidth),
              if (isOtpBoxVisible) _buildPasswordTextFields(),
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
    );
  }

  Widget _buildPhoneNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              Languages.of(context)!.enterPhoneNumber,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              //labelText: 'Enter your phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                print(_phoneNumberController.text);

                CreateOtpChangePassRequest request = CreateOtpChangePassRequest(
                    customer: CustomerGetOtpPassDetail(
                  phoneNumber: _phoneNumberController.text,
                ));

                await Provider.of<MediaViewModel>(context, listen: false)
                    .CreateOtpChangePass(
                        "/api/v1/app/customers/generate_otp_for_forget_password",
                        request);
                ApiResponse apiResponse =
                    Provider.of<MediaViewModel>(context, listen: false)
                        .response;
                getMediaWidget(context, apiResponse);
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
  Widget _buildPasswordTextFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: Languages.of(context)!.labelNewPass,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: Languages.of(context)!.labelConfirmPass,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(BuildContext context, double screenWidth) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            width: screenWidth/8.5,
            height: 65.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(5.0))),
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


  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: ()async {
          String otp =
          _controllers.map((controller) => controller.text).join();
          if (otp.isNotEmpty) {
            print(_phoneNumberController.text);

            VerifyOtChangePassRequest request = VerifyOtChangePassRequest(
                customer: CustomerVerifyOtpPass(
                    phoneNumber: _phoneNumberController.text,
                    password: _newPasswordController.text,
                    mobileOtp: otp
                ));

            await Provider.of<MediaViewModel>(context, listen: false)
                .VerifyOtpChangePass(
                "/api/v1/app/customers/verify_otp_and_change_password", request);
            ApiResponse apiResponse =
                Provider
                    .of<MediaViewModel>(context, listen: false)
                    .response;
            verifyOtpGetWidget(context, apiResponse);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Text(
            Languages.of(context)!.labelSubmit,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
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
}

