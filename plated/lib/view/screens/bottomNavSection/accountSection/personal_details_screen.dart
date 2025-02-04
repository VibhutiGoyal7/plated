import 'dart:io';

import 'package:Plated/languageSection/Languages.dart';
import 'package:Plated/model/request/signUpRequest.dart';
import 'package:Plated/model/response/signUpResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/circluar_profile_image.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  PersonalDetailsScreen({Key? key, this.data}) : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  File? docImg;
  bool isDarkMode = false;
  bool isPinVerified = false;
  var imageUrl;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    //_fetchData();
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
            "Personal Details",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColor.TEXT_COLOR),
          ),
          middle: Text(
            "Personal Details",
            style: TextStyle(
                fontSize: 22,
                color: isDarkMode ? Colors.white : AppColor.TEXT_COLOR),
          ),
          backgroundColor:
              isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
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
          border: Border.all(color: Colors.transparent),
        ),
        SliverToBoxAdapter(
            child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                CircularProfileImage(
                  size: 50,
                  imageUrl: imageUrl,
                  name: "Akash Singh",
                  needTextLetter: true,
                  placeholderImage: "",
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Akash Singh",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 4, bottom: 4),
            child: Text(
              "Personal Details",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text("019876543210"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/ChangePhoneNoScreen");
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit,
                            size: 22,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email Address",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text("akash@gmail.com"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/ChangeEmailScreen");
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit,
                            size: 22,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ], //<Widget>[]
    ));
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
