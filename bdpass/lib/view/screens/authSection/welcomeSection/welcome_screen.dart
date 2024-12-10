import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_loader.dart';

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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark),
        child: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(children: [
                    SizedBox(
                      height: 80,
                    ),
                    Image(
                      height: screenHeight * 0.25,
                      image: AssetImage(isDarkMode
                          ? "assets/app_logo_dark.png"
                          : "assets/app_logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                //Spacer(),
                Expanded(
                  child: Container(
                      //height: screenHeight,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: AppColor.PRIMARY,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
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
                                "${Languages.of(context)?.labelNationalDigitalIdentityForAllCitizens}",
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.WHITE),
                              ),
                            ],
                          ),
                          CustomButtonComponent(
                              text: Languages.of(context)!.labelContinue,
                              screenWidth: screenWidth,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                Navigator.pushNamed(context, '/SliderScreen');
                              }),
                        ],
                      )),
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
    var message = apiResponse.message.toString();
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
