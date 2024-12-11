import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';

class AccountRegisteredScreen extends StatefulWidget {
  @override
  _AccountRegisteredScreenState createState() =>
      _AccountRegisteredScreenState();
}

class _AccountRegisteredScreenState extends State<AccountRegisteredScreen> {
  String token = "";
  late double screenWidth;
  late bool isDarkMode;
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
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Success",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20,
                ),
                SlideView(),
                Spacer(),
                CustomButtonComponent(
                    text: "${Languages.of(context)?.labelDone}",
                    screenWidth: screenWidth * 0.8,
                    verticalPadding: 10,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pushNamed(context, '/BottomNav');
                    }),
                SizedBox(
                  height: 52,
                )
              ],
            ),
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

  Widget SlideView() {
    return Column(
      children: [
        Image(
          //alignment: Alignment.topLeft,
          width: screenWidth * 0.7,
          height: screenHeight * 0.33,
          image: AssetImage("assets/slide_1.png"),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          width: screenWidth * 0.6,
          child: Text(
            "Basic Account Registered",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: screenWidth * 0.7,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "You have successfully registered your BD Pass basic account",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color:isDarkMode? Colors.grey : Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: screenWidth * 0.6,
          child: Text(
            "Account : Basic",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 20,
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
