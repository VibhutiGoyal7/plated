import 'dart:async';

import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:BDPass/model/response/dashboardResponse.dart';
import 'package:BDPass/model/response/kycStatusResponse.dart';
import 'package:BDPass/model/response/transactionListReponse.dart';
import 'package:BDPass/utils/Util.dart';
import 'package:BDPass/view/component/dashboard/dashBoard_card.dart';
import 'package:BDPass/view/component/toastMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/dao.dart';
import '../../../model/request/shortcutItemList.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';
import '../../component/session_expired_dialog.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String? dashBoardKycStatus = "";
  String kycStatusApi = "";
  String? amount = "0.00";
  String? currencySymbol = "";
  String? country;
  String calledShortCut = "";
  String? name = "";
  late int? userId;
  var imageUrl;
  var flagImg;
  bool isAmountVisible = true;
  bool isUSDVisible = false;
  late List<Shortcutitemlist> _shortcutCardsList;
  late BDPassDatabase database;
  late DashboardTransactionDao dashboardTransactionDao;
  late CustomerDataDao customerDataDao;
  static const maxDuration = Duration(seconds: 2);
  bool isLoading = false;
  bool isApiLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  late double screenHeight;
  late double screenWidth;
  final ConnectivityService _connectivityService = ConnectivityService();
  List<TransactionDetails?> transactionList = [];
  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    flagImg = "";
    receiver.start();
    // Listen to messages and print them
    receiver.messages.listen((message) {
      print("BroadCast");
      //getDashBoardDataFromApi();
    });

    Helper.getProfileDetails().then((profile) {
      setState(() {
        name = profile?.firstName;
        imageUrl = profile?.imageUrl;
        currencySymbol = profile?.countryCurrencySymbol;
        country = profile?.countryName;
        amount = profile?.balance;
        userId = profile?.userId;
      });
    });

    Helper.getKycStatus().then((status) {
      dashBoardKycStatus = status;
    });

    intializeDatabase();
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.languageCode;

    print("isoCountryCode:: $isoCountryCode");
    // Initial setup for 5 checkboxes
  }

  @override
  void dispose() {
    receiver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _shortcutCardsList = getShortCutList(context);
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
            print("Refreshh");
            return Future.delayed(Duration(seconds: 2), () {
              _fetchDashboardData();
            });
          },
          child: Stack(children: [
            Column(
              children: [
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: screenHeight * 0.3,
                          color: AppColor.PRIMARY,
                          alignment: AlignmentDirectional.center,
                        ),
                        SafeArea(
                          child: Container(
                            height: screenHeight * 0.9,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Card(
                                            color: isDarkMode
                                                ? Color(0xF0B5DCB5)
                                                : Color(0xFFE2FFDE),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            child: DashboardCard()),
                                      ),
                                      Positioned(
                                          top: 0,
                                          left: 18,
                                          child: Card(
                                            color: Colors.white,
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    color: AppColor.PRIMARY,
                                                    width: 3)),
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/profile_user.png"),
                                              height: 62,
                                              width: 62,
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(),
                                  SizedBox(),
                                  Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: Column(
                                      children: [
                                        _buildCard(
                                            Icons.file_open,
                                            "${Languages.of(context)?.labelAddDocuments}",
                                            "${Languages.of(context)?.labelRequestOfficialDocuments}"),
                                        GestureDetector(
                                          onTap: () {
                                            ToastComponent.showToast(context: context, message: "message");
                                            CustomLoader();
                                          },
                                          child: _buildCard(
                                              Icons.qr_code_scanner_rounded,
                                              "${Languages.of(context)?.labelScanQRCode}",
                                              "${Languages.of(context)?.labelUseYourCamera}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(),
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
          ]),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String heading, String detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 6),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(heading, style: TextStyle(fontSize: 14)),
              Text(detail,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey : Colors.black54)),
            ]),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            )
          ],
        ),
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
                  Languages.of(context)!.labelQuickAction,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Languages.of(context)!.labelMostFrequent,
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
                              if (_shortcutCardsList[index].title ==
                                  Languages.of(context)!.labelAddMoney) {
                                Navigator.pop(context);
                                calledShortCut =
                                    Languages.of(context)!.labelAddMoney;
                                /* if (checkKYCStatus()) {
                                  Navigator.pushNamed(
                                      context, '/PaymentMethodScreen');
                                } else {
                                  Navigator.pushNamed(
                                      context, '/ChooseDocScreen');
                                }*/
                              } else if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelWithdraw) {
                                Navigator.pop(context);
                                calledShortCut =
                                    Languages.of(context)!.labelWithdraw;
                                /* if (checkKYCStatus()) {
                                  Navigator.pushNamed(
                                      context, '/WithdrawMethodScreen');
                                } else {
                                  Navigator.pushNamed(
                                      context, '/ChooseDocScreen');
                                }*/
                                //_getKycStatus();
                              } else if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelTransfer) {
                                Navigator.pop(context);
                                // Navigator.pushNamed(context, '/TransferScreen');
                              } else if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelRequestQR) {
                                calledShortCut =
                                    Languages.of(context)!.labelWithdraw;
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, '/RequestQrScreen');
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
                                    padding: EdgeInsets.all(15),
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
                Text("${Languages.of(context)?.labelReceiveMoney}",
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
                              if (_shortcutCardsList[index].title ==
                                  Languages.of(context)?.labelRequestQR) {
                                calledShortCut =
                                    Languages.of(context)!.labelWithdraw;
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, '/RequestQrScreen');
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
                                    padding: EdgeInsets.all(15),
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
                  Languages.of(context)!.labelPay,
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
                                    padding: EdgeInsets.all(15),
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
                        {
                          /*Navigator.pushNamed(context, '/TransferScreen')*/
                        }
                      else if (text == Languages.of(context)!.labelSend)
                        {}
                      else if (text == Languages.of(context)!.labelAddMoney)
                        {
                          calledShortCut = Languages.of(context)!.labelAddMoney,
                          /* if (checkKYCStatus())
                            {
                              Navigator.pushNamed(
                                  context, '/PaymentMethodScreen')
                            }
                          else
                            {Navigator.pushNamed(context, '/ChooseDocScreen')}
*/
                          //_getKycStatus()
                        }
                      else if (text == Languages.of(context)!.labelRequestQR)
                        {
                          calledShortCut =
                              Languages.of(context)!.labelRequestQR,
                          /*  if (checkKYCStatus())
                            {Navigator.pushNamed(context, '/RequestQrScreen')}
                          else
                            {Navigator.pushNamed(context, '/ChooseDocScreen')}
*/
                          //_getKycStatus()
                        }
                      else if (text == Languages.of(context)!.labelWithdraw)
                        {
                          calledShortCut = Languages.of(context)!.labelWithdraw,
                          /* if (checkKYCStatus())
                            {
                              Navigator.pushNamed(
                                  context, '/WithdrawMethodScreen')
                            }
                          else
                            {Navigator.pushNamed(context, '/ChooseDocScreen')}
*/
                          //_getKycStatus()
                        }
                      else if (text == Languages.of(context)!.labelMore)
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

  void _fetchDashboardData() async {
    Helper.getProfileDetails().then((profile) async {
      CustomerData? customer =
          await customerDataDao.findCustomerByEmail("${profile?.email}");
      if (mounted) {
        if (customer?.email?.isNotEmpty == true) {
          name = customer?.firstName == null
              ? Languages.of(context)!.labelName
              : customer?.firstName;
          imageUrl = customer?.imageUrl == null ? "" : customer?.imageUrl;
          amount = customer?.balance == null ? "0.00" : customer?.balance;
          currencySymbol = customer?.countryCurrencySymbol == null
              ? ""
              : customer?.countryCurrencySymbol;
          dashBoardKycStatus = customer?.kycStatus;
        }
      }
    });

    List<TransactionDetails?> localTransactionList =
        await dashboardTransactionDao.findAllTransactions();
    if (localTransactionList.isNotEmpty) {
      print("localTransactionList.length::${localTransactionList.length}");
      setState(() {
        // Filter out null values and cast to non-nullable type
        transactionList.addAll(localTransactionList
            .where((item) => item != null)
            .cast<TransactionDetails>());
      });
      //getDashBoardDataFromApi();
    } else {
      setState(() {
        isLoading = true;
      });
      //getDashBoardDataFromApi();
    }
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

  Future<void> updateCustomerDashBoardDetails(
      DashboardResponse? dashboardResponse) async {
    if (dashboardResponse?.customerData?.tpin == null ||
        dashboardResponse?.customerData?.tpin == "") {
      // Navigator.pushNamed(context, '/TpinCreateScreen');
    }

    CustomerData? customerData = dashboardResponse?.customerData;
    await Helper.saveUserBalance(customerData?.balance);
    await Helper.saveCurrencySymbol(customerData?.countryCurrencySymbol);
    await Helper.saveKycStatus(customerData?.kycStatus);

    CustomerData? customer =
        await customerDataDao.findCustomerByEmail("${customerData?.email}");
    if (mounted) {
      if (customer?.email?.isNotEmpty == true) {
        await customerDataDao.updateCustomer(customerData!);
      } else {
        await customerDataDao.insertCustomer(customerData!);
      }
    }

    if (dashboardResponse?.customerRecentTxn?.isNotEmpty == true) {
      List<TransactionDetails?> localTransactionList =
          await dashboardTransactionDao.findAllTransactions();
      if (mounted) {
        // Iterate through customerRecentTxn
        for (var transactionData
            in dashboardResponse?.customerRecentTxn ?? []) {
          // Check if the transaction already exists in localTransactionList
          bool transactionExists = localTransactionList
              .any((localData) => localData?.id == transactionData.id);
          // If it doesn't exist, insert the transaction
          if (!transactionExists) {
            dashboardTransactionDao.insertTransaction(transactionData);
          }
        }
      }
    }

    setState(() {
      dashBoardKycStatus =
          customerData?.kycStatus == null ? "" : "${customerData?.kycStatus}";
      name = customerData?.firstName == null
          ? Languages.of(context)!.labelName
          : customerData?.firstName;
      imageUrl = customerData?.imageUrl == null ? "" : customerData?.imageUrl;
      amount = customerData?.balance == null ? "0.00" : customerData?.balance;
      currencySymbol = customerData?.countryCurrencySymbol == null
          ? ""
          : customerData?.countryCurrencySymbol;
      transactionList =
          dashboardResponse?.customerRecentTxn as List<TransactionDetails>;
      isLoading = false;
    });
  }

  bool checkKYCStatus() {
    return dashBoardKycStatus == "${Languages.of(context)?.statusVerified}";
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
    database = await $FloorBDPassDatabase
        .databaseBuilder('bd_pass_database.db')
        .build();

    dashboardTransactionDao = database.dashboardTransactionDao;
    customerDataDao = database.personDao;
    _fetchDashboardData();
  }

  Future<Widget> getDashboardData(
      BuildContext context, ApiResponse apiResponse) async {
    DashboardResponse? dashboardResponse =
        apiResponse.data as DashboardResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("GetDashboardData : ${dashboardResponse?.customerData?.email}");
        updateCustomerDashBoardDetails(dashboardResponse);

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
              amount = userDetails?.balance;
              dashBoardKycStatus = userDetails?.kycStatus;
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
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("GetKycStatus : ${kycStatusResponse?.kycStatus}");
        kycStatusApi = kycStatusResponse!.kycStatus!;
        if (kycStatusApi != Languages.of(context)!.statusVerified) {
          isApiLoading = false;
          // Navigator.pushNamed(context, '/ChooseDocScreen');
        } else if (nonCapitalizeString(kycStatusApi) ==
            nonCapitalizeString("${Languages.of(context)!.statusVerified}")) {
          isApiLoading = false;
          if (nonCapitalizeString(calledShortCut) ==
              nonCapitalizeString("${Languages.of(context)!.labelAdd}")) {
            calledShortCut = "";
            Navigator.pushNamed(context, '/PaymentMethodScreen');
          } else if (nonCapitalizeString(calledShortCut) ==
              nonCapitalizeString("${Languages.of(context)!.labelWithdraw}")) {
            calledShortCut = "";
            // Navigator.pushNamed(context, '/WithdrawMethodScreen');
          } else if (nonCapitalizeString(calledShortCut) ==
              nonCapitalizeString("${Languages.of(context)!.labelRequestQR}")) {
            calledShortCut = "";
            //Navigator.pushNamed(context, '/RequestQrScreen');
          }
        }
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
