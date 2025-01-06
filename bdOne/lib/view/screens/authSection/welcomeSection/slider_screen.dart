import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:BDOne/view/component/custom_button_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_loader.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Image(
                height: screenHeight * 0.055,
                image: AssetImage(isDarkMode
                    ? "assets/app_logo_dark.png"
                    : "assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
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
                      child: CustomLoader(),
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
          image: AssetImage("assets/slide_1.png"),
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
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomLoader());
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
