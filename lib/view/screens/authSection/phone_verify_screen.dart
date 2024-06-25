import 'package:flutter/material.dart';
import '../../../languageSection/Languages.dart';
import 'package:payrio/model/apis/api_response.dart';
import 'package:payrio/model/request/signInWithPhoneNumber.dart';
import 'package:payrio/model/response/phoneVerifyResponse.dart';
import 'package:payrio/view/component/toastMessage.dart';
import 'package:payrio/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/request/exustingUserRequest.dart';
import '../../../model/response/existingUserResponse.dart';

class PhoneVerifyScreen extends StatefulWidget {
  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_PhoneVerifyScreenState>();
    state?.setLocale(newLocale);
  }
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  var mCities = ["+91", "+92", "+1", "+5", "+93"];
  String dropdownValue = "";
  bool phoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        mCities.first; // Initialize dropdownValue within the state class
    phoneNumberValid = false;
  }

  final TextEditingController _inputController = TextEditingController();

  void _isValidPhoneNumber(String input) {
    print(input);
    if (input.isNotEmpty && input.length >= 10) {
      setState(() {
        phoneNumberValid = true;
      });
    } else {
      setState(() {
        phoneNumberValid = false;
      });
    }
  }

  Widget existingUserWidget(BuildContext context, ApiResponse apiResponse) {
    ExistingUserResponse? mediaList = apiResponse.data as ExistingUserResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("userfound: ${mediaList?.userFound}");
        // Navigate to the new screen after receiving the response
        if (mediaList?.userFound == true) {
          Navigator.pushNamed(context, '/SignInScreen',
              arguments: "${_inputController.text}");
        } else {
          _phoneVerifyAPI();
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        _phoneVerifyAPI();
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

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    PhoneVerifyResponse? phoneVerifyResponse = apiResponse.data as PhoneVerifyResponse?;
    var message = phoneVerifyResponse?.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${phoneVerifyResponse?.mobileOtp}");
        //Call Toast
        ToastComponent.showToast(context: context, message: message);
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/OtpVerify',
            arguments: "${_inputController.text}");
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLabelText(
                  context, Languages.of(context)!.appName, 16, false),
              SizedBox(height: 4),
              _buildLabelText(
                  context, Languages.of(context)!.enterPhoneNumber, 20, true),
              SizedBox(height: 16),
              _buildPhoneInput(context, isDarkMode),
              Spacer(),
              _buildFooter(context, apiResponse),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildPhoneInput(BuildContext context, bool isDarkMode) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: isDarkMode ? Colors.grey : Colors.white,
                alignment: Alignment.center,
                value: dropdownValue,
                items: mCities.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    alignment: Alignment.center,
                    child: Text(
                      items,
                      style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    print(dropdownValue);
                  });
                },
                style: TextStyle(),
                hint: Text(
                  "+91",
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                ),
                controller: _inputController,
                onChanged: _isValidPhoneNumber,
                maxLength: 12,
                keyboardType: TextInputType.phone,
                onSubmitted: (value) {
                  // if (value.isNotEmpty) {
                  //   Provider.of<MediaViewModel>(context, listen: false)
                  //       .setSelectedMedia(null);
                  //   Provider.of<MediaViewModel>(context, listen: false)
                  //       .fetchMediaData(value, phoneRequest);
                  // }
                },
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'XXXXXXXXXX',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (phoneNumberValid) {
                ExistingUserRequest request = ExistingUserRequest(
                    customer: ExistingCustomer(
                        phoneNumber: _inputController.text));
                await Provider.of<MediaViewModel>(context, listen: false)
                    .existingUserData(
                        "/api/v1/app/customers/check_customer_existance",
                    request);
                  Navigator.pushNamed(context, '/OtpVerify',
                    arguments: "${_inputController.text}");
                PhoneRequest phoneRequest = PhoneRequest(
                    customer: Customer(
                        phoneNumber: _inputController.text, mobileOtp: ""));
                /*await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchMediaData(
                      "/api/v1/app/temp_customers/initiate_customer",
                      phoneRequest);*/
               //Navigator.pushNamed(context, '/OtpVerify', arguments: "${_inputController.text}");

                ApiResponse apiResponse =
                    Provider.of<MediaViewModel>(context, listen: false)
                        .response;
                existingUserWidget(context, apiResponse);
              }else{
                SnackBar(
                  content: Text("Enter valid Phone No"),
                );
              }
            },
            child: Text(
              Languages.of(context)!.labelSubmit,
              style: TextStyle(
                  color: phoneNumberValid ? Colors.white : Colors.blueAccent),
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor:
                    phoneNumberValid ? Colors.blueAccent : Colors.white,
                elevation: 3,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Languages.of(context)!.labelNeedHelp,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  void _phoneVerifyAPI() async {
    if (phoneNumberValid) {
      PhoneRequest phoneRequest = PhoneRequest(
          customer:
              Customer(phoneNumber: _inputController.text, mobileOtp: ""));
      await Provider.of<MediaViewModel>(context, listen: false).fetchMediaData(
          "/api/v1/app/temp_customers/initiate_customer", phoneRequest);
      /*  Navigator.pushNamed(context, '/OtpVerify',
                    arguments: "${_inputController.text}");*/

      ApiResponse apiResponse =
          Provider.of<MediaViewModel>(context, listen: false).response;
      getMediaWidget(context, apiResponse);
    }
  }
}
