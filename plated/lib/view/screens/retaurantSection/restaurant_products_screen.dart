import 'dart:async';

import 'package:Plated/model/db/PlatedDatabase.dart';
import 'package:Plated/model/request/productListRequest.dart';
import 'package:Plated/model/response/countryListResponse.dart';
import 'package:Plated/model/response/dashboardResponse.dart';
import 'package:Plated/model/response/productsListReponse.dart';
import 'package:Plated/utils/Util.dart';
import 'package:Plated/view/component/shimmerComponents/ShimmerList.dart';
import 'package:Plated/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/dashboard_search_component.dart';
import '../../component/session_expired_dialog.dart';
import 'component/product_component.dart';

class RestaurantProductsScreen extends StatefulWidget {
  final CategoryData? data;

  RestaurantProductsScreen({Key? key, this.data}) : super(key: key);

  @override
  _RestaurantProductsScreenState createState() =>
      _RestaurantProductsScreenState();
}

class _RestaurantProductsScreenState extends State<RestaurantProductsScreen> {
  String? country;
  String calledShortCut = "";
  String? name = "";
  late PageController _pageController;
  int _currentPage = 1;
  final _numberOfPostsPerRequest = 20;
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
  List<ProductDetails?> productsList = [];
  List<ProductDetails?> searchedProductsList = [];
  List<String> bannerList = ["", "", "", ""];
  List<String> brandsList = ["Kellogs", "Amul", "Amul", "Kellogs"];

  Future<void>? _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    imageUrl = "";

    Helper.getProfileDetails().then((profile) {
      setState(() {
        name = profile?.firstName;
        imageUrl = profile?.imageUrl;
        country = profile?.countryName;
        userId = profile?.userId;
      });
    });

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

    _fetchDataFuture = _fetchDWData(_currentPage, false, false);
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).focusColor,
                            size: 22,
                          ),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                        DashboardSearchComponent(
                          onTap: (value) => {
                          _fetchDataFuture = _fetchDWData(_currentPage, false, false, searchValue: value)
                          },
                          screenHeight: 50,
                          primaryColor: AppColor.PRIMARY_ACCENT,
                          hintText: "What are u looking for?",
                          queryController: _searchController,
                          screenWidth: screenWidth * 0.75,
                        ),
                      /*  IconButton(
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
                        ),*/
                      ],
                    ),
                    productsList.length != 0
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    "${widget.data?.categoryName}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColor.GREY_TEXT_COLOR,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  width: screenWidth,
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInCirc,
                                  child: Wrap(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    runSpacing: 2,
                                    children: productsList.map(
                                      (subCategory) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                "/RestaurantItemViewScreen",
                                                arguments: subCategory);
                                          },
                                          child: ProductComponent(
                                            width: screenWidth / 2.3,
                                            height: 220,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            placeholderImage: '',
                                            isDarkMode: isDarkMode,
                                            subCategory: subCategory,
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                )
                              ],
                            ),
                          )
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
                                    "No Product Available",
                                    style: TextStyle(
                                        color: AppColor.GREY_TEXT_COLOR),
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
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

  Future<void> _fetchDWData(
      int pageKey, bool filterApplied, bool isScroll, {String searchValue = ""}) async {
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
            pageSize: _numberOfPostsPerRequest,
            description: '',
            foodCategoryId: '${widget.data?.id ?? 1}',
            name: '$searchValue');
        await Provider.of<MainViewModel>(context, listen: false)
            .getProductsFromCategoryApi(
                "api/v1/app/customers/all_trx_list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getTransactionData(context, apiResponse, pageKey, isScroll, searchValue.isNotEmpty);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll, bool isSearch) async {
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
         productsList.clear();
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
          print("ERROR: ${apiResponse.message}");

          SessionExpiredDialog.showDialogBox(context: context);
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
}
