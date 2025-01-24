import 'dart:async';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/response/dashboardResponse.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/restaurant/restaurant_banner_list_widget.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../component/custom_loader.dart';
import '../../component/dashboard_search_component.dart';
import '../../component/image_view_components.dart';
import '../../component/restaurant/restaurant_dashboard_component.dart';
import '../../component/session_expired_dialog.dart';

class RestaurantHomeScreen extends StatefulWidget {
  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
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
        serviceName: 'Fruits',
        icon: 'assets/address.png',
        iconBgColor: Colors.red.shade50),
    ServiceTypeResponse(
        serviceName: 'Vegetables',
        icon: 'assets/address.png',
        iconBgColor: Colors.yellow.shade50),
    ServiceTypeResponse(
        serviceName: 'Dairy',
        icon: 'assets/address.png',
        iconBgColor: Colors.green.shade50),
    ServiceTypeResponse(
        serviceName: 'Spices',
        icon: 'assets/address.png',
        iconBgColor: Colors.blue.shade50),
    ServiceTypeResponse(
        serviceName: 'Pulses',
        icon: 'assets/address.png',
        iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Seeds',
        icon: 'assets/address.png',
        iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Nuts',
        icon: 'assets/address.png',
        iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Bakery & Biscuits',
        icon: 'assets/address.png',
        iconBgColor: Colors.black12),
  ];
  List<String> bannerList = ["", "", "", ""];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];

/*  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );*/

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    //receiver.start();
    /*  receiver.messages.listen((message) {
      print("BroadCast");
    });*/

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
    //receiver.stop();
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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarBrightness:
                isDarkMode ? Brightness.dark : Brightness.light,
            statusBarColor: AppColor.PRIMARY,
            statusBarIconBrightness: Brightness.light),
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
                                margin: EdgeInsets.only(top: 10),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              size: 22,
                                            ),
                                            onPressed: () => {
                                              Navigator.pushReplacementNamed(
                                                  context, '/BottomNav',
                                                  arguments: 0)
                                            },
                                          ),
                                          DashboardSearchComponent(
                                            onTap: () => {},
                                            screenHeight: 50,
                                            primaryColor:
                                                AppColor.PRIMARY_ACCENT,
                                            hintText:
                                                "What are u looking for ?",
                                            queryController: _searchController,
                                            screenWidth: screenWidth * 0.6,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              size: 26,
                                              color: AppColor.PRIMARY_ACCENT,
                                            ),
                                            onPressed: () => {
                                              Navigator.pushReplacementNamed(
                                                  context, '/BottomNav',
                                                  arguments: 0)
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RestaurantBannerListWidget(
                                          data: bannerList,
                                          isInternetConnected:
                                              isInternetConnected,
                                          isLoading: isBannerLoading,
                                          isDarkMode: isDarkMode,
                                          dummy: "assets/cab_add_1.png"),
                                      categories.length > 0
                                          ? RestaurantDashboardComponent(
                                              categories: categories,
                                              screenWidth: screenWidth,
                                              screenHeight: screenHeight,
                                              isDarkMode: isDarkMode,
                                              primaryColor: AppColor.PRIMARY,
                                              heading: "Services",
                                            )
                                          : SizedBox(),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 12),
                                                child: Text(
                                                  "Daily Products",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          AnimatedContainer(
                                              width: screenWidth,
                                              height: 220,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              // Expandable height control
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                // Fit grid inside list
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                // Disable grid scrolling
                                                padding: EdgeInsets.all(4),
                                                itemCount: categories.length,
                                                itemBuilder:
                                                    (context, subIndex) {
                                                  if (subIndex <
                                                      categories.length) {
                                                    var subCategory =
                                                        categories[subIndex];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showSnackBar(
                                                            context,
                                                            "${subCategory?.serviceName}",
                                                            screenWidth * 0.5,
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 200,
                                                        width: screenWidth / 2.6,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isDarkMode
                                                              ? Colors.black
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              width: 0.2),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 1),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(bottom: 18.0),
                                                              child: ImageViewComponent(
                                                                height: 95,
                                                                width: 95,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(Radius
                                                                            .circular(
                                                                                0)),
                                                                imageUrl:
                                                                    subCategory
                                                                        ?.icon,
                                                                isDarkMode: false,
                                                                placeholderImage:
                                                                    "assets/milk_image.png",
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          "480",
                                                                        style: TextStyle(
                                                                           fontSize: 18,
                                                                          color: AppColor.TEXT_RED,
                                                                          fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: AppColor.PRIMARY_ACCENT,
                                                                              borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                          child: Icon(
                                                                            Icons.add,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                Colors.white,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "480",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                            color: Colors.black87
                                                                          )),
                                                                      SizedBox(width: 5),
                                                                      Text(
                                                                          "52% Off", style: TextStyle(
                                                                        fontSize: 10,color: AppColor.PRIMARY_ACCENT,
                                                                        fontWeight: FontWeight.w600
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    "${capitalizeFirstLetter("${subCategory?.serviceName}")}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: isDarkMode
                                                                          ? AppColor
                                                                              .WHITE
                                                                          : AppColor
                                                                              .BLACK,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox(); // Prevents index errors
                                                  }
                                                },
                                              ))
                                        ],
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
                                            dummy: "assets/cab_add_2.png"),
                                      ),
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
                              child: CustomLoader(),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
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
        //receiver.stop();
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
        return Center(child: CustomLoader());
      case Status.COMPLETED:
        print("GetDashboardData : ${dashboardResponse?.customerData?.email}");

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          /* if (receiver.isListening) {
            receiver.stop();
          }*/
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
        return Center(child: CustomLoader());
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
