import 'dart:async';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/model/response/productsListReponse.dart';
import 'package:BDOne/model/response/updateCartListReponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/custom_button_component.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/request/updateCartRequest.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/image_view_components.dart';
import '../../component/session_expired_dialog.dart';

class RestaurantItemViewScreen extends StatefulWidget {
  final ProductDetails? data; // Define the 'data' parameter here

  RestaurantItemViewScreen({Key? key, this.data}) : super(key: key);

  @override
  _RestaurantItemViewScreenState createState() =>
      _RestaurantItemViewScreenState();
}

class _RestaurantItemViewScreenState extends State<RestaurantItemViewScreen> {
  String? country;
  String calledShortCut = "";
  String? name = "";
  late PageController _pageController;
  int _currentPage = 0;
  int itemCount = 0;
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
  late ProductDetails selectedItem;
  List<ProductDetails?> categories = [];
  List<String> bannerList = ["", "", "", ""];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    //ServiceTypeResponse

    selectedItem = (widget.data ?? categories.first)!;
    print("SelectedItem :: ${selectedItem.name}");
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    DateTime? lastBackPressed;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0, top: 0),
                child: Column(
                  children: [
                    Container(
                      height: screenHeight * 0.35,
                      decoration: BoxDecoration(
                          color: AppColor.PRIMARY_ACCENT.withOpacity(0.4),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 22,
                                ),
                                onPressed: () => {Navigator.pop(context)},
                              ),
                              /*IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  size: 26,
                                  color: AppColor.BLACK,
                                ),
                                onPressed: () => {
                                  Navigator.pushReplacementNamed(
                                      context, '/BottomNav',
                                      arguments: 0)
                                },
                              ),*/
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: ImageViewComponent(
                              height: screenHeight * 0.25,
                              width: screenWidth * 0.7,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              imageUrl: widget.data?.itemImage,
                              isDarkMode: false,
                              placeholderImage: "assets/milk_image.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                "${widget.data?.name}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => decrement(),
                                      child: Icon(
                                        Icons.remove,
                                        size: 26,
                                        color: itemCount == 0
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 30,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            width: 0.2,
                                            color: Theme.of(context).cardColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                        "$itemCount",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => increment(),
                                      child: Icon(
                                        Icons.add,
                                        size: 26,
                                        color: AppColor.PRIMARY_ACCENT,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "৳${widget.data?.price}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: AppColor.TEXT_RED,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Theme.of(context).focusColor,
                            height: 0.5,
                            width: screenWidth * 0.85,
                            margin: EdgeInsets.symmetric(vertical: 14),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Detail",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).focusColor),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${selectedItem.description}",
                                    style: TextStyle(
                                        color: AppColor.GREY_TEXT_COLOR
                                            .withOpacity(0.8),
                                        fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Align(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, top: 18),
                                  child: Text(
                                    "Related Products",
                                    style: TextStyle(
                                        fontSize: 15, color: AppColor.BLACK),
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              AnimatedContainer(
                                width: screenWidth,
                                //height: screenHeight,
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.only(bottom: 20),
                                curve: Curves.easeInCirc,
                                child: Wrap(
                                  spacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 0,
                                  children: categories.map(
                                    (subCategory) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showSnackBar(
                                              context,
                                              "${subCategory?.name}",
                                              screenWidth * 0.5,
                                            );
                                          });
                                        },
                                        child: Container(
                                          height: 200,
                                          width: screenWidth / 2.3,
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                                width: 0.1,
                                                color: Colors.black54),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 1),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: ImageViewComponent(
                                                  height: 85,
                                                  width: 85,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0)),
                                                  imageUrl:
                                                      subCategory?.itemImage,
                                                  isDarkMode: false,
                                                  placeholderImage:
                                                      "assets/milk_image.png",
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          " ৳480",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColor
                                                                  .TEXT_RED,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Container(
                                                            height: 24,
                                                            width: 24,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: AppColor
                                                                    .PRIMARY_ACCENT,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100))),
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 18,
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
                                                        Text(" ৳680",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .black54,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor:
                                                                  Colors
                                                                      .black54,
                                                            )),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "52% Off",
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              color: AppColor
                                                                  .PRIMARY_ACCENT,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${capitalizeFirstLetter("${subCategory?.name}")}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: isDarkMode
                                                            ? AppColor.WHITE
                                                            : AppColor.BLACK,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              SizedBox(height: 35),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          itemCount != 0 ?
          Align(
            alignment: Alignment.bottomCenter,
            child:
            Container(
              height: 55,
              child: CustomButtonComponent(
                width: screenWidth /2,
                onTap: () => {updateCartDataFromApi()},
                isDarkMode: isDarkMode,
                verticalPadding: 10,
                buttonColor: AppColor.PRIMARY_ACCENT,
                text: "Add to Basket",
                textColor: AppColor.WHITE,
                borderRadius: 20,
                isClickable: true,
              ),
            )
          ) : SizedBox(),
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

  void updateCartDataFromApi() async {
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
            .updateCartDataApi(UpdateCartRequest(
                quantity: itemCount ?? 0,
                foodItemId: widget.data?.id ?? 0,
                type: "add"));
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getCartDataApi(context, apiResponse);
      }
    }
  }

  Future<void> intializeDatabase() async {
    database = await $FloorBDOneDatabase
        .databaseBuilder('bd_pass_database.db')
        .build();

    dashboardTransactionDao = database.dashboardTransactionDao;
    customerDataDao = database.personDao;
  }

  Future<Widget> getCartDataApi(
      BuildContext context, ApiResponse apiResponse) async {
    UpdateCartListResponse? response =
        apiResponse.data as UpdateCartListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("GetDashboardData : ${response?.data?.customerId}");
        showSnackBar(context, "Added",screenWidth /2.5);
        setState(() {
          itemCount = 0;
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
