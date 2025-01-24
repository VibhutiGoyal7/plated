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

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_button_component.dart';
import '../../../component/custom_circular_progress.dart';
import '../../../component/email_textfield_component.dart';
import '../../../component/toastMessage.dart';

class ChangeEmailScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  ChangeEmailScreen({Key? key, this.data}) : super(key: key);

  @override
  _ChangeEmailScreenState createState() =>
      _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  bool isDarkMode = false;
  bool isPinVerified = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body:CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "${Languages.of(context)?.labelVerificationDetails}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
              ),
            ),
            middle: Text(
              "${Languages.of(context)?.labelVerificationDetails}",
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical:10),
              child: Text(
                "Please provide your phone number",
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
            child: SizedBox(height: 480,),
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
                        if (_emailController.text.isNotEmpty) {
                          Helper.saveEmail(_emailController.text);
                          Navigator.pop(context);
                        } else {
                          ToastComponent.showToast(
                              context: context,
                              message: "Enter your email address.");
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
     /* SignUpRequest signUpRequest = SignUpRequest(
          customer: CustomerSignUp(
              email: "${_emailController.text.toString()}",
              phoneNumber: '${_phoneNoController.text.toString()}'));
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .signUpUsingMobileApi(
              "api/v1/mobile_app/customers/create_account", signUpRequest);*/
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
