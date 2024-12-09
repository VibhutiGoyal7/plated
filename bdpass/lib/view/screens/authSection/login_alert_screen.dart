import 'dart:io';

import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class LoginAlertScreen extends StatefulWidget {
  @override
  _LoginAlertScreenState createState() => _LoginAlertScreenState();
}

class _LoginAlertScreenState extends State<LoginAlertScreen> {
  Uint8List? qrCodeImage;
  final picker = ImagePicker();
  bool isLoading = true;
  bool isDarkMode = false;
  late double screenWidth;
  late double screenHeight;
  late BDPassDatabase database;
  int? selectedNo;

  List<int> list = [1, 2, 3];
  static const maxDuration = Duration(seconds: 2);
  bool isTablet = false;

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    _fetchData();
    $FloorBDPassDatabase
        .databaseBuilder('payorio_database.db')
        .build()
        .then((value) async {
      this.database = value;
    });
  }

  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,
        ));
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
        await Helper.saveUserBalance(mediaList?.balance);
        await Helper.saveCountry(mediaList?.countryName);
        await Helper.saveKycStatus(mediaList?.kycStatus);
        print(mediaList?.countryName);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
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

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = getIsTablet(context, screenWidth, screenHeight);

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: screenWidth,
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                SizedBox(height: 40,),
                Text(
                  "Login Request Alert",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8,),
                Container(
                  width: screenWidth*0.9,
                  child: Text(
                    "If you did not initiate this request, please click on decline",
                    style: TextStyle(fontSize: 13,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 120,),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Select a number below that matches the number displayed on the login portal.",
                    style: TextStyle(fontSize: 14),textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: 58,
                    width: screenWidth,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      //controller: _scrollController,
                      itemCount: list.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        int item = list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedNo = item;
                              });
                            },
                            child: Card(
                              elevation: 0 ,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    color: selectedNo == item &&
                                            selectedNo != null
                                        ? AppColor.PRIMARY
                                        : Colors.grey[100]),
                                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 12),
                                child: Center(
                                  child: Text(
                                    "${item}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: selectedNo == item &&
                                                selectedNo != null
                                            ? AppColor.WHITE
                                            : isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        // I omit the part to build card items from the list
                      },
                    ),
                  ),
                  SizedBox(height: 300,),
                  Row(
                    children: [
                      _buildFooter("Decline", (){

                      }),
                      _buildFooter("Confirm", (){

                      }),

                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));

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
      String? retrievedToken = await Helper.getUserToken();
      print("Token $retrievedToken");
      if (mounted) {
        /*await Provider.of<MainViewModel>(context, listen: false)
            .profileScreenData("api/v1/app/customers/show_customer_details");*/
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getProfileResponse(context, apiResponse);
      }
    }
  }

  Widget _buildFooter(String text,Function() onTap){
    return  GestureDetector(
      onTap: onTap ,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: screenWidth * 0.42,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode
                    ? Colors.white
                    :Colors.black,
                width: 0.8),
            borderRadius: BorderRadius.circular(8),
            /*color: isDarkMode
                ? Colors.white
                : Colors.black*/),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
