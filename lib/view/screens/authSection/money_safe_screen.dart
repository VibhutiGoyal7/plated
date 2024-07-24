import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../theme/AppColor.dart';

class MoneySafeScreen extends StatefulWidget {
  @override
  _MoneySafeScreenState createState() => _MoneySafeScreenState();
}

class _MoneySafeScreenState extends State<MoneySafeScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop){
        Future.value(false);
        if (kDebugMode) {
          print("$didPop");
          SystemNavigator.pop();
          // return Future.value(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text(
                "Payrio",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.PRIMARY),
              ),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    getStartedScreen(),
                    moneyScreen(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: WormEffect(
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                    spacing: 16.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                  ),
                ),
              ),

              _buildFooter(
                  context: context,
                  text: "SignUp",
                  onTap: () {
                    Navigator.pushNamed(context, '/PhoneVerifyScreen');
                  }),

              _buildFooter(
                  context: context,
                  text: "SignIn",
                  onTap: () {
                    Navigator.pushNamed(context, '/SignInScreen', arguments: "");
                  }),
              SizedBox(height: 52,)
            ],
          ),
        ),
      ),
    );
  }

  Widget getStartedScreen(){
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth*0.9,
          height: screenHeight*0.38,
          image: AssetImage("assets/payment_image.png"),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Add your money and manage",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "The application for reaching your saving goal , send and receive money. Use QR codes and payment links to accept cards",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget moneyScreen(){
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth*0.9,
          height: screenHeight*0.4,
          image: AssetImage("assets/money_safe.png"),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "Your Money Stays Safe",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Your money stays safeWe have all security measures put in place, so that you really feel that your money is in safe hands.",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),

      ],
    );
  }

  Widget _buildFooter(
      {required BuildContext context,
      required String text,
      required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: AppColor.PRIMARY,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
    );
  }
}
