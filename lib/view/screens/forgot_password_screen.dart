import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_flutter_app/model/createOtpChangePass.dart';
import 'package:mvvm_flutter_app/model/verifyOtpChangePass.dart';
import 'package:provider/provider.dart';

import '../../model/apis/api_response.dart';
import '../../view_model/media_view_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
 // final TextEditingController _isOtpBoxVisible = TextEditingController();

  bool isLoading = false;
  bool isOtpBoxVisible = false;
  bool timerUp = false;
  String responseMessage = '';
  String otp = '';

  Future<Widget> getMediaWidget(BuildContext context, ApiResponse apiResponse) async {
    //ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse?.data}");
        setState(() {
          isOtpBoxVisible = true;

        });

        // Defer the state update until the next frame

        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/AccountDetailScreen');
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



  void _submitOtp() {
    if (_otpController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text) {
      setState(() {
        isLoading = true;
      });

      // Simulate an async operation for verifying OTP
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          responseMessage = 'Password changed successfully!';
        });
      });
    }
  }

  void _resendOtp() {
    if (timerUp && _phoneNumberController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Simulate an async operation for resending OTP
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          timerUp = false; // Reset timer
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              _buildPhoneNumberTextField(),
              if (isOtpBoxVisible) _buildOtpBox(),
              if (isOtpBoxVisible) _buildPasswordTextFields(),
              SizedBox(height: 25),
              if (isOtpBoxVisible) _buildSubmitButton(),
              if (isLoading) CircularProgressIndicator(),
              if (responseMessage.isNotEmpty)
                Text(
                  responseMessage,
                  style: TextStyle(
                    color: responseMessage.contains('successfully') ? Colors.green : Colors.red,
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
              'Phone Number',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
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
              onPressed: ()async {
                print(_phoneNumberController.text);

                CreateOtpChangePassRequest request = CreateOtpChangePassRequest(customer: CustomerGetOtpPassDetail(
                  phoneNumber: _phoneNumberController.text,
                ));

                await Provider.of<MediaViewModel>(context, listen: false)
                    .CreateOtpChangePass("/api/v1/app/customers/generate_otp_for_forget_password",request);
                ApiResponse apiResponse =
                    Provider.of<MediaViewModel>(context, listen: false).response;
                getMediaWidget(context, apiResponse);
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Enter the OTP which we have sent to your phone number',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 50,
                child: TextField(
                 // decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    otp += value;
                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Text('You can resend code in ', style: TextStyle(fontSize: 14, color: Color(0XFF7f9391))),
              _CountdownTimerApp(onTimerUp: () {
                setState(() {
                  timerUp = true;
                });
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: _resendOtp,
            child: Text(
              'Resend via SMS',
              style: TextStyle(color: timerUp ? Theme.of(context).primaryColor : Colors.grey),
            ),
          ),
        ),
      ],
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
              labelText: 'New Password',
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
              labelText: 'Confirm Password',
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

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: ()async {
          print(_phoneNumberController.text);

          VerifyOtChangePassRequest request = VerifyOtChangePassRequest(customer: CustomerVerifyOtpPass(
            phoneNumber: _phoneNumberController.text,
            password: _newPasswordController.text,
            mobileOtp: _otpController.text
          ));

          await Provider.of<MediaViewModel>(context, listen: false)
              .VerifyOtpChangePass("/api/v1/app/customers/verify_otp_and_change_password",request);
          ApiResponse apiResponse =
              Provider.of<MediaViewModel>(context, listen: false).response;
          getMediaWidget(context, apiResponse);
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
            'Submit',
            style: TextStyle(
              color: Colors.white, // Ensure the text color contrasts with the button color
              fontSize: 16, // Adjust the font size as needed
            ),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
        ),
      ),
    );
  }
}

class _CountdownTimerApp extends StatelessWidget {
  final VoidCallback onTimerUp;

  _CountdownTimerApp({required this.onTimerUp});

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:59', // Placeholder for actual timer
      style: TextStyle(color: Colors.red),
    );
  }
}
