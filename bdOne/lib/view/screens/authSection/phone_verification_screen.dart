import 'dart:io';

import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/model/request/signUpRequest.dart';
import 'package:BDOne/model/response/signUpResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/textfield_component.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/email_textfield_component.dart';
import '../../component/instruction_step.dart';
import '../../component/toastMessage.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  PhoneVerificationScreen({Key? key, this.data}) : super(key: key);

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<CountryData> countryList = [];
  File? docImg;
  bool isDarkMode = false;
  bool isChecked = false;
  String selectedItem = "";
  String selectedCountryFlag = "";
  Country? selectedCountry;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setInitialCountry();
    //_fetchData();
  }

  void setInitialCountry() {
    // Use a predefined country code to find the Country object
    final initialCountryCode = 'IN'; // Example: India
    selectedCountry = Country.tryParse(initialCountryCode);
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Create Account",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
              ),
            ),
            middle: Text(
              "Create Account",
              style: TextStyle(fontSize: 22,
                  color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
            ),
            backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
              ),
            ),
            alwaysShowMiddle: false,
            border:
            Border.all(color: Colors.transparent),
          ),

          SliverToBoxAdapter(
            child:Padding(
              padding: const EdgeInsets.only(top: 15.0,left:15,right: 15),
              child: Text(
                "${Languages.of(context)?.labelProvideMobileNoAndEmail}",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ) ,
          ),

          SliverToBoxAdapter(
            child:
            SizedBox(
              height: 10,
            ),
          ),

          SliverToBoxAdapter(
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Card(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                useSafeArea: true,
                                context: context,
                                showPhoneCode: true,
                                // Show phone code next to country
                                onSelect: (Country country) {
                                  setState(() {
                                    selectedItem = country.phoneCode;
                                    selectedCountryFlag = country.flagEmoji;
                                    selectedCountry == null;
                                  });
                                  print(
                                      'Selected country flag: ${country.flagEmoji}');
                                  print('Phone code: ${country.phoneCode}');
                                  print(
                                      'Country code: ${country.countryCode}');
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  selectedItem.isEmpty
                                      ? IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        SizedBox(width: 2),
                                        Text(
                                          selectedCountry != null
                                              ? "${selectedCountry?.flagEmoji}"
                                              : "",
                                          style:
                                          TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          selectedCountry != null
                                              ? "+${selectedCountry?.phoneCode}"
                                              : "+",
                                          style:
                                          TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                      : IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        SizedBox(width: 2),
                                        Text(
                                          "$selectedCountryFlag",
                                          style:
                                          TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "+$selectedItem",
                                          style:
                                          TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_sharp),
                                ],
                              ),
                            ),
                          ),
                          TextfieldComponent(
                              width: 0.64,
                              isPhone: true,
                              textController: _phoneNoController,
                              icon: Icon(
                                Icons.person,
                                size: 20,
                                color:
                                isDarkMode ? Colors.white : Colors.black,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              text: Languages.of(context)!.labelMobileNumber,
                              onChanged: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: EmailTextFieldComponent(
                  width: 1,
                  isPhone: false,
                  textController: _emailController,
                  icon: Icon(
                    Icons.mail,
                    size: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  text: Languages.of(context)!.labelEmail,
                  onChanged: () {}),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 380,),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                  child: CustomButtonComponent(
                      text: "${Languages.of(context)?.labelContinue}",
                      width: screenWidth,
                      isDarkMode: isDarkMode,
                      buttonColor: AppColor.PRIMARY,
                      textColor: Colors.white,
                      verticalPadding: 10,
                      onTap: () {
                        hideKeyBoard();
                        Future.delayed(Duration(milliseconds: 20));
                        //_hitSignUpApi();
                        if (_emailController.text.isNotEmpty &&
                            _phoneNoController.text.isNotEmpty) {
                          Helper.saveEmail(_emailController.text);
                          Helper.savePhoneNo(_phoneNoController.text);
                          Navigator.pushNamed(
                              context, "/OtpVerificationScreen",
                              arguments: "mobile");
                        } else {
                          ToastComponent.showToast(
                              context: context,
                              message: "Enter all the details.");
                        }
                      })),
            ) ,
          ),
        ], //<Widget>[]
      )
    );
  }

  void _hitSignUpApi() async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      SignUpRequest signUpRequest = SignUpRequest(
          customer: CustomerSignUp(
              email: "${_emailController.text.toString()}",
              phoneNumber: '${_phoneNoController.text.toString()}'));
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .signUpUsingMobileApi(
              "api/v1/mobile_app/customers/create_account", signUpRequest);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      signUpUsingMobile(context, apiResponse);
    }
  }

  Widget signUpUsingMobile(BuildContext context, ApiResponse apiResponse) {
    SignUpResponse? signUpResponse = apiResponse.data as SignUpResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print(
            "SignUpUsingMobile ${signUpResponse?.email} || ${signUpResponse?.phone_number}");
        Navigator.pushNamed(context, "/OtpVerificationScreen");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("SignUpUsingMobile ERROR");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        //ToastComponent.showToast(context: context, message: message);
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
}
