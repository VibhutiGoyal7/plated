import 'dart:async';

import 'package:Payrio/model/response/kycStatusResponse.dart';
import 'package:Payrio/view/component/news_offer_list_widget.dart';
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
import '../../component/session_expired_dialog.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String kycStatus = "";
  String kycStatusApi = "";
  String amount = "0.00";
  String? name = "";
  var imageUrl;
  bool isAmountVisible = false;
  bool isUSDVisible = false;
  late List<bool> _isChecked; // Initialize as late to delay initialization
  late List<Shortcutitemlist>
      _shortcutCardsList; // Initialize as late to delay initialization

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
  List<String> _allLogList = [
    "Add money",
    "Add money",
    "Add money",
    "Add money",
  ];
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    imageUrl = "";

    _isChecked = List<bool>.generate(
        5, (index) => false); // Initial setup for 5 checkboxes
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.languageCode;
    Helper.getProfileDetails().then((userDetails) {
      setState(() {
        print("userDetails?.imageUrl${userDetails?.imageUrl}");
        name = userDetails?.firstName == null ? "Name" : userDetails?.firstName;
        imageUrl = userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
        print("imageUrl${imageUrl}");
      });
    });
    print("isoCountryCode:: $isoCountryCode");
    // Initial setup for 5 checkboxes
  }

  FutureOr onGoBack(dynamic value) {
    Helper.getProfileDetails().then((userDetails) {
      setState(() {
        print("userDetails?.imageUrl${userDetails?.imageUrl}");
        name = userDetails?.firstName == null ? "Name" : userDetails?.firstName;
        imageUrl = userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
        print("imageUrl${imageUrl}");
      });
    });
  }

  Widget getKycStatus(BuildContext context, ApiResponse apiResponse) {
    KycStatusResponse? kycStatusResponse =
        apiResponse.data as KycStatusResponse?;
    var message = kycStatusResponse?.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${kycStatusResponse?.kycStatus}");

        kycStatusApi = kycStatusResponse!.kycStatus!;

        if (kycStatus != "verified") {
          Navigator.pushNamed(context, '/VerifyIdentityScreen');
        }
        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if(apiResponse.message== "Invalid access token")
        {SessionExpiredDialog.showDialogBox(context: context);}
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _shortcutCardsList = [
      Shortcutitemlist(
          title: Languages.of(context)!.labelTransfer,
          icon: Icons.transfer_within_a_station_sharp,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelAddMoney,
          icon: Icons.add_rounded,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelSend,
          icon: Icons.send,
          selected: true),
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
      canPop: true,
      onPopInvoked: (bool didPop) {
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
            SystemNavigator.pop();
            //return Future.value(false);
          } else {
            SystemNavigator.pop();
          }
          // return Future.value(true);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.pushNamed(context, '/ProfileScreen')
                                    .then(onGoBack)
                              },
                              child: imageUrl == null || imageUrl == ""
                                  ? Container(
                                      height: 40,
                                      width: 40,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColor.WHITE,
                                        backgroundImage: AssetImage(
                                          "assets/profile_user.png",
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        imageUrl as String,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          // You can return any widget here to display in case of an error
                                          return Container(
                                            height: 40,
                                            width: 40,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColor.WHITE,
                                              backgroundImage: AssetImage(
                                                "assets/profile_user.png",
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.black45,
                                              highlightColor: Colors.black87,
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
                          SizedBox(width: 5),
                         /* Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Languages.of(context)!.labelStandard,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                      child: Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      )), // Add space between text and card
                                  Text(
                                    "100",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 20,
                                  )
                                ],
                              ),
                              Text(
                                "2900 Points to Silver",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),*/

                          // Add space between avatar and text
                          Text(
                            "${Languages.of(context)!.labelHi}, $name",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),

                          Spacer(),
                          IconButton(
                            icon: Icon(
                              isAmountVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isAmountVisible = !isAmountVisible;
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () => {
                              Navigator.pushNamed(
                                  context, "/NotificationScreen")
                            },
                          ),
                        ],
                      ),
                      // Add space between sections
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Languages.of(context)!.labelTotalBalance,
                                  style: TextStyle(
                                      fontSize: 16.0, letterSpacing: 1.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${isAmountVisible ? amount : "**"}  "
                            "${Languages.of(context)!.labelINR} ",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ), // Add space between text and amount

                      /*  Row(children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image(
                                      alignment: Alignment.topLeft,
                                      image: AssetImage(
                                          "assets/india_flag_icon.png"),
                                      width: 35,
                                      height: 35,
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "${Languages.of(context)!.labelINR} "
                                              "${isAmountVisible ? amount : "**"}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ),

                        SizedBox(width: 8), // Add space between cards
                        isUSDVisible
                            ? Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height:
                          MediaQuery.of(context).size.height * 0.15,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Image(
                                      alignment: Alignment.topLeft,
                                      image: AssetImage(
                                          "assets/united_states_flag_icon.png"),
                                      width: 35,
                                      height: 60,
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "${Languages.of(context)!.labelUSD} "
                                              "${isAmountVisible ? amount : "**"}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        )
                            : SizedBox(
                          width: 0,
                        ),
                      ]),*/
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) {
                              if (index <= 2) {
                                return _buildContainer(
                                    context,
                                    _shortcutCardsList[index].title,
                                    _shortcutCardsList[index].icon);
                              } else {
                                return _buildContainer(
                                    context, "More", Icons.more_horiz);
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        Languages.of(context)!.labelNews,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.25),
                      ),
                      // News and Offer List
                      SizedBox(
                        height: 10,
                      ),
                      NewsOfferListWidget(data: imgList),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${Languages.of(context)!.labelTransaction}s",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                      context, '/TransactionsScreen')
                                  .then(onGoBack);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "See all",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        //height: screenSize.height/2,
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: _allLogList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                      color: Colors.blue)),
                                              color: Colors.blue,
                                              child: Icon(
                                                Icons.wallet,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _allLogList[index],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Text("From Google Pay",
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "+INR 100.00",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("05/05/2024",
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                              // I omit the part to build card items from the list
                            },
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )),
    );
  }

  void _showModal(BuildContext context, List<Shortcutitemlist> options) {
    // Initialize _isChecked with false for each option
    _isChecked =
        List<bool>.generate(options.length, (index) => options[index].selected);
    print(_isChecked);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(options.length, (index) {
                  return CheckboxListTile(
                    checkboxShape: CircleBorder(),
                    title: Text(options[index].title),
                    value: _isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[index] = value ?? false;
                      });
                    },
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int selectedCount = _countSelectedItems();
                    if (selectedCount == 4) {
                      print('Number of selected items: $selectedCount');
                      Navigator.of(context).pop();
                    } else {
                      ToastComponent.showToast(
                          context: context, message: "Select minimum 4 items");
                    }
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
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
                            onTap: (){
                              if(_shortcutCardsList[index].title == "Add") {
                                Navigator.pop(context);
                                _getKycStatus();
                              }else{
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/ComingSoonScreen');
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
                                        color: Colors.blue),
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
                            onTap: (){
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
                                        color: Colors.blue),
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
                            onTap: (){
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
                                        color: Colors.blue),
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

  _buildContainer(BuildContext context, String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: IconButton(
                onPressed: () => {
                      if (text == Languages.of(context)!.labelTransfer)
                        {}
                      else if (text == Languages.of(context)!.labelSend)
                        {}
                      else if (text == Languages.of(context)!.labelAddMoney)
                        {_getKycStatus()}
                      else if (text == "More")
                        {_showPicker(context: context)}
                    },
                icon: Icon(
                  icon,
                  color: AppColor.WHITE,
                  size: 28,
                ))),
        Text(text, style: TextStyle(fontSize: 12))
      ],
    );
  }

  Future<void> _getKycStatus() async {
    kycStatus = (await Helper.getKycStatus())!;
    if (kycStatus == "verified") {
      Navigator.pushNamed(context, '/PaymentMethodScreen');
    } else {
      _fetchKycStatus();
    }
  }

  void _fetchKycStatus() async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .kycStatusData("/api/v1/app/customers/check_customer_kyc_status");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getKycStatus(context, apiResponse);
  }
}
