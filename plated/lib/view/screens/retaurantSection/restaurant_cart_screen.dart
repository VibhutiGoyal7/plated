import 'dart:async';

import 'package:Plated/model/db/PlatedDatabase.dart';
import 'package:Plated/model/response/cartListReponse.dart';
import 'package:Plated/model/response/deleteCartResponse.dart';
import 'package:Plated/utils/Util.dart';
import 'package:Plated/view/component/shimmerComponents/ShimmerList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/response/ServiceTypeResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/image_view_components.dart';
import '../../component/session_expired_dialog.dart';

class RestaurantCartScreen extends StatefulWidget {
  final ServiceTypeResponse? data; // Define the 'data' parameter here

  RestaurantCartScreen({Key? key, this.data}) : super(key: key);

  @override
  _RestaurantCartScreenState createState() => _RestaurantCartScreenState();
}

class _RestaurantCartScreenState extends State<RestaurantCartScreen> {
  String? country;
  String calledShortCut = "";
  String? name = "";
  String? grandTotal = "";
  late PageController _pageController;
  int _currentPage = 0;
  int itemCount = 0;
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
  CartItem selectedItem = CartItem(
      foodItemId: 0,
      quantity: 0,
      price: '0',
      foodCartItemId: 0,
      foodItemName: "",
      totalPrice: '0');
  List<CartItem?> cartItemsList = [];
  List<String> bannerList = ["", "", "", ""];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    //ServiceTypeResponse
    getCartDataListDataApi();
    //selectedItem = (widget.data ?? cartItemsList.first)!;
    print("SelectedItem :: ${selectedItem.foodItemName}");
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    DateTime? lastBackPressed;
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 55,
          shape: Border(
              bottom:
                  BorderSide(width: 0.5, color: Theme.of(context).cardColor)),
          title: Text(
            "My Cart",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          leading: SizedBox(),
          actions: [
            GestureDetector(
              onTap: () => {clearCartApi()},
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  "Clear Cart",
                  style: TextStyle(
                      color: AppColor.TEXT_RED,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
          backgroundColor:
              isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0, top: 0),
                child: Column(
                  children: [
                    cartItemsList.length != 0
                        ? AnimatedContainer(
                            width: screenWidth,
                            height: screenHeight * 0.6,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.2,
                                      color: AppColor.GREY_TEXT_COLOR)),
                            ),
                            curve: Curves.easeInCirc,
                            child: ListView.builder(
                                itemCount: cartItemsList.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 2),
                                itemBuilder: (context, index) {
                                  final currentCategory = cartItemsList[index];
                                  return Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    width: screenWidth / 2.3,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      border: Border(
                                          bottom: BorderSide(
                                              width: cartItemsList.last ==
                                                      selectedItem
                                                  ? 0
                                                  : 0.2,
                                              color: cartItemsList.length ==
                                                      cartItemsList.last
                                                  ? Colors.transparent
                                                  : AppColor.GREY_TEXT_COLOR)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: ImageViewComponent(
                                                height: 55,
                                                width: 45,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                imageUrl:
                                                    currentCategory?.itemImage,
                                                isDarkMode: false,
                                                placeholderImage:
                                                    "assets/milk_image.png",
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${currentCategory?.foodItemName}",
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  Row(
                                                    children: [
                                                      /*      GestureDetector(
                                                    onTap: () => decrement(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 22,
                                                        color: itemCount == 0
                                                            ? Colors.grey
                                                            : Theme.of(context)
                                                                .focusColor,
                                                      ),
                                                    ),
                                                  ),*/
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 3),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Items : ${currentCategory?.quantity} * ${currentCategory?.price}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColor
                                                                  .GREY_TEXT_COLOR),
                                                        ),
                                                      ),
                                                      /*  GestureDetector(
                                                    onTap: () => increment(),
                                                    child: Container(
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 22,
                                                        color: AppColor
                                                            .PRIMARY_ACCENT,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding:
                                                          EdgeInsets.all(2),
                                                    ),
                                                  )*/
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              margin: EdgeInsets.only(left: 20),
                                            )
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.close,
                                              size: 18,
                                              color:
                                                  Theme.of(context).focusColor,
                                            ),
                                            Text(
                                              " ৳${currentCategory?.totalPrice}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColor.BLACK,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }))
                        : isLoading
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add item to Cart",
                                    style: TextStyle(
                                        color: AppColor.GREY_TEXT_COLOR),
                                  ),
                                ),
                              ),
                    cartItemsList.length != 0
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            "Total",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(context).focusColor,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.topLeft,
                                      ),
                                      Text(
                                        "৳${grandTotal}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          cartItemsList.length != 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        color: AppColor.PRIMARY_ACCENT,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.only(bottom: 80),
                    child: Text(
                      "Go to Checkout",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.WHITE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : SizedBox(),
          isApiLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CustomCircularProgress(),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void increment() {
    setState(() {
      itemCount += 1;
    });
  }

  void decrement() {
    setState(() {
      itemCount > 0 ? itemCount -= 1 : itemCount = 0;
    });
  }

  void getCartDataListDataApi() async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = false;
        isInternetConnected = false;
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
            .getCartDataListApi();
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getCartDataListData(context, apiResponse);
      }
    }
  }

  Future<void> intializeDatabase() async {
    database = await $FloorPlatedDatabase
        .databaseBuilder('bd_pass_database.db')
        .build();

    dashboardTransactionDao = database.dashboardTransactionDao;
    customerDataDao = database.personDao;
  }

  Future<Widget> getCartDataListData(
      BuildContext context, ApiResponse apiResponse) async {
    setState(() {
      isLoading = false;
    });
    CartListResponse? response = apiResponse.data as CartListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("GetDashboardData : ${response?.data?.items?.length}");
        setState(() {
          grandTotal = "${response?.data?.grandTotal}" ?? "0";
          response?.data?.items?.forEach((value) {
            cartItemsList.add(value);
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
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

  void clearCartApi() async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = false;
        isInternetConnected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      if (mounted) {
        await Provider.of<MainViewModel>(context, listen: false).clearCartApi();
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        clearCartApiResponse(context, apiResponse);
      }
    }
  }

  Future<Widget> clearCartApiResponse(
      BuildContext context, ApiResponse apiResponse) async {
    DeleteCartResponse? response = apiResponse.data as DeleteCartResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");

    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        getCartDataListDataApi();
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        setState(() {
          isLoading = false;
        });
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          SessionExpiredDialog.showDialogBox(context: context);
        } else {}
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
}
