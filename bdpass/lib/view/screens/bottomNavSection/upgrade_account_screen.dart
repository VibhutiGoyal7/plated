import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';

class UpgradeAccountScreen extends StatefulWidget {
  @override
  _UpgradeAccountScreenState createState() => _UpgradeAccountScreenState();
}

class ListItem {
  final IconData icon;
  final String instruction;
  final String title;
  final String subtitle;

  ListItem(this.icon, this.instruction, this.title, this.subtitle);
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
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
    // Sample list
    final List<ListItem> items = [
      ListItem(
          Icons.photo_camera_front_outlined,
          "Directly through device",
          "Face Verification",
          "Utilizing biometric face recognition to verify a person's identity."),
      ListItem(
          Icons.edit_location_alt_rounded,
          "Kiosk Visit Required",
          "Physical Kiosk",
          "Identity verification using Emirates ID and fingerprint biometrics"),
    ];

    return Scaffold(
        /* appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),*/
        body: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            "Upgrade Account",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
            ),
          ),
          middle: Text(
            "Upgrade Account",
            style: TextStyle(fontSize: 22,
                color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
          ),
          backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
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
        ),
        SliverToBoxAdapter(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Choose one of the following to upgrade your account",
                style: TextStyle(fontSize: 14),
              )),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushNamed(context, "/VerificationScreen");
                  }
                },
                child: _buildCard(item.icon, item.title, item.subtitle,
                    item.instruction, index),
              );
              //_buildCard(item.icon, item.title, item.subtitle);
            },
            childCount: items.length,
          ),
        ) //SliverList
      ], //<Widget>[]
    )
        /* SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Proceed As",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/VerificationScreen");
                  },
                  child: _buildCard(Icons.house_sharp, "Citizen or Resident",
                      "Individual holding ID issued by BD Government"),
                ),
                _buildCard(Icons.shopping_bag_outlined, "Visitor",
                    "Individual holding ID or passport issued countries other than BD"),
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
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox()
        ]),
      )*/
        );
  }

  Widget _buildCard(IconData icon, String heading, String detail,
      String instruction, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.brown,
                    size: 28,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instruction,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColor.PRIMARY),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        heading,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          width: screenWidth * 0.66,
                          child: Text(
                            detail,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.visible,
                          )),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  )

                ],
              ),
            ),
          ),
          index == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: screenWidth * 0.35,
                      height: 1,
                      color: AppColor.BLACK.withOpacity(0.2),
                    ),
                    Container(
                      child: Text(
                        "OR",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.35,
                      height: 1,
                      color: AppColor.BLACK.withOpacity(0.2),
                    ),
                  ],
                )
              : SizedBox()
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
