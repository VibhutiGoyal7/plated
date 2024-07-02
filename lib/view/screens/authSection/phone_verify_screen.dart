import 'package:flutter/material.dart';
import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/response/countryListResponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
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
  final ScrollController _scrollController = ScrollController();
  String phoneCode = "+";
  int countryCode = 0;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  bool phoneNumberValid = false;

  List<CountryData> countryList = [];

  @override
  void initState() {
    super.initState();
    phoneNumberValid = false;
    _fetchData();
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
        return Container();
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
    PhoneVerifyResponse? phoneVerifyResponse =
        apiResponse.data as PhoneVerifyResponse?;
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

  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = countryListResponse?.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[1].name}");

        countryList = countryListResponse!.countries!;

        //_showPicker(context: context);

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
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: sp,
          children:[
            Container(
              height: screenHeight*0.24,
              child:_buildLabelText(context, "Phone Verification", 28, true),
              alignment: AlignmentDirectional.center,
            ),

            Spacer(),
            Container(
              height: screenHeight*0.72,
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Padding(padding: EdgeInsets.all(12) ,child: _buildLabelText(
                        context, Languages.of(context)!.enterPhoneNumber, 18, true) ,),
                   
                    //SizedBox(height: 10),
                    _buildPhoneInput(context, isDarkMode),
                    Spacer(),
                    _buildFooter(context, apiResponse),
                  ],
                ),
              ),
            ),
            /*_buildLabelText(
                context, Languages.of(context)!.appName, 16, false),*/

          ],
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
      elevation:  2,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                _showPicker(context: context);
              },
              child: SizedBox(
                height: 60,
                width: 25,
                child: Center(
                  child: Text(
                    phoneCode,
                    style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
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
                  //   Provider.of<MainViewModel>(context, listen: false)
                  //       .setSelectedMedia(null);
                  //   Provider.of<MainViewModel>(context, listen: false)
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (phoneNumberValid && countryCode > 0 && phoneCode != "+") {
                  ExistingUserRequest request = ExistingUserRequest(
                      customer:
                          ExistingCustomer(phoneNumber: _inputController.text));
                  await Provider.of<MainViewModel>(context, listen: false)
                      .existingUserData(
                          "/api/v1/app/customers/check_customer_existance",
                          request);
                  /* PhoneRequest phoneRequest = PhoneRequest(
                      customer: Customer(
                          phoneNumber: _inputController.text, mobileOtp: ""));*/
                  /*await Provider.of<MainViewModel>(context, listen: false)
                    .fetchMediaData(
                        "/api/v1/app/temp_customers/initiate_customer",
                        phoneRequest);*/
                  //Navigator.pushNamed(context, '/OtpVerify', arguments: "${_inputController.text}");

                  ApiResponse apiResponse =
                      Provider.of<MainViewModel>(context, listen: false)
                          .response;
                  existingUserWidget(context, apiResponse);
                } else if (countryCode == 0 && phoneCode == "+") {
                  SnackBar(
                    content: Text(Languages.of(context)!.labelSelectCountryCode),
                  );
                } else {
                  SnackBar(
                    content: Text(Languages.of(context)!.labelEnterValidPhone),
                  );
                }
              },
              child: Text(
                Languages.of(context)!.labelSubmit,
                style: TextStyle(
                    color: phoneNumberValid ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      phoneNumberValid ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
            ),
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

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      isScrollControlled: false, // Ensure the sheet takes full height
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure minimal height
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,// Align start
            children: <Widget>[
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: countryList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 0),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: (phoneCode == "+${countryList[index].phoneCode}") ? AppColor.PRIMARY : Colors.white,
                    onTap: () {
                      setState(() {
                        phoneCode = "+${countryList[index].phoneCode}";
                        countryCode = countryList[index].id as int;
                      });
                      Navigator.of(context).pop();
                    },
                    leading: ClipRRect(
                      child: Image.network(
                        countryList[index].flagImageUrl as String,
                        height: 28,
                        width: 50,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.white30,
                              highlightColor: Colors.grey,
                              child: Container(
                                height: 28,
                                width: 50,
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          countryList[index].name as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (phoneCode == "+${countryList[index].phoneCode}") ? AppColor.WHITE : Colors.black,
                          ),
                        ),
                        Text(
                          "+${countryList[index].phoneCode}",
                          style: TextStyle(
                            fontSize: 12,
                            color: (phoneCode == "+${countryList[index].phoneCode}") ? AppColor.WHITE : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }



  void _phoneVerifyAPI() async {
    if (phoneNumberValid) {
      PhoneRequest phoneRequest = PhoneRequest(
          customer: Customer(
              phoneNumber: _inputController.text,
              mobileOtp: "",
              countryId: countryCode));
      await Provider.of<MainViewModel>(context, listen: false).fetchMediaData(
          "/api/v1/app/temp_customers/initiate_customer", phoneRequest);
      /*  Navigator.pushNamed(context, '/OtpVerify',
                    arguments: "${_inputController.text}");*/

      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getMediaWidget(context, apiResponse);
    }
  }

  void _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .fetchCountryList("api/v1/app/customers/country_list");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false)
            .response;
    getCountryList(context, apiResponse);
  }
}
