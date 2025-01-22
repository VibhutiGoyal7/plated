import 'dart:async';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/request/rideRequest.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/response/ServiceTypeResponse.dart';
import '../../../model/response/initiateRideResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/banner_list_widget.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';
import '../../component/session_expired_dialog.dart';

class BookRideScreen extends StatefulWidget {
  @override
  _BookRideScreenState createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
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
  var isChecked = false;
  late double screenHeight;
  late double screenWidth;
  String? selectedCustomer = "For me";
  List<String> customerList = ['For me'];
  final ConnectivityService _connectivityService = ConnectivityService();
  final TextEditingController _genderController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        /*leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
        ),*/
        backgroundColor: AppColor.WHITE,
        //toolbarHeight: 30,
        centerTitle: true,
        title: Text("Plan Your Trip"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          print("Refresh");
          return Future.delayed(Duration(seconds: 2), () {});
        },
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.85,
            child: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRideOptionWidget(
                                    context,
                                    "",
                                    _genderController,
                                    Icon(Icons.merge),
                                    customerList,
                                    selectedCustomer,
                                    "For me"),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.2, color: Colors.black54)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 18,
                                          ),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamed(context, "/SelectLocationScreen");
                                            },
                                            child: Text(
                                              "Pick up location",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 45,
                                        width: 1,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.my_location,
                                            size: 18,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Destination",
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {bookRideApi()},
                                  child: IntrinsicWidth(
                                    child: Container(
                                      //width: 120,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 8),
                                      margin: EdgeInsets.only(
                                          top: 8.0, left: 12.0, right: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: isDarkMode
                                            ? AppColor.BLACK
                                            : Colors.grey.shade300,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Select Location on map",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              /*  Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BannerListWidget(
                        data: bannerList,
                        isInternetConnected: isInternetConnected,
                        isLoading: isBannerLoading,
                        isDarkMode: isDarkMode,
                        dummy: "assets/cab_add_1.png"),
                  ),
                ),*/
                isApiLoading
                    ? Stack(
                        children: [
                          // Block interaction
                          ModalBarrier(
                              dismissible: false, color: Colors.black54),
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

  Widget _buildRideOptionWidget(
      BuildContext context,
      String text,
      TextEditingController nameController,
      Icon icon,
      List<String> genderList,
      String? selectedGender,
      String labelText) {
    final GlobalKey _buttonKey = GlobalKey();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            labelText,
            style: TextStyle(fontSize: 14),
          ),
        ),
        IntrinsicWidth(
          child: GestureDetector(
            onTap: () => {
              bookRideApi()
              //_showDatePicker()
            },
            child: Container(
              width: 120,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
              margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: isDarkMode ? AppColor.BLACK : Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                key: _buttonKey,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    size: 20,
                  ),
                  selectedGender?.isEmpty == true
                      ? Container(
                          child: Text("Select $labelText"),
                        )
                      : Text(
                          "${selectedGender}".isEmpty
                              ? '$labelText'
                              : capitalizeFirstLetter("${selectedGender}"),
                          style: TextStyle(fontSize: 15),
                        ),
                  //SizedBox(width: 5),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker() {
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor:
          isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.LIGHT_CARD_COLOR,
      context: context,
      shape: Border(),
      builder: (BuildContext context) {
        return Container(
          height: screenHeight / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 15,
              ),
              Text("Switch Ride"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.2,
                          color: AppColor.BLACK,
                          style: BorderStyle.solid)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle),
                        Text("Switch Ride"),
                      ],
                    ),
                    Checkbox(
                      checkColor: AppColor.PRIMARY_ACCENT,
                      mouseCursor: MouseCursor.uncontrolled,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      semanticLabel: "${Languages.of(context)?.labelSaveId}",
                      shape: CircleBorder(),
                      side: BorderSide(
                          color: isDarkMode ? Colors.white : Colors.black),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context), // Close on cancel
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        );
      },
      isScrollControlled: true, // Makes the bottom sheet full height
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

  void bookRideApi() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    ToastComponent.showToast(context: context, message: "::Clicked", duration: maxDuration);
    if (!isConnected) {
      setState(() {
        isApiLoading = false;
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
        setState(() {
          isApiLoading = true;
        });
        //await Future.delayed(Duration(milliseconds: 1));
        RideRequest request = RideRequest(
            customerEmail: "simran5@cust.com",
            customerName: "Vibhuti",
            custPhone: "97765456336",
            destinationLatitude: "30.7030512",
            destinationLongitude: "76.8042724",
            fare: "100.00",
            pickupLatitude: "0.30691873e2",
            pickupLongitude: "0.76694864e2",
            serviceType: "rides");
        await Provider.of<MainViewModel>(context, listen: false)
            .createRideRequestApi(
                "/api/v1/customer_app/service_requests/create_service_request",
                request);
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
    InitiateRideResponse? response = apiResponse.data as InitiateRideResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");
    setState(() {
      isApiLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomLoader());
      case Status.COMPLETED:
        print("GetDashboardData : ${response?.customer_name}");

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
