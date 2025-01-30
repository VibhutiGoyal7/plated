import 'dart:async';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/response/dashboardResponse.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/response/ServiceTypeResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/banner_list_widget.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/dashboard_category_component.dart';
import '../../component/session_expired_dialog.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String? country;
  String calledShortCut = "";
  String? name = "";
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  late int? userId;
  var imageUrl;
  late BDOneDatabase database;
  late DashboardTransactionDao dashboardTransactionDao;
  late CustomerDataDao customerDataDao;
  static const maxDuration = Duration(seconds: 2);
  bool isLoading = false;
  bool isCategoryLoading = false;
  bool isBannerLoading = false;
  bool isApiLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  var isVerified = false;
  late double screenHeight;
  late double screenWidth;
  final ConnectivityService _connectivityService = ConnectivityService();
  TextEditingController _searchController = TextEditingController();
  List<ServiceTypeResponse?> categories = [
    ServiceTypeResponse(
        serviceName: 'BD Mart',
        icon: 'assets/mart_icon.svg',
        iconBgColor: Colors.red.shade50),
    ServiceTypeResponse(
        serviceName: 'Cab Booking',
        icon: 'assets/cab_icon.svg',
        iconBgColor: Colors.yellow.shade50),
    ServiceTypeResponse(
        serviceName: 'Foods',
        icon: 'assets/food_icon.svg',
        iconBgColor: Colors.green.shade50),
    ServiceTypeResponse(
        serviceName: 'Shopping',
        icon: 'assets/shopping_icon.svg',
        iconBgColor: Colors.blue.shade50),
    ServiceTypeResponse(
        serviceName: 'More',
        icon: 'assets/more_icon.svg',
        iconBgColor: Colors.black12),
  ];
  List<String> bannerList = ["", "", "", ""];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];
  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    receiver.start();
    receiver.messages.listen((message) {
      print("BroadCast");
    });

    Helper.getProfileDetails().then((profile) {
      setState(() {
        name = profile?.firstName;
        imageUrl = profile?.imageUrl;
        country = profile?.countryName;
        userId = profile?.userId;
      });
    });

    intializeDatabase();
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.languageCode;

    print("isoCountryCode:: $isoCountryCode");

    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < bannerList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0; // Loop back to the first page
        }

        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    receiver.stop();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    DateTime? lastBackPressed;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        print("DashBoard $didPop");
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          print("$didPop");
          final now = DateTime.now();
          const maxDuration = Duration(seconds: 2);
          final isWarning = lastBackPressed == null ||
              now.difference(lastBackPressed!) > maxDuration;

          if (isWarning) {
            lastBackPressed = DateTime.now();
            _showExitDialog();
          } else {
            SystemNavigator.pop();
          }
          // return Future.value(true);
        } else {
          print("$didPop");
          final now = DateTime.now();
          const maxDuration = Duration(seconds: 2);
          final isWarning = lastBackPressed == null ||
              now.difference(lastBackPressed!) > maxDuration;
          if (isWarning) {
            lastBackPressed = DateTime.now();
            _showExitDialog();
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            print("Refresh");
            return Future.delayed(Duration(seconds: 2), () {});
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            /*Container(
                              height: screenHeight * 0.28,
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                  color: AppColor.PRIMARY,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0))),
                            ),*/
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    /* Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 6),
                                        child: CustomDropdown(
                                          title: "Food",
                                          items: [
                                            "Food",
                                            "Travel",
                                            "Transportation",
                                          ], // List of options
                                          onItemSelected: (value) {
                                            if (value == "Transportation") {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  "/TransportationBottomNav");
                                            } else if (value == "Travel") {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  "/TravelBottomNav");
                                            }
                                          },
                                        ),
                                      ),
                                    ),*/
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.support_agent,
                                            size: 28,
                                          ),
                                          onPressed: () => {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.notifications,
                                            size: 26,
                                          ),
                                          onPressed: () => {},
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    /* SearchComponent(
                                        width: 1,
                                        screenWidth: screenWidth,
                                        isDarkMode: isDarkMode,
                                        searchController: _searchController,
                                        onChanged: () {}),*/
                                    Container(
                                      width: screenWidth,
                                      constraints: BoxConstraints(
                                          minHeight: screenHeight * 0.1,
                                          maxHeight: screenHeight * 0.1),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        //AppColor.PRIMARY_GREEN,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                            offset: Offset(0, 0),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Hello ALI".toUpperCase(),
                                                style: TextStyle(
                                                    letterSpacing: 0.2,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.waving_hand,
                                                size: 14,
                                                color: Colors.orangeAccent,
                                              )
                                            ],
                                          ),
                                          Text(
                                            "What you are looking for today",
                                            style: TextStyle(
                                                fontSize: 18,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /*SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              // First Row
                                              Row(
                                                children: categories
                                                    .asMap()
                                                    .entries
                                                    .where((entry) => entry.key % 2 == 0) // Items for Row 1
                                                    .map((entry) =>  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Container(
                                                      width: 50,
                                                      padding: EdgeInsets.only(bottom: 8, top: 2, left: 2, right: 2),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          CircularProfileImage(
                                                              size: 48,
                                                              imageUrl: "",
                                                              name: "${entry.value}",
                                                              needTextLetter: true,
                                                              placeholderImage: ""),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                                            child: Text(
                                                              capitalizeFirstLetter("${entry.value}"),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ))
                                                    .toList(),
                                              ),
                                              // Second Row
                                              Row(
                                                children: categories
                                                    .asMap()
                                                    .entries
                                                    .where((entry) => entry.key % 2 == 1) // Items for Row 2
                                                    .map((entry) => Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Container(
                                                      width: 50,
                                                      padding: EdgeInsets.only(bottom: 8, top: 2, left: 2, right: 2),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          CircularProfileImage(
                                                              size: 48,
                                                              imageUrl: "",
                                                              name: "${entry.value}",
                                                              needTextLetter: true,
                                                              placeholderImage: ""),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                                            child: Text(
                                                              capitalizeFirstLetter("${entry.value}"),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ))
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),*/
                                    categories.length > 0
                                        ? DashboardCategoryComponent(
                                            categories: categories,
                                            screenWidth: screenWidth,
                                            screenHeight: screenHeight,
                                            isDarkMode: isDarkMode,
                                            primaryColor: AppColor.PRIMARY,
                                          )

                                        /*IntrinsicHeight(
                                            child: Container(

                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                color: AppColor.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.1),
                                                    offset: Offset(0, 0),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    4.0,
                                                                vertical: 4),
                                                        child: Text(
                                                          "Services",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12),
                                                        alignment:
                                                            Alignment.center,
                                                        constraints: BoxConstraints(
                                                            maxWidth: screenWidth,
                                                            maxHeight: isCategoryLoading
                                                                ? screenHeight * 0.13
                                                                : categories.isEmpty
                                                                    ? 0
                                                                    : 80),
                                                        child: isCategoryLoading
                                                            ? Container(
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount:
                                                                            3,
                                                                        scrollDirection: Axis
                                                                            .horizontal,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                2),
                                                                        itemBuilder:
                                                                            (context, index) {
                                                                          return Shimmer.fromColors(
                                                                            baseColor: Colors.white38,
                                                                            highlightColor: Colors.grey,
                                                                            child: Container(
                                                                              margin: EdgeInsets.all(6),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(80),
                                                                              ),
                                                                              height: 50,
                                                                              width: 60,
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : categories.isEmpty
                                                                ? SizedBox()
                                                                : DashboardCategoryComponent(
                                                                    categories:
                                                                        categories,
                                                                    screenWidth:
                                                                        screenWidth,
                                                                    screenHeight:
                                                                        screenHeight,
                                                                    isDarkMode:
                                                                        isDarkMode,
                                                                    primaryColor:
                                                                        AppColor
                                                                            .PRIMARY,
                                                                  )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )*/
                                        : SizedBox(),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      child: BannerListWidget(
                                          data: bannerList,
                                          isInternetConnected:
                                              isInternetConnected,
                                          isLoading: isBannerLoading,
                                          isDarkMode: isDarkMode,
                                          dummy: "assets/add_1.png"),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      child: BannerListWidget(
                                          data: bannerList,
                                          isInternetConnected:
                                              isInternetConnected,
                                          isLoading: isBannerLoading,
                                          isDarkMode: isDarkMode,
                                          dummy: "assets/add_2.png"),
                                    ),
                                    /*  Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "Brands you love!",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight:
                                                    FontWeight.normal),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          spacing: 6,
                                          alignment: WrapAlignment.start,
                                          runSpacing: 8,
                                          children: brandsList.map(
                                            (result) {
                                              var currentCategoryName =
                                                  result;
                                              return _brandYouLoveCard(
                                                  currentCategoryName);
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "Brand Offers",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight:
                                                    FontWeight.normal),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          spacing: 6,
                                          alignment: WrapAlignment.start,
                                          // Horizontal space between items
                                          runSpacing: 8,
                                          // Vertical space between lines
                                          children: brandsList.map(
                                            (result) {
                                              var currentCategoryName =
                                                  result;
                                              return _brandOfferCard(
                                                  currentCategoryName);
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 12),
                                      width: screenWidth,
                                      height: screenHeight * 0.16,
                                      child: PageView.builder(
                                        controller: _pageController,
                                        onPageChanged: (int page) {
                                          setState(() {
                                            _currentPage = page;
                                          });
                                        },
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: bannerList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return Container(
                                            width: screenWidth * 0.85,
                                            child: Center(
                                                child: Card(
                                              color: Colors.white
                                                  .withOpacity(0.8),
                                              */ /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.cir  cular(17))*/ /*
                                              margin: EdgeInsets.zero,
                                              child: Stack(
                                                children: [
                                                  bannerList[index] == ""
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(15),
                                                                  color: AppColor
                                                                      .PRIMARY),
                                                          child: ClipRRect(
                                                            // borderRadius: BorderRadius.circular(15),
                                                            child:
                                                                Image.asset(
                                                              "assets/travel_img.jpg",
                                                              width:
                                                                  screenWidth *
                                                                      0.85,
                                                              height:
                                                                  screenHeight *
                                                                      0.28,
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                width: 0.3),
                                                            color: isDarkMode
                                                                ? AppColor
                                                                    .DARK_CARD_COLOR
                                                                : Colors
                                                                    .white,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child:
                                                                Image.network(
                                                              "${bannerList[index]}",
                                                              width:
                                                                  screenWidth,
                                                              height:
                                                                  screenHeight *
                                                                      0.28,
                                                              fit: BoxFit
                                                                  .cover,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                return Container(
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/travel_img.jpg",
                                                                    width: screenWidth *
                                                                        0.85,
                                                                    height:
                                                                        screenHeight *
                                                                            0.2,
                                                                    fit: BoxFit
                                                                        .none,
                                                                  ),
                                                                );
                                                              },
                                                              loadingBuilder: (BuildContext
                                                                      context,
                                                                  Widget
                                                                      child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                } else {
                                                                  return Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        Colors
                                                                            .white38,
                                                                    highlightColor: isDarkMode
                                                                        ? AppColor
                                                                            .DARK_CARD_COLOR
                                                                        : Colors
                                                                            .grey,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: isDarkMode
                                                                              ? AppColor.DARK_CARD_COLOR
                                                                              : Colors.white,
                                                                          borderRadius: BorderRadius.circular(0)),
                                                                      width:
                                                                          screenWidth,
                                                                      height: screenHeight *
                                                                          0.25,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            )),
                                          );
                                          // I omit the part to build card items from the list
                                        },
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                isApiLoading
                    ? Stack(
                        children: [
                          // Block interaction
                          ModalBarrier(
                              dismissible: false, color: Colors.transparent),
                          // Loader indicator
                          Center(
                            child: CustomCircularProgress(),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandOfferCard(String currentCategoryName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, "/MenuScreen", arguments: data);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey, width: 0.3),
              color: isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.white),
          width: screenWidth * 0.48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  child: Image.asset(
                    "assets/pizza_image.jpg",
                    height: screenHeight * 0.23,
                    width: screenWidth * 0.48,
                    fit: BoxFit.cover,
                  )),
              Container(
                width: screenWidth * 0.48,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: Center(
                    child: Text(
                      capitalizeFirstLetter("${currentCategoryName}"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandYouLoveCard(String currentCategoryName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, "/MenuScreen", arguments: data);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey, width: 0.3),
              color: isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.white),
          width: screenWidth * 0.3,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight: Radius.circular(10)),
                  child: Image.asset(
                "assets/pizza_image.jpg",
                height: screenHeight * 0.1,
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  capitalizeFirstLetter("${currentCategoryName}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDashBoardDataFromApi() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = false;
        isInternetConnected = false;
        receiver.stop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      if (mounted) {
        //await Future.delayed(Duration(milliseconds: 1));
        await Provider.of<MainViewModel>(context, listen: false)
            .dashboardData("/api/v1/app/customers/dashboard_data");
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getDashboardData(context, apiResponse);
      }
    }
  }

  Future<void> _showExitDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Border.all(),
          title: Center(
              child: Text(
            "${Languages.of(context)?.labelExit}",
            style: TextStyle(fontSize: 20),
          )),
          content: Container(
            height: screenHeight * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColor.PRIMARY),
                        child: Icon(
                          Icons.logout_outlined,
                          size: 55,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Text(
                      Languages.of(context)!.labelPressBackToExit,
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: screenWidth * 0.6,
                      child: TextButton(
                        child: Text('Naah, Just kidding'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.6,
                      child: TextButton(
                        child: Text('${Languages.of(context)?.labelYes}'),
                        onPressed: () async {
                          /*Helper.clearAllSharedPreferences();
                          database.personDao.clearAllCustomerDetails();
                          database.dashboardTransactionDao
                              .clearAllTransactions();*/
                          Navigator.of(context).pop();
                          await Future.delayed(Duration(milliseconds: 6));
                          SystemNavigator.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  Future<void> intializeDatabase() async {
    database = await $FloorBDOneDatabase
        .databaseBuilder('bd_pass_database.db')
        .build();

    dashboardTransactionDao = database.dashboardTransactionDao;
    customerDataDao = database.personDao;
  }

  Future<Widget> getDashboardData(
      BuildContext context, ApiResponse apiResponse) async {
    DashboardResponse? dashboardResponse =
        apiResponse.data as DashboardResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("GetDashboardData : ${dashboardResponse?.customerData?.email}");

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          if (receiver.isListening) {
            receiver.stop();
          }
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          Helper.getProfileDetails().then((userDetails) {
            setState(() {
              print("userDetails?.imageUrl${userDetails?.imageUrl}");
              name = userDetails?.firstName == null
                  ? Languages.of(context)!.labelName
                  : userDetails?.firstName;
              imageUrl =
                  userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
              print("imageUrl${imageUrl}");
            });
            Helper.saveUserId("${userDetails?.userId}");
          });
        }
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  Widget getKycStatus(BuildContext context, ApiResponse apiResponse) {
    KycStatusResponse? kycStatusResponse =
        apiResponse.data as KycStatusResponse?;
    var message = apiResponse.message.toString();
    setState(() {
      isApiLoading = false;
    });
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("GetKycStatus : ${kycStatusResponse?.kycStatus}");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(
              context: context, message: apiResponse.message);
        }
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Loading...'),
        );
    }
  }
}
