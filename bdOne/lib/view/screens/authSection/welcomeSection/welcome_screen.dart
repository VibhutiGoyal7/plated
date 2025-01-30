import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:BDOne/view/component/custom_button_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.PRIMARY,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(children: [
                Expanded(
                  child: Container(
                    //height: screenHeight,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: AppColor.BG_COLOR,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(28),
                              bottomRight: Radius.circular(28))),
                      child:Center(
                        child: Image(
                          width:screenWidth ,
                          image: AssetImage(isDarkMode
                              ? "assets/app_logo_dark.png"
                              : "assets/app_logo.png"),
                          fit: BoxFit.cover,
                        ),
                      ),),
                ),
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Languages.of(context)!.labelWelcome,
                            style: TextStyle(
                                fontSize: 24,
                                color: AppColor.WHITE,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "The app for food delivery, ride booking, travel planning, and more.",
                            style: TextStyle(
                                fontSize: 12, color: AppColor.WHITE),
                          ),
                        ],
                      ),SizedBox(height: 125,),
                      CustomButtonComponent(
                          text: Languages.of(context)!.labelContinue,
                          width: screenWidth,
                          isDarkMode: isDarkMode,
                          buttonColor: Colors.white,
                          textColor: AppColor.PRIMARY,
                          verticalPadding: 10,
                          onTap: () {
                            Navigator.pushNamed(context, '/SliderScreen');
                          }),
                    ],
                  ),
                )

              ]),
            ),
            SizedBox(
              height: 80,
            ),
            //Spacer(),

          ],
        ),
        isLoading
            ? Stack(
                children: [
                  // Block interaction
                  ModalBarrier(dismissible: false, color: Colors.white38),
                  // Loader indicator
                  Center(
                    child: CustomCircularProgress(),
                  ),
                ],
              )
            : SizedBox()
      ]),
    );
  }
}
