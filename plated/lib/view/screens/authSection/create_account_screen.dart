import 'package:Plated/languageSection/Languages.dart';
import 'package:Plated/utils/Helper.dart';
import 'package:Plated/view/component/custom_button_component.dart';
import 'package:Plated/view/screens/authSection/welcomeSection/instruction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  bool isInstruction = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    /* _controller = VideoPlayerController.asset(
      'assets/video.mp4',
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {
          _controller.setLooping(true); // Enable seamless looping
          _controller.play(); // Start playing immediately
        });
      });*/
    //_fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 70,),
                Image(
                  //alignment: Alignment.topLeft,
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  image: AssetImage("assets/slide_2.png"),
                ),
               /* Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image(
                    height: screenHeight * 0.08,
                    image: AssetImage(isDarkMode
                        ? "assets/app_logo_dark.png"
                        : "assets/app_logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),*/
                SizedBox(
                  height: 22,
                ),
                Text(
                  "Explore the app",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Experience unparalleled convenience with our app, offering food delivery, ride booking, travel planning, and more.",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 80,
                ),
                Center(
                    child: CustomButtonComponent(
                        text: "${Languages.of(context)?.labelCreateNewAccount}",
                        width: screenWidth,
                        isDarkMode: isDarkMode,
                        buttonColor: AppColor.PRIMARY,
                        textColor: Colors.white,
                        verticalPadding: 12,
                        onTap: () {
                          Navigator.pushNamed(context, "/PhoneVerifyScreen");
                        })),
                Center(
                  child: CustomButtonComponent(
                      text: "${Languages.of(context)?.labelHaveAnExistingAccount}",
                      width: screenWidth,
                      isDarkMode: isDarkMode,
                      buttonColor: AppColor.PRIMARY,
                      textColor: Colors.white,
                      verticalPadding: 12,
                      onTap: () {
                        Navigator.pushNamed(context, "/SignInScreen");
                      }),
                ),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CustomCircularProgress(),
                    ),
                  ],
                )
              : SizedBox()
        ]),
      ),
    );
  }

  Widget _buildExistingAccFooter(
      {required BuildContext context,
      required String text,
      required bool isDarkMode,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.94,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? Colors.white : Colors.black, width: 0.08),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

}
