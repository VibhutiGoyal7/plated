import 'package:Plated/languageSection/Languages.dart';
import 'package:Plated/utils/Helper.dart';
import 'package:Plated/view/component/custom_button_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
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
      body: SafeArea(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  height: screenHeight * 0.06,
                  image: AssetImage(isDarkMode
                      ? "assets/app_logo_dark.png"
                      : "assets/app_logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: screenHeight * 0.45,
                alignment: Alignment.center,
                child: Center(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      firstSlide(),
                      secondSlide(),
                      thirdSlide(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 6.0,
                    dotWidth: 6.0,
                    spacing: 10.0,
                    dotColor: Colors.grey,
                    activeDotColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 5),
                child: CustomButtonComponent(
                    text: "${Languages.of(context)?.labelContinue}",
                    width: screenWidth,
                    isDarkMode: isDarkMode,
                    buttonColor: AppColor.PRIMARY,
                    borderRadius: 8,
                    textColor: Colors.white,
                    verticalPadding: 12,
                    onTap: () {
                      Navigator.pushNamed(context, '/CreateAccountScreen');
                    }),
              ),
              SizedBox(
                height: 52,
              )
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
      ),
    );
  }

  Widget firstSlide() {
    return Column(
      children: [
        Image(
          width: screenWidth * 0.9,
          height: screenHeight * 0.33,
          image: AssetImage("assets/slide_3.png"),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Travel",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Explore the world effortlessly with our travel section – book flights, hotels, and experiences in one place.",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget secondSlide() {
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth * 0.7,
          height: screenHeight * 0.35,
          image: AssetImage("assets/slide_2.png"),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "Food Delivery",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Crave it, order it! Our food app delivers your favorite dishes from top restaurants straight to your door.",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget thirdSlide() {
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth * 0.9,
          height: screenHeight * 0.33,
          image: AssetImage("assets/slide_3.png"),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "Transportation",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Ride smarter with our transportation app – book rides, track routes, and reach your destination safely and on time.",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
