import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/Strings/Languages.dart';
import 'package:mvvm_flutter_app/model/request/createOtpEmailVerifyRequest.dart';
import 'package:mvvm_flutter_app/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:provider/provider.dart';

import '../../model/apis/api_response.dart';
import '../../model/response/createOtpForEmailVerifyResponse.dart';
import '../../model/response/profileResponse.dart';
import '../../utils/Helper.dart';
import '../../view_model/media_view_model.dart';

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

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    CreateOtpVerifyEmailResponse? mediaList =
        apiResponse.data as CreateOtpVerifyEmailResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.emailOtp}");
        // Navigate to the new screen after receiving the response
        //Navigator.pushNamed(context, '/BottomNav');
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

  Widget VerifyGetMediaWidget(BuildContext context, ApiResponse apiResponse) {
    final mediaList = apiResponse.data;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse.data}");
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
          Languages.of(context)!.labelVerifyEmail,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "We need to verify your email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Please provide a valid email address, as you will be prompted for confirmation.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Container(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter your email address",
                      border: OutlineInputBorder(),
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
                          if (emailController.text.isNotEmpty) {
                            CreateOtpEmailVerifyRequest request =
                                CreateOtpEmailVerifyRequest(
                                    customer: CustomerGetOtpEmailDetail(
                              phoneNumber: phoneNumber,
                              email: emailController.text,
                            ));
                            await Provider.of<MediaViewModel>(context,
                                    listen: false)
                                .CreateOtpVerifyEmail(
                                    "/api/v1/app/customers/generate_otp_for_email",
                                    request);
                            ApiResponse apiResponse =
                                Provider.of<MediaViewModel>(context,
                                        listen: false)
                                    .response;
                            getMediaWidget(context, apiResponse);
                          }
                        },
                        child: Container(
                          child: Text(Languages.of(context)!.labelSubmit, style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Enter the OTP sent to your email address"),
                    ),
                    _buildPhoneInput(context, screenWidth),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(

                        onPressed: () async {String otp =
                        _controllers.map((controller) => controller.text).join();
                          if (otp.isNotEmpty) {
                            VerifyOtpEmailVerifyRequest request =
                                VerifyOtpEmailVerifyRequest(
                                    customer: CustomerVerifyOtpEmail(
                              phoneNumber: phoneNumber,
                              email: emailController.text,
                              emailOtp: otp,
                            ));
                            await Provider.of<MediaViewModel>(context, listen: false)
                                .VerifyOtpVerifyEmail(
                                    "/api/v1/app/customers/verify_email_otp", request);
                            ApiResponse apiResponse =
                                Provider.of<MediaViewModel>(context, listen: false)
                                    .response;
                            VerifyGetMediaWidget(context, apiResponse);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                            alignment: Alignment.center,
                            child: Text("Validate")),
                      ),
                    ),
                    //Text("Your email has been successfully verified"),
                    /*TextButton(
                      onPressed: () {},
                      child: Text("Resend via SMS"),
                    ),*/
                  ],
                ),
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
