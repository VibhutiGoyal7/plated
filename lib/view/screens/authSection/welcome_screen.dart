import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<CountryData> countryList = [];

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        Future.value(false);
        if (kDebugMode) {
          print("$didPop");
          SystemNavigator.pop();
          // return Future.value(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                Text("BD Pass",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 12,),
                /*Image(
                  //height: screenHeight * 0.35,
                  image: AssetImage(isDarkMode
                      ? "assets/app_logo_dark.png"
                      : "assets/app_logo.png"),
                  fit: BoxFit.cover,
                ),*/
                _build(),
                Spacer(),
                Row(
                  children: [
                    _buildFooter(
                        context: context,
                        text:"English",
                        onTap: () {
                          Navigator.pushNamed(context, '/SliderScreen');
                        }),
                    _buildFooter(
                        context: context,
                        text:"Continue",
                        onTap: () {
                          Navigator.pushNamed(context, '/SliderScreen');
                        }),
                  ],
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
                ModalBarrier(
                    dismissible: false, color: Colors.transparent),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
                : SizedBox()
          ]),
        ),
      ),
    );
  }

  Widget _build() {
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth * 0.7,
          height: screenHeight * 0.2,
          image: AssetImage("assets/payment_image.png"),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Mobile Based Secure Sign In",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Login and Sign up to many digital services with one account",
            style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildFooter(
      {required BuildContext context,
        required String text,
        required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Column(
        children: [
          SizedBox(
            width: screenWidth*0.45,
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

  void _fetchData() async {
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
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCountryList("api/v1/app/customers/country_list");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCountryList(context, apiResponse);
    }
  }


  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
    apiResponse.data as CountryListResponse?;
    var message = apiResponse?.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[1].name}");

        countryList = countryListResponse!.countries!;
        Helper.saveCountryList(countryList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";

        print("countriess ${countryList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${countryList}");
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
