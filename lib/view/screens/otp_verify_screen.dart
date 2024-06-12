import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/utils/Helper.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Strings/Languages.dart';
import '../../model/otpVerifyResponse.dart';
import '../../model/signInWithPhoneNumber.dart';

class OTPVerifyScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  OTPVerifyScreen({Key? key, this.data}) : super(key: key);

  @override
  _OTPVerifyScreenState createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String dropdownValue = "";
  bool isValid = false;

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

  void _isValidOtp(String input) {
    print(input);
    if (input.isNotEmpty && input.length >= 10) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    OtpVerifyResponse? mediaList = apiResponse.data as OtpVerifyResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("OtpVerify ${mediaList?.token}");
        final prefs = await SharedPreferences.getInstance();
        String token = "${mediaList?.token}";
        Navigator.pushNamed(context, '/SetUpAccount');
        // Save the token
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        Helper.getUserToken();
        // Retrieve the token
        String? retrievedToken = await Helper.getUserToken();
        print('Retrieved Token: $retrievedToken');
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/SetUpAccount');
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
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;
    return Scaffold(
      body: Container(
        width: screenWidth,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildLabelText(
                    context, Languages.of(context)!.labelWelcome, 16, false),
                SizedBox(height: 4),
                _buildLabelText(
                    context, Languages.of(context)!.labelEnterCode, 20, true),
                SizedBox(height: 4),
                _buildLabelText(
                    context,
                    "${Languages.of(context)!.labelSentCode} ${widget.data}",
                    12,
                    false),
                SizedBox(height: 22),
                _buildPhoneInput(context, screenWidth),
                SizedBox(height: 18),
                _buildLabelText(
                    context,
                    "${Languages.of(context)!.labelResendCode} 00:00",
                    14,
                    true),
                Spacer(),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
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
            width: screenWidth / 8.5,
            height: 65.0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
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

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Languages.of(context)!.labelTandC,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              String otp =
                  _controllers.map((controller) => controller.text).join();
              PhoneRequest phoneRequest = PhoneRequest(
                  customer: Customer(
                      phoneNumber: widget.data.toString(), mobileOtp: otp));
              // Make the API call to fetch media data
               /*await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchOtpVerifyData(
                      "/api/v1/app/temp_customers/verify_customer_mobile_otp_for_signup",
                      phoneRequest);*/

              // Now that the API call is complete, update the UI based on the response
              ApiResponse apiResponse =
                  Provider.of<MediaViewModel>(context, listen: false).response;
              //getMediaWidget(context, apiResponse);
              Navigator.pushNamed(context, '/SetUpAccount');
            },
            child: Text(
              Languages.of(context)!.labelValidate,
              style:
                  TextStyle(color: isValid ? Colors.white : Colors.blueAccent),
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: isValid ? Colors.blueAccent : Colors.white,
                elevation: 3,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
        SizedBox(
          height: 24,
        )
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

    String otpString = _otp.join('');
    if (otpString.length == 6) {
      // OTP length is 6, perform your action
      isValid = true;
      // You can also validate the OTP here or enable a submit button
    } else {
      isValid = false;
    }
  }

  void _handleBackspace() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].text = '';
        break;
      } else if (i > 0 && _controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        break;
      }
    }
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
