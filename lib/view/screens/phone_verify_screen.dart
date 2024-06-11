import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/Strings/Languages.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/model/signInWithPhoneNumber.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

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

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {

    Media? mediaList = apiResponse.data as Media?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.mobileOtp}");
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
              _buildLabelText(context, Languages.of(context)!.appName, 16, false),
              SizedBox(height: 4),
              _buildLabelText(context, Languages.of(context)!.enterPhoneNumber, 20, true),
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
    return Container(
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
              dropdownColor: isDarkMode ? Colors.grey: Colors.white,
              alignment: Alignment.center,
              value: dropdownValue,
              items: mCities.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  alignment: Alignment.center,
                  child: Text(
                    items,
                    style: TextStyle(fontSize: 14,
                    color: isDarkMode ? Colors.white: Colors.black),
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
              onSubmitted: (value) {
                // if (value.isNotEmpty) {
                //   Provider.of<MediaViewModel>(context, listen: false)
                //       .setSelectedMedia(null);
                //   Provider.of<MediaViewModel>(context, listen: false)
                //       .fetchMediaData(value, phoneRequest);
                // }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'XXXXXXXXXX',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
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
              PhoneRequest phoneRequest = PhoneRequest(
                  customer: Customer(
                      phoneNumber: _inputController.text, mobileOtp: ""));
              // Make the API call to fetch media data
              await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchMediaData(
                      "/api/v1/app/temp_customers/initiate_customer",
                      phoneRequest);
              //Navigator.pushNamed(context, '/OtpVerify', arguments: "${_inputController.text}");

              // Now that the API call is complete, update the UI based on the response
              ApiResponse apiResponse =
                  Provider.of<MediaViewModel>(context, listen: false).response;
              getMediaWidget(context, apiResponse);
             // Navigator.pushNamed(context, '/OtpVerify',
                //  arguments: "${_inputController.text}");
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
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
