import 'dart:async';

import 'package:Payrio/model/response/dashboardResponse.dart';
import 'package:Payrio/model/response/kycStatusResponse.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/shortcutItemList.dart';
import '../../../model/response/offersResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/transaction_dialog.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String kycStatus = "";
  String dashBoardKycStatus = "";
  String kycStatusApi = "";
  String? amount = "0.00";
  String? currencySymbol = "";
  String calledShortCut = "";
  String? name = "";
  var imageUrl;
  var flagImg;
  bool isAmountVisible = true;
  bool isUSDVisible = false;
  late List<bool> _isChecked; // Initialize as late to delay initialization
  late List<Shortcutitemlist> _shortcutCardsList;
  bool _isRefreshing = false;
  double _dragOffset = 0.0;

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  bool isApiLoading = false;
  bool isInternetConnected = true;
  final ConnectivityService _connectivityService = ConnectivityService();

  List<TransactionDetails> transactionList = [];

  final List<OfferResponse> imgList = [
    OfferResponse(
        image:
            "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
            "https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
            "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
            "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
    OfferResponse(
        image:
            "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
        title: "Flat 50% off",
        description: "Bonus on Rummy Circle & My11Circle",
        daysLeft: "5d left"),
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    flagImg = "";

    Helper.getProfileDetails().then((profile) {
      setState(() {
        name = profile?.firstName;
        imageUrl = profile?.imageUrl;
        currencySymbol = profile?.countryCurrencySymbol;
      });
    });

    _isChecked = List<bool>.generate(
        5, (index) => false); // Initial setup for 5 checkboxes
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.languageCode;
    _fetchDashboardData();

    print("isoCountryCode:: $isoCountryCode");
    // Initial setup for 5 checkboxes
  }

  FutureOr onGoBack(dynamic value) {
    _fetchDashboardData();
  }

  Future<Widget> getDashboardData(
      BuildContext context, ApiResponse apiResponse) async {
    DashboardResponse? dashboardResponse =
        apiResponse.data as DashboardResponse?;
    var message = apiResponse?.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${dashboardResponse?.customerData?.email}");
        print(
            "currency ${dashboardResponse?.customerData?.countryCurrencySymbol}");
        if (dashboardResponse?.customerData?.tpin == null ||
            dashboardResponse?.customerData?.tpin == "") {
          Navigator.pushNamed(context, '/TpinCreateScreen');
        }
        await Helper.saveUserBalance(dashboardResponse?.customerData?.balance);
        await Helper.saveCurrencySymbol(
            dashboardResponse?.customerData?.countryCurrencySymbol);
        setState(() {
          dashBoardKycStatus =
              dashboardResponse?.customerData?.kycStatus == null
                  ? ""
                  : "${dashboardResponse?.customerData?.kycStatus}";
          name = dashboardResponse?.customerData?.firstName == null
              ? "Name"
              : dashboardResponse?.customerData?.firstName;
          imageUrl = dashboardResponse?.customerData?.imageUrl == null
              ? ""
              : dashboardResponse?.customerData?.imageUrl;
          amount = dashboardResponse?.customerData?.balance == null
              ? "0.00"
              : dashboardResponse?.customerData?.balance;
          currencySymbol =
              dashboardResponse?.customerData?.countryCurrencySymbol == null
                  ? ""
                  : dashboardResponse?.customerData?.countryCurrencySymbol;
          //   flagImg = dashboardResponse?.customerData?. == null ? "" : dashboardResponse?.customerData?.countryCurrencySymbol;
          transactionList = dashboardResponse?.customerRecentTxn
              as List<TransactionDetails>;
          isLoading = false;
        });

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          print(apiResponse.message);
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          Helper.getProfileDetails().then((userDetails) {
            setState(() {
              print("userDetails?.imageUrl${userDetails?.imageUrl}");
              name = userDetails?.firstName == null
                  ? "Name"
                  : userDetails?.firstName;
              imageUrl =
                  userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
              print("imageUrl${imageUrl}");
            });
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
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${kycStatusResponse?.kycStatus}");
        kycStatusApi = kycStatusResponse!.kycStatus!;
        if (kycStatusApi != "verified") {
          isApiLoading = false;
          Navigator.pushNamed(context, '/ChooseDocScreen');
        } else if (kycStatusApi == "verified") {
          isApiLoading = false;
          if (calledShortCut == "Add") {
            calledShortCut = "";
            Navigator.pushNamed(context, '/PaymentMethodScreen');
          } else {
            calledShortCut = "";
            Navigator.pushNamed(context, '/WithdrawScreen');
          }
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
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

  Future<void> _refresh() async {
    // Simulate a network request or some other async operation
    //await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = true;
    });

    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));
    _fetchDashboardData();

    setState(() {
      _isRefreshing = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _shortcutCardsList = [

      Shortcutitemlist(
          title: Languages.of(context)!.labelAddMoney,
          icon: Icons.add_rounded,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelWithdraw,
          icon: Icons.call_made,
          selected: true),
      Shortcutitemlist(
          title: "Request QR",
          icon: Icons.send,
          selected: true),
  /*    Shortcutitemlist(
          title: Languages.of(context)!.labelTransfer,
          icon: Icons.transfer_within_a_station_sharp,
          selected: true),*/

      Shortcutitemlist(
          title: Languages.of(context)!.labelExchange,
          icon: Icons.currency_exchange,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelRewards,
          icon: Icons.gif_box,
          selected: false)
    ];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: maxDuration,
              ),
            );
            //SystemNavigator.pop();
            // return Future.value(false);
          } else {
            SystemNavigator.pop();
          }
          // return Future.value(true);
        }
      },
      child: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: isDarkMode
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: screenHeight * 0.28,
                        child: Image(
                          height: screenHeight * 0.28,
                          image: AssetImage(isDarkMode ? "assets/header_night.png" :"assets/header.png"),
                          fit: isDarkMode ? BoxFit.cover : BoxFit.fill,
                          opacity: isDarkMode ? const AlwaysStoppedAnimation(.5) : const AlwaysStoppedAnimation(.9),
                        ),
                        alignment: AlignmentDirectional.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 18),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 45,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0,left: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () => {
                                                Navigator.pushNamed(
                                                    context, '/ProfileScreen')
                                              },
                                              child: imageUrl == null ||
                                                  imageUrl == ""
                                                  ? Container(
                                                height: 40,
                                                width: 40,
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                  AppColor.WHITE,
                                                  backgroundImage: AssetImage(
                                                    "assets/profile_user.png",
                                                  ),
                                                ),
                                              )
                                                  : ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      100.0),
                                                  child: Image.network(
                                                    imageUrl as String,
                                                    height: 40,
                                                    width: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                        Object exception,
                                                        StackTrace?
                                                        stackTrace) {
                                                      // You can return any widget here to display in case of an error
                                                      return Container(
                                                        height: 40,
                                                        width: 40,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                          AppColor.WHITE,
                                                          backgroundImage:
                                                          AssetImage(
                                                            "assets/profile_user.png",
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    loadingBuilder: (BuildContext
                                                    context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Shimmer
                                                            .fromColors(
                                                          baseColor:
                                                          Colors.black45,
                                                          highlightColor:
                                                          Colors.black87,
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  )),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          // Add space between avatar and text
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    child: Text(
                                                     "${Languages.of(context)!.labelHi}, ${capitalizeFirstLetter("${name}")}",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                dashBoardKycStatus == "verified"
                                                    ? Icon(
                                                  Icons.verified,
                                                  color: Colors.green.shade700,
                                                )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: ()
                                            {
                                              setState(
                                                    () {
                                                  isAmountVisible =
                                                  !isAmountVisible;
                                                },
                                              );
                                            },
                                            child:Icon(
                                              isAmountVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 24,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          GestureDetector(
                                            onTap: ()
                                            {
                                              Navigator.pushNamed(
                                                  context, "/NotificationScreen");
                                            },
                                            child: Icon(
                                              Icons.notifications,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            (dashBoardKycStatus != "" &&
                                    dashBoardKycStatus != "verified" &&
                                    dashBoardKycStatus != null)
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/ChooseDocScreen');
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: AppColor.WHITE,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.8),
                                                    bottom: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.8),
                                                    left: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.8),
                                                    right: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.8))),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "KYC NON-VERIFIED",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(
                                                    Icons.do_not_disturb_on,
                                                    size: 18,
                                                    color: Colors.red,
                                                  )
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 36,
                                  ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          Languages.of(context)!
                                              .labelTotalBalance,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              letterSpacing: 1.25),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    addCurrencySymbol(currencySymbol,
                                        "${isAmountVisible ? amount : "**"}  "),
                                    style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              child: Container(
                                  width: screenWidth,
                                  height: screenHeight * 0.14,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(
                                      4,
                                      (index) {
                                        if (index <= 2) {
                                          return _buildContainer(
                                              context,
                                              _shortcutCardsList[index].title,
                                              _shortcutCardsList[index].icon);
                                        } else {
                                          return _buildContainer(context,
                                              "More", Icons.more_horiz);
                                        }
                                      },
                                    ),
                                  )),
                            ),
                            /*Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          Languages.of(context)!.labelNews,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.25),
                        ),
                      ),*/
                            // News and Offer List
                            /* SizedBox(
                        height: 15,
                      ),
                      NewsOfferListWidget(
                        data: imgList,
                        isInternetConnected: isInternetConnected,
                        isLoading: isLoading,
                      ),*/
                            SizedBox(
                              height: 30,
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Languages.of(context)!.labelTransaction}s",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/TransactionsScreen');
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "view all",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 3),
                                            width: screenWidth * 0.14,
                                            height: 0.5,
                                            decoration: BoxDecoration(
                                                color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                        Container(
                          height: screenHeight * 0.3,
                          margin: EdgeInsets.only(top: 6, left: 6, right: 6),
                          child: isInternetConnected && !isLoading
                              ? transactionList.isNotEmpty
                              ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: transactionList.length > 0 ? transactionList.length : 0,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 6),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){

                                  TransactionDialog.showDialogBox(context: context,transaction : transactionList[index], symbol: "${currencySymbol}");
                                },
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                child: Card(
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                          width: 0,
                                                          color: colorStatus(capitalizeFirstLetter(
                                                              "${transactionList[index].status}")))),
                                                  color: colorStatus(capitalizeFirstLetter(
                                                      "${transactionList[index].status}")),
                                                  child: Icon(
                                                    Icons.call_made,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    capitalizeFirstLetter(
                                                        "${transactionList[index].paymentRequestId}"),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                  Text(
                                                    capitalizeFirstLetter(
                                                        "${transactionList[index].status}"),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: colorStatus(capitalizeFirstLetter(
                                                            "${transactionList[index].status}"))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                addCurrencySymbolTransaction(
                                                    currencySymbol,
                                                    "${transactionList[index].amount}",
                                                    capitalizeFirstLetter(
                                                        "${transactionList[index].requestType}")),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    color: colorPaymentType(capitalizeFirstLetter(
                                                        "${transactionList[index].requestType}"))),
                                              ),
                                              Text(
                                                convertDateFormat(
                                                    "${transactionList[index].createdAt}"),
                                                style: TextStyle(fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                              : Center(
                            child: Text(
                              "No Transactions",
                              style: TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          )
                              : Container(
                            child: ShimmerList(
                              itemCount: 3,
                            ),
                          ),
                        ),

                        ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          isApiLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(
                        dismissible: false,
                        color: Colors.black.withOpacity(0.3)),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox(),
        ]),
      ),
    );
  }

  _showPicker({required BuildContext context}) {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Most Frequent",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    height: screenHeight * 0.12,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: _shortcutCardsList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index <= 1) {
                          return GestureDetector(
                            onTap: () {
                              if (_shortcutCardsList[index].title == "Add") {
                                Navigator.pop(context);
                                calledShortCut = "Add";
                                _getKycStatus();
                              } else if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelWithdraw) {
                                Navigator.pop(context);
                                calledShortCut =
                                    Languages.of(context)!.labelWithdraw;
                                _getKycStatus();
                              } else if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelTransfer) {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/TransferScreen');
                              } else {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, '/ComingSoonScreen');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.PRIMARY),
                                    child: Icon(
                                      _shortcutCardsList[index].icon,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  Text(
                                    _shortcutCardsList[index].title,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else
                          return Container();
                      },
                    ),
                  ),
                ),
                Text("Send",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  //height: screenSize.height/2,
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: _shortcutCardsList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 2) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/ComingSoonScreen');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.PRIMARY),
                                    child: Icon(
                                      _shortcutCardsList[index].icon,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  Text(
                                    _shortcutCardsList[index].title,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else
                          return Container();
                      },
                    ),
                  ),
                ),
                Text(
                  "Pay",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  //height: screenSize.height/2,
                  child: Container(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: _shortcutCardsList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 3) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/ComingSoonScreen');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.PRIMARY),
                                    child: Icon(
                                      _shortcutCardsList[index].icon,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  Text(
                                    _shortcutCardsList[index].title,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else
                          return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _countSelectedItems() {
    return _isChecked.where((item) => item).length;
  }

  colorStatus(String status) {
    Color color = Colors.black;
    if (status == "Pending") {
      color = Colors.orange;
    } else if (status == "Success") {
      color = Colors.green;
    } else if (status == "Rejected") {
      color = Colors.red;
    }
    return color;
  }

  _buildContainer(BuildContext context, String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: AppColor.PRIMARY,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: IconButton(
                onPressed: () => {
                      if (text == Languages.of(context)!.labelTransfer)
                        {Navigator.pushNamed(context, '/TransferScreen')}
                      else if (text == Languages.of(context)!.labelSend)
                        {}
                      else if (text == Languages.of(context)!.labelAddMoney)
                        {
                          calledShortCut = Languages.of(context)!.labelAddMoney,
                          _getKycStatus()
                        }
                      else if (text == Languages.of(context)!.labelWithdraw)
                        {
                          calledShortCut = Languages.of(context)!.labelWithdraw,
                          _getKycStatus()
                        }
                      else if (text == "More")
                        {_showPicker(context: context)}
                    },
                icon: Icon(
                  icon,
                  color: AppColor.WHITE,
                  size: 22,
                ))),
        Text(text, style: TextStyle(fontSize: 12))
      ],
    );
  }

  Future<void> _getKycStatus() async {
    kycStatus = (await Helper.getKycStatus())!;
    _fetchKycStatus();
  }

  void _fetchKycStatus() async {
    setState(() {
      isApiLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isApiLoading = false;
        isInternetConnected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      //await Future.delayed(Duration(milliseconds: 1));
      await Provider.of<MainViewModel>(context, listen: false)
          .kycStatusData("/api/v1/app/customers/check_customer_kyc_status");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getKycStatus(context, apiResponse);
    }
  }


  void _fetchDashboardData() async {
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
            content: Text('No internet connection'),
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
}
