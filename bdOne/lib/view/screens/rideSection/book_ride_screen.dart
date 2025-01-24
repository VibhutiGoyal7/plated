import 'dart:async';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/request/rideRequest.dart';
import 'package:BDOne/model/request/vehicleListRequest.dart';
import 'package:BDOne/model/response/driverStatusResponse.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/model/response/vehicleListResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/image_view_components.dart';
import 'package:BDOne/view/component/linear_loader.dart';
import 'package:BDOne/view/component/listComponents/wrap_component.dart';
import 'package:BDOne/view/component/text_component.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/request/driverCurrentLocRequest.dart';
import '../../../model/response/ServiceTypeResponse.dart';
import '../../../model/response/initiateRideResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/custom_circular_progress.dart';
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
  LatLng? currentLocation;
  LatLng? finalLocation = LatLng(0, 0);
  LocationData? pickUpLocation = null;
  LocationData? destinationLocation = null;
  bool isLoading = false;
  bool inputValid = false;
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
  List<VehicleDetails> vehicleList = [];
  String uniqueId ="";

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
    isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
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
                                            onTap: () {
                                              _getCurrentLocation(true);
                                              //Navigator.pushNamed(context, "/SelectLocationScreen");
                                            },
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  minWidth: screenWidth / 2,
                                                  maxWidth: screenWidth * 0.7),
                                              child: Text(
                                                pickUpLocation == null
                                                    ? "Pick up location"
                                                    : "${pickUpLocation
                                                    ?.address}",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    overflow:
                                                    TextOverflow.ellipsis),
                                              ),
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
                                          GestureDetector(
                                            onTap: () {
                                              _getCurrentLocation(false);
                                              //Navigator.pushNamed(context, "/SelectLocationScreen");
                                            },
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  minWidth: screenWidth / 2,
                                                  maxWidth: screenWidth * 0.7),
                                              child: Text(
                                                destinationLocation == null
                                                    ? "Destination"
                                                    : "${destinationLocation
                                                    ?.address}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                IntrinsicWidth(
                                  child: Container(
                                    //width: 120,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8),
                                    margin: EdgeInsets.only(
                                        top: 8.0, left: 12.0, right: 12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                SizedBox(
                                  height: 50,
                                ),
                                _buildFooter(context)
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

  Widget _buildRideOptionWidget(BuildContext context,
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
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: MaterialButton(
        minWidth: screenWidth * 0.85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: inputValid ? AppColor.PRIMARY_ACCENT : AppColor.GREY_TEXT_COLOR,
        height: 50,
        onPressed: () async {
          hideKeyBoard();
          //Navigator.pushNamed(context, '/SignInScreen');
          _isValidInput();
          getVehicleFareList();
          //_showVehicleTypes([]);
        },
        child: Text(
          Languages.of(context)!.labelConfirm,
          style: TextStyle(
              color: inputValid ? Colors.white : AppColor.PRIMARY,
              fontSize: 16),
        ),
      ),
    );
  }

  void _showVehicleTypes(VehicleListResponse? response) {
    var selected = vehicleList.first;
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor:
      isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.LIGHT_CARD_COLOR,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25),)),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: screenHeight * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
                                onTap: () {
                                  _getCurrentLocation(true);
                                  //Navigator.pushNamed(context, "/SelectLocationScreen");
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                      minWidth: screenWidth / 2,
                                      maxWidth: screenWidth * 0.8),
                                  child: Text(
                                    pickUpLocation == null
                                        ? "Pick up location"
                                        : "${pickUpLocation
                                        ?.address}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        overflow:
                                        TextOverflow.ellipsis),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 18,
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
                              GestureDetector(
                                onTap: () {
                                  _getCurrentLocation(false);
                                  //Navigator.pushNamed(context, "/SelectLocationScreen");
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                      minWidth: screenWidth / 2,
                                      maxWidth: screenWidth * 0.8),
                                  child: Text(
                                    destinationLocation == null
                                        ? "Destination"
                                        : "${destinationLocation
                                        ?.address}",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select your preferred ride",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text("Distance: "),
                              Text("${response?.estimatedDist}"),
                            ],
                          )
                        ],
                      ),
                    ),
                    /*Container(
                      height: 100,
                      width: 100,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(100),
                        //color: currentIconBdColor,
                      ),
                      child: SvgPicture.asset(
                        "assets/car_icon.svg",
                        colorFilter: ColorFilter.mode(
                          Colors.transparent,
                          // Use a contrasting color to test visibility
                          BlendMode.dst,
                        ),
                      ),
                    ),*/
                    WrapComponent(height: screenHeight * 0.38,
                        width: screenWidth,
                        isHorizontal: false,
                        wrapItems: vehicleList.map((result) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selected = result;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      selected == result ? 12 : 0),
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.2,
                                        color: selected == result ? AppColor
                                            .PRIMARY_GREEN : AppColor.BLACK),),
                                  color: selected == result ? AppColor
                                      .PRIMARY_GREEN : isDarkMode ? AppColor
                                      .DARK_CARD_COLOR : AppColor
                                      .LIGHT_CARD_COLOR
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ImageViewComponent(imageUrl: result.vehicleIcon,
                                          placeholderImage: "assets/cab_add_1.png",
                                          width: 30,
                                          height: 35,
                                          borderRadius: BorderRadius.zero,
                                          isDarkMode: isDarkMode),
                                      //,Icon(Icons.account_circle, size: 28,),
                                      SizedBox(width: 12,),
                                      TextComponent(
                                          text: "${result.categoryName}",
                                          fontSize: 16,
                                          isBold: false)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      TextComponent(
                                          text: "৳${result.estimatedFare}",
                                          fontSize: 16,
                                          isBold: false),
                                      /* Checkbox(
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
                                ),*/
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        ).toList()),
                    SizedBox(height: 15,),

                    MaterialButton(
                      minWidth: screenWidth * 0.85,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: AppColor.PRIMARY_ACCENT,
                      height: 50,
                      onPressed: () {
                        bookRideApi(selected);
                      },
                      // Close on cancel
                      child: Container(
                        width: screenWidth * 0.8,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Confirm Ride',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              );
            }
        );
      },
      isScrollControlled: true, // Makes the bottom sheet full height
    );
  }

  void _showLoaderDialog() {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      backgroundColor:
      isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.LIGHT_CARD_COLOR,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  SizedBox(height: 55,),
                  LinearLoader(),
                  SizedBox(height: 25,),
                  TextComponent(text: "Please wait while we contact drivers.",
                      fontSize: 16,
                      isBold: false),
                  SizedBox(height: 30,),

                  Container(
                    height: 160,
                    width: 160,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                      //color: currentIconBdColor,
                    ),
                    child: SvgPicture.asset(
                      "assets/car_icon.svg",
                      colorFilter: ColorFilter.mode(
                        Colors.transparent,
                        // Use a contrasting color to test visibility
                        BlendMode.dst,
                      ),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {

                },
                child: Container(
                  width: screenWidth * 0.7,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 40),
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.5, vertical: 12),
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: AppColor.TEXT_RED, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      color: isDarkMode ? Colors.white : Colors.white),
                  child: Text(
                    "CANCEL REQUEST",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color:
                        isDarkMode ? Colors.white : AppColor.TEXT_RED),
                  ),
                ),
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

  void bookRideApi(VehicleDetails vehicle) async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (inputValid) {
      setState(() {
        isLoading = true;
      });
    }

    if (!isConnected) {
      setState(() {
        isApiLoading = false;
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
        setState(() {
          isApiLoading = true;
        });
        //await Future.delayed(Duration(milliseconds: 1));
        RideRequest request = RideRequest(
            customerEmail: "simran5@cust.com",
            customerName: "Vibhuti",
            custPhone: "97765456336",
            destinationLatitude: "${destinationLocation?.latitude}",
            destinationLongitude: "${destinationLocation?.longitude}",
            fare: "100.00",
            pickupLatitude: "${pickUpLocation?.latitude}",
            pickupLongitude: "${pickUpLocation?.longitude}",
            vehicleCategoryId: vehicle.id,
            serviceType: "rides");
        await Provider.of<MainViewModel>(context, listen: false)
            .createRideRequestApi(
            "/api/v1/customer_app/service_requests/create_service_request",
            request);
        ApiResponse apiResponse =
            Provider
                .of<MainViewModel>(context, listen: false)
                .response;
        getBookRideResponse(context, apiResponse);
      }
    }
  }


  Future<Widget> getBookRideResponse(BuildContext context,
      ApiResponse apiResponse) async {
    InitiateRideResponse? response = apiResponse.data as InitiateRideResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");
    setState(() {
      isApiLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        Navigator.pop(context);
        print("GetDashboardData : ${response?.customer_name}");
        _showLoaderDialog();
        setState(() {
          uniqueId = "${response?.unique_id}";
        });
        rideStatusApi("${response?.unique_id}");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages
                    .of(context)
                    ?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          if (receiver.isListening) {
            receiver.stop();
          }
          SessionExpiredDialog.showDialogBox(context: context);
        } else {

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

  void getVehicleFareList() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (inputValid) {
      setState(() {
        isLoading = true;
      });
    }
    if (!isConnected) {
      setState(() {
        isApiLoading = false;
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
        setState(() {
          isApiLoading = true;
        });
        VehicleListRequest request = VehicleListRequest(
            pickupLatitude: "${pickUpLocation?.latitude}",
            pickupLongitude: "${pickUpLocation?.longitude}",
            destinationLatitude: "${destinationLocation?.latitude}",
            destinationLongitude: "${destinationLocation?.longitude}");
        await Provider.of<MainViewModel>(context, listen: false)
            .getVehicleFareListData(
            "api/v1/customer_app/vehicle_categories/calculate_estimated_fare",
            request);
        ApiResponse apiResponse =
            Provider
                .of<MainViewModel>(context, listen: false)
                .response;
        getVehicleFareListResponse(context, apiResponse);
      }
    }
  }


  Future<Widget> getVehicleFareListResponse(BuildContext context,
      ApiResponse apiResponse) async {
    VehicleListResponse? response = apiResponse.data as VehicleListResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");
    setState(() {
      isApiLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("vehicle list : ${response?.destination_latitude}");
        setState(() {
          vehicleList = response?.vehicles ?? [];
        });
        _showVehicleTypes(response);
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages
                    .of(context)
                    ?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          if (receiver.isListening) {
            receiver.stop();
          }
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

  void rideStatusApi(String uniqueId) async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));

    if (!isConnected) {
      setState(() {
        isApiLoading = false;
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
        setState(() {
          isApiLoading = false;
        });
        DriverCurrentLocRequest request = DriverCurrentLocRequest(uniqueId: "$uniqueId");
        await Provider.of<MainViewModel>(context, listen: false)
            .getDriverStatus(
            "/api/v1/customer_app/service_requests/get_driver_location",
            request);
        ApiResponse apiResponse =
            Provider
                .of<MainViewModel>(context, listen: false)
                .response;
        getRideStatusResponse(context, apiResponse);
      }
    }
  }


  Future<Widget> getRideStatusResponse(BuildContext context,
      ApiResponse apiResponse) async {
    DriverStatusResponse? response = apiResponse.data as DriverStatusResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");
    setState(() {
      isApiLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        if (response?.rideStatus == "accepted") {
          Navigator.pop(context);
          Navigator.pushNamed(context, "/RideBookedScreen", arguments: response);
        } else {
          await Future.delayed(Duration(seconds: 2));
          rideStatusApi("$uniqueId");
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages
                    .of(context)
                    ?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          if (receiver.isListening) {
            receiver.stop();
          }
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

  Future<void> _showExitDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Border.all(),
          title: Center(
              child: Text(
                "${Languages
                    .of(context)
                    ?.labelExit}",
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
                        child: Text('${Languages
                            .of(context)
                            ?.labelYes}'),
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
                "${Languages
                    .of(context)
                    ?.labelInvalidAccessToken}")) {
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

  void _getCurrentLocation(bool isPickUp) async {
    try {
      Position position = await _determinePosition();
      print('Current location: ${position.latitude}, ${position.longitude}');
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      LocationData? locationData =
      await LocationSearch.show(context: context, mode: Mode.fullscreen);
      ToastComponent.showToast(
          context: context,
          message: "${locationData?.address}",
          duration: maxDuration);
      print("Locations: : : ${locationData?.address}");
      setState(() {
        inputValid = true;
        isPickUp == true
            ? pickUpLocation = locationData
            : destinationLocation = locationData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _isValidInput() {
    //print(input);
    if (pickUpLocation != null && destinationLocation != null) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        // Permissions are denied, show an error
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      // Permissions are denied forever, handle accordingly
      throw Exception('Location permissions are permanently denied.');
    }

    // Retrieve the current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
