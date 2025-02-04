import 'dart:async';

import 'package:Plated/model/db/PlatedDatabase.dart';
import 'package:Plated/model/response/dashboardResponse.dart';
import 'package:Plated/model/response/kycStatusResponse.dart';
import 'package:Plated/utils/Util.dart';
import 'package:Plated/view/component/restaurant/restaurant_banner_list_widget.dart';
import 'package:Plated/view/component/shimmerComponents/shimmer_card.dart';
import 'package:Plated/view/component/toastMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/request/productListRequest.dart';
import '../../../model/response/ServiceTypeResponse.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../model/response/productsListReponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/banner_list_widget.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';
import '../../component/dashboard_search_component.dart';
import '../../component/restaurant/restaurant_dashboard_component.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/shimmerComponents/ShimmerList.dart';
import 'component/product_component.dart';

class RestaurantHomeScreen extends StatefulWidget {
  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  String? country;
  String calledShortCut = "";
  String? name = "";
  late PageController _pageController;
  int _currentPage = 1;
  late Timer _timer;
  late int? userId;
  var imageUrl;
  late PlatedDatabase database;
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
        serviceName: 'Fruits', icon: '', iconBgColor: Colors.red.shade50),
    ServiceTypeResponse(
        serviceName: 'Vegetables',
        icon: '',
        iconBgColor: Colors.yellow.shade50),
    ServiceTypeResponse(
        serviceName: 'Dairy', icon: '', iconBgColor: Colors.green.shade50),
    ServiceTypeResponse(
        serviceName: 'Spices', icon: '', iconBgColor: Colors.blue.shade50),
    ServiceTypeResponse(
        serviceName: 'Pulses', icon: '', iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Seeds', icon: '', iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Nuts', icon: '', iconBgColor: Colors.black12),
    ServiceTypeResponse(
        serviceName: 'Bakery & Biscuits',
        icon: '',
        iconBgColor: Colors.black12),
  ];
  List<ProductDetails?> productsList = [];
  List<String> bannerList = ["", "", "", ""];
  List<CategoryData> categoryList = [];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];

  late MainViewModel _viewModel;
  late ApiResponse apiResponse;
  Future<void>? _fetchDataFuture;

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
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    _fetchCategoryListData();
    _fetchDataFuture = _fetchDWData(_currentPage, false, false);
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
        Navigator.pushReplacementNamed(
            context, '/BottomNav',
            arguments: 0);
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
                                            color: Theme.of(context).focusColor,
                                            size: 22,
                                          ),
                                          onPressed: () => {
                                            Navigator.pushReplacementNamed(
                                                context, '/BottomNav',
                                                arguments: 0)
                                          },
                                        ),
                                      /*  DashboardSearchComponent(
                                          onTap: (value) => {},
                                          screenHeight: 50,
                                          primaryColor: AppColor.PRIMARY_ACCENT,
                                          hintText: "What are u looking for?",
                                          queryController: _searchController,
                                          screenWidth: screenWidth * 0.75,
                                        ),*/
                                      /*  IconButton(
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            size: 26,
                                            color: AppColor.PRIMARY_ACCENT,
                                          ),
                                          onPressed: () => {
                                            Navigator.pushNamed(
                                                context, '/RestaurantBottomNav',
                                                arguments: 2)
                                          },
                                        ),*/
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
                                    categoryList.length != 0
                                        ? RestaurantDashboardComponent(
                                            categories: categoryList,
                                            screenWidth: screenWidth,
                                            screenHeight: screenHeight,
                                            isDarkMode: isDarkMode,
                                            primaryColor: AppColor.PRIMARY,
                                            heading: "Categories",
                                          )
                                        : isLoading
                                        ? Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(height: 25),
                                        ShimmerCard()
                                      ],
                                    )
                                        : Container(
                                      height: screenHeight * 0.8,
                                      child: Align(
                                        alignment:
                                        Alignment.center,
                                        child: Text(
                                          "No Product Available",
                                          style: TextStyle(
                                              color: AppColor
                                                  .GREY_TEXT_COLOR),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 14),
                                              child: Text(
                                                "Daily Products",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 14),
                                              child: GestureDetector(
                                                onTap: () => {},
                                                child: Text(
                                                  "See all",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: AppColor
                                                          .PRIMARY_ACCENT),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        productsList.length != 0
                                            ? AnimatedContainer(
                                                width: screenWidth,
                                                height: 250,
                                                padding: const EdgeInsets.only(
                                                    top: 6, left: 10),
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                // Expandable height control
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  // Fit grid inside list
                                                  //physics: NeverScrollableScrollPhysics(),
                                                  // Disable grid scrolling
                                                  padding: EdgeInsets.all(4),
                                                  itemCount:
                                                      productsList.length,
                                                  itemBuilder:
                                                      (context, subIndex) {
                                                    if (subIndex <
                                                        productsList.length) {
                                                      var subCategory =
                                                          productsList[
                                                              subIndex];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pushNamed(context,
                                                                "/RestaurantItemViewScreen",
                                                                arguments: subCategory);
                                                          });
                                                        },
                                                        child: ProductComponent(
                                                          width:
                                                              screenWidth / 2.4,
                                                          height: 250,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          placeholderImage: '',
                                                          isDarkMode:
                                                              isDarkMode,
                                                          subCategory:
                                                              subCategory,
                                                        ),
                                                      );
                                                    } else {
                                                      return SizedBox(); // Prevents index errors
                                                    }
                                                  },
                                                ))
                                            : isLoading
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(height: 25),
                                                      ShimmerList(
                                                        itemCount: 3,
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    height: screenHeight * 0.8,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "No Product Available",
                                                        style: TextStyle(
                                                            color: AppColor
                                                                .GREY_TEXT_COLOR),
                                                      ),
                                                    ),
                                                  ),
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
            .dashboardData();
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
    database = await $FloorPlatedDatabase
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

  void _fetchCategoryListData() async {
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
      await _viewModel.fetchCategoryListApi();
      apiResponse = _viewModel.response;
      getCategoryList(context);
    }
  }

  Widget getCategoryList(BuildContext context) {
    CategoryListResponse? categoryListResponse =
        apiResponse.data as CategoryListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : Colors.red,
        ));
      case Status.COMPLETED:
        setState(() {
          categoryListResponse?.categories?.forEach((value) {
            categoryList.add(value);
          });
        });
        return Container();
      case Status.ERROR:
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

  Future<void> _fetchDWData(
      int pageKey, bool filterApplied, bool isScroll) async {
    try {
      setState(() {
        isLoading = true;
      });
      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        ProductListRequest request = ProductListRequest(
            pageNo: pageKey,
            pageSize: 5,
            description: '',
            foodCategoryId: '2',
            name: '');
        await Provider.of<MainViewModel>(context, listen: false)
            .getProductsFromCategoryApi(
                "api/v1/app/customers/all_trx_list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getTransactionData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async {
    ProductsListResponse? response = apiResponse.data as ProductsListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = response?.productDetails ?? [];
        setState(() {
          productsList.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }
}
