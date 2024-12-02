import 'dart:io';

import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/db/dao.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/db/BDPassDatabase.dart';
import '../../../model/db/dao.dart';
import '../../../model/response/notificationListResponse.dart';
import '../../../model/response/transactionListReponse.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String kycStatus = "";
  String amount = "";
  String status = "";
  String requestType = "";
  late int? userId;
  bool expanded = false;
  bool inputValid = false;
  bool filterApplied = false;
  List<NotificationDetails> transactionList = [];
  List<NotificationDetails> filteredTransactionList = [];
  final tokenInputController = TextEditingController();
  final _numberOfPostsPerRequest = 20;
  var screenHeight;
  var screenWidth;
  var countryCurrencySymbol;
  var country;
  var currentBalance;
  late bool isDarkMode;
  bool isDW = false;
  bool isTransactional = false;
  bool isMerchant = false;
  bool isTablet = false;
  String dwType = "dw";
  String p2pType = "p2p";
  String merchantType = "merchantDW";
  String selectedNotificationType = "";
  String selectedStartTime = "Start Date";
  String selectedEndTime = "End Date";

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  ScrollController _firstTabController = ScrollController();
  ScrollController _secondTabController = ScrollController();
  ScrollController _thirdTabController = ScrollController();
  final List<String> themeType = [
    "All",
    "Deposit",
    "Withdraw",
    "Transfer",
    "Payin",
    "Payout"
  ];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void>? _fetchDataFuture;
  Future<void>? _fetchP2PDataFuture;
  Future<void>? _fetchMerchantDataFuture;
  static const maxDuration = Duration(seconds: 2);
  String selectedValue = "All";
  bool isLoading = true;
  bool isInternetConnected = true;
  final TextEditingController _paymentStartDateController =
  TextEditingController(text: "00:00");
  final TextEditingController _paymentEndController =
  TextEditingController(text: "00:00");

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    selectedValue = themeType.first;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
      Brightness.light, // Light icons for the status bar
      //statusBarBrightness: Brightness.light,       // Status bar brightness (for iOS)
    ));
    Helper.getUserBalance().then((balance) {
      setState(() {
        currentBalance = balance;
      });
    });
    Helper.getProfileDetails().then((profile) {
      setState(() {
        userId = profile?.userId;
      });
    });
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
    Helper.getCountry().then((countryName) {
      setState(() {
        country = countryName;
      });
    });
    _firstTabController.addListener(_generalLoadMore);
    _fetchDataFuture =
        _fetchDWData(_currentPage, filterApplied, false, selectedValue);
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    _firstTabController.dispose();
    _secondTabController.dispose();
    _thirdTabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDWData(int pageKey, bool filterApplied, bool isScroll,
      String selectedValue) async {
    try {
      setState(() {
        //isLoading = true;
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
        if (selectedStartTime == "Start Date" ||
            selectedEndTime == "End Date") {
          /*TransactionListRequest request = TransactionListRequest(
              pageNo: pageKey,
              pageSize: _numberOfPostsPerRequest,
              status: nonCapitalizeString(status),
              uniqueId: '',
              transactionType: nonCapitalizeString(selectedValue),
              startDate: '',
              endDate: '');
          await Provider.of<MainViewModel>(context, listen: false)
              .transactionListData(
              "api/v1/app/customers/all_trx_list", request);*/
          ApiResponse apiResponse =
              Provider.of<MainViewModel>(context, listen: false).response;
         // await getTransactionData(context, apiResponse, pageKey, isScroll);
        } else {
          /*TransactionListRequest request = TransactionListRequest(
              pageNo: pageKey,
              pageSize: _numberOfPostsPerRequest,
              status: nonCapitalizeString(status),
              uniqueId: '',
              transactionType: nonCapitalizeString(selectedValue),
              startDate: selectedStartTime,
              endDate: selectedEndTime);
          await Provider.of<MainViewModel>(context, listen: false)
              .transactionListData(
              "api/v1/app/customers/all_trx_list", request);*/
          ApiResponse apiResponse =
              Provider.of<MainViewModel>(context, listen: false).response;
         // await getTransactionData(context, apiResponse, pageKey, isScroll);
        }
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

 /* Future<void> getTransactionData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async {
    TransactionListResponse? transactionListResponse =
    apiResponse.data as TransactionListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = transactionListResponse?.data ?? [];
        setState(() {
          if (!isScroll) {
            filteredTransactionList.clear();
          }
          filterApplied
              ? filteredTransactionList.addAll(newItems)
              : transactionList.addAll(newItems);
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
*/
  Map<String, List<NotificationDetails>> groupTransactionsByDate(
      List<NotificationDetails> notifications) {
    Map<String, List<NotificationDetails>> groupedTransactions = {};

    for (var notification in notifications) {
      String date = convertDateFormat("${notification.date}");
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(notification);
    }
    return groupedTransactions;
  }

  runApi(int? index) {
    setState(() {
      selectedNotificationType = dwType;
      isLoading = true;
      isDW = true;
      isTransactional = false;
      isMerchant = false;
      status = "";
    });
    _currentPage = 1;
    filteredTransactionList.clear();
    transactionList.clear();
    _firstTabController.addListener(_generalLoadMore);
    //_fetchData(_currentPage, true);
    _fetchDataFuture =
        _fetchDWData(_currentPage, filterApplied, false, selectedValue);
  }

  void _generalLoadMore() async {
    if (!_isLoadingMore &&
        _firstTabController.position.pixels ==
            _firstTabController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchDWData(_currentPage, filterApplied, true, selectedValue);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _buttonKey = GlobalKey();
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    isTablet = getIsTablet(context, screenWidth, screenHeight);
    // Group notifications by date
    Map<String, List<NotificationDetails>> groupedTransactions =
    groupTransactionsByDate(
        filterApplied ? filteredTransactionList : transactionList);
    List<String> dates = groupedTransactions.keys.toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/BottomNav",
            arguments: 0,
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
          arguments: 0,
        );
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushNamed(context, "/BottomNav", arguments: 0);
              }
            }
          }
        },
        onTap: () => {hideKeyBoard()},
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              Padding(
                padding: isTablet
                    ? const EdgeInsets.symmetric(horizontal: 25)
                    : const EdgeInsets.only(
                  top: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.0),
                        child: Text(
                          "History",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: AppColor.BLACK),
                        ),
                      ),
                      width: screenWidth,
                      alignment: Alignment.bottomLeft,
                      height: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/app_header_bg.png"),
                              fit: BoxFit
                                  .fitWidth) //AssetImage("assets/app_header_bg.png")
                      ),
                      //color: AppColor.PRIMARY_BLUE,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 15),
                      width: screenWidth,
                      child: Row(
                        key: _buttonKey,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.75,
                              minWidth: screenWidth * 0.2,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                final RenderBox button = _buttonKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final RenderBox overlay = Overlay.of(context)
                                    .context
                                    .findRenderObject() as RenderBox;

                                // Calculate the position of the button relative to the screen
                                final Offset buttonPosition = button
                                    .localToGlobal(Offset.fromDirection(100));

                                // Adjusting the position for left alignment
                                final RelativeRect position =
                                RelativeRect.fromLTRB(
                                  0,
                                  buttonPosition.dy,
                                  0,
                                  overlay.size.height -
                                      buttonPosition.dy -
                                      button.size.height,
                                );

                                showMenu(
                                  context: context,
                                  position: position,
                                  items: themeType.map((item) {
                                    return PopupMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        capitalizeFirstLetter(item),
                                        style: TextStyle(color: AppColor.WHITE),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                ).then((value) async {
                                  if (value != null) {
                                    setState(() {
                                      selectedValue = value;
                                      _currentPage = 1;
                                      transactionList.clear();
                                      isLoading = true;
                                      _fetchDataFuture = _fetchDWData(
                                          _currentPage,
                                          filterApplied,
                                          false,
                                          value);
                                    });
                                  }
                                });
                              },
                              child: Container(
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.2),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    selectedValue.isEmpty
                                        ? Container(width: 40)
                                        : Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        capitalizeFirstLetter(
                                            selectedValue),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_sharp),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          if (!isMerchant)
                            GestureDetector(
                              onTap: () {
                                _showModal(context, apiResponse);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 12),
                                    decoration: BoxDecoration(
                                        color: filterApplied
                                            ? AppColor.PRIMARY
                                            : Colors.grey.shade100,
                                        border: Border.all(width: 0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Text(
                                      "Filter",
                                      style: TextStyle(
                                          color: filterApplied
                                              ? AppColor.WHITE
                                              : AppColor.BLACK),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                            )
                          //
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          Map<String, String> transactionMap = {
                            "All": "all",
                            "Deposit": "deposit",
                            "Withdraw": "withdraw",
                            "Transfer": "transfer",
                            "Payin": "payin",
                            "Payout": "payout",
                          };

                          if (transactionMap.containsKey(selectedValue)) {
                            return DWTransaction(
                                transactionMap[selectedValue]!);
                          } else {
                            return Center(child: Text('No Transactions'));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              isLoading
                  ? Stack(
                children: [
                  // Block interaction
                  ModalBarrier(
                    dismissible: false,
                  ),
                  // Loader indicator
                  /* Center(
                            child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_BLUE,),
                          ),*/
                ],
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DWTransaction(String transactionType) {
    return Container(
      width: screenWidth,
      child: Container(
        margin: EdgeInsets.only(top: 2),
        child: isInternetConnected && !isLoading
            ? checkListEmpty()
            ? FutureBuilder(
          future: _fetchDataFuture,
          builder:
              (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else {
              // Group notifications by date
              Map<String, List<NotificationDetails>>
              groupedTransactions = groupTransactionsByDate(
                  filterApplied
                      ? filteredTransactionList
                      : transactionList);
              List<String> dates = groupedTransactions.keys.toList();

              return ListView.builder(
                controller: _firstTabController,
                itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == dates.length) {
                    return Center(child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,));
                  }
                  String date = dates[index];
                  List<NotificationDetails> transactionsForDate =
                  groupedTransactions[date]!;

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0),
                          child: Text(
                            date,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                        ...transactionsForDate
                            .asMap()
                            .entries
                            .map((entry) {
                          return TransactionItem(
                              notification: entry.value,
                              symbol: countryCurrencySymbol,
                              userId: userId,
                              index: entry.key);
                        }).toList(),
                      ],
                    ),
                  );
                },
              );
            }
          },
        )
            : Center(
          child: Text(
            "${Languages.of(context)?.labelNoTransaction}",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
          child: ShimmerList(itemCount: 2),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, ApiResponse apiResponse) {
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      isScrollControlled: false,
      // Ensure the sheet takes full height
      constraints: BoxConstraints(maxWidth: screenWidth, minWidth: screenWidth),
      context: context,
      sheetAnimationStyle: AnimationStyle(
          curve: FlippedCurve(Curves.bounceInOut),
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300)),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Card(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Languages.of(context)?.labelFilterPayment}",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            color: isDarkMode
                                ? Colors.white
                                : Theme.of(context).cardColor,
                            style:
                            ButtonStyle(iconSize: WidgetStateProperty.all(30)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                      Wrap(spacing: 15, runSpacing: 15, children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStartDateInput(
                                context,
                                "Start Date",
                                _paymentStartDateController,
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                setState),
                            _buildEndDateInput(
                                context,
                                "End Date",
                                _paymentEndController,
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                setState),
                          ],
                        ),
                      ]),
                      Text(
                        "${Languages.of(context)?.labelStatus}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          filterStatusCard(
                              "${Languages.of(context)?.labelSuccess}", setState),
                          filterStatusCard(
                              "${Languages.of(context)?.labelPending}", setState),
                          filterStatusCard(
                              "${Languages.of(context)?.labelRejected}", setState),
                          filterStatusCard(
                              "Failed", setState),
                        ],
                      ),
/*                  isTransactional
                      ? SizedBox()
                      : Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            Text(
                              "${Languages.of(context)?.labelRequestType}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                filterRequestTypeCard(
                                    "${Languages.of(context)?.labelDeposit}",
                                    setState),
                                filterRequestTypeCard(
                                    "${Languages.of(context)?.labelWithdraw}",
                                    setState),
                              ],
                            ),
                          ],
                        ),*/
                      _buildFooter(context, apiResponse),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget filterStatusCard(String text, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 4) - 18;
    return GestureDetector(
      onTap: () {
        setState(() {
          status = text;
        });
      },
      child: IntrinsicWidth(
        child: Card(
          color: status == text
              ? Theme.of(context).cardColor
              : isDarkMode
              ? AppColor.DARK_CARD_COLOR
              : AppColor.WHITE,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.1,
                  color: status == text
                      ? Theme.of(context).cardColor
                      : isDarkMode
                      ? AppColor.WHITE
                      : AppColor.DARK_CARD_COLOR),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Container(
            width: cardWidth,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: status == text
                    ? AppColor.WHITE
                    : isDarkMode
                    ? AppColor.WHITE
                    : AppColor.DARK_CARD_COLOR,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterRequestTypeCard(String text, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 4) - 80;
    return GestureDetector(
      onTap: () {
        setState(() {
          requestType = text;
        });
      },
      child: Card(
        color: requestType == text
            ? Theme.of(context).cardColor
            : isDarkMode
            ? AppColor.DARK_CARD_COLOR
            : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.1,
                color: requestType == text
                    ? Theme.of(context).cardColor
                    : isDarkMode
                    ? AppColor.WHITE
                    : AppColor.DARK_CARD_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          width: cardWidth,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              color: requestType == text
                  ? AppColor.WHITE
                  : isDarkMode
                  ? AppColor.WHITE
                  : AppColor.DARK_CARD_COLOR,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 62;
    double cardApplyWidth = (screenWidth / 2) - 10;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: cardWidth,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isTransactional) {
                      setState(() {
                        status = "";
                        requestType = "";
                        filterApplied = false;
                        //Navigator.pop(context);
                        isLoading = true;
                        filteredTransactionList.clear();
                        transactionList.clear();
                        selectedStartTime = "Start Date";
                        selectedEndTime = "End Date";
                      });
                      _fetchDataFuture = _fetchDWData(
                          _currentPage, filterApplied, false, selectedValue);
                    } else {
                      setState(() {
                        status = "";
                        requestType = "";
                        filterApplied = false;
                        //Navigator.pop(context);
                        isLoading = true;
                      });
                      _fetchP2PDataFuture = _fetchDWData(
                          _currentPage, filterApplied, false, selectedValue);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${Languages.of(context)?.labelClearAll}",
                    style: TextStyle(color: Theme.of(context).cardColor),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: AppColor.WHITE,
                      elevation: 3,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ),
            Container(
              width: cardApplyWidth,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isTransactional) {
                      setState(() {
                        filterApplied = true;
                        _currentPage = 1;
                        isLoading = true;
                      });
                      _fetchDataFuture = _fetchDWData(
                          _currentPage, filterApplied, false, selectedValue);
                    } else {
                      setState(() {
                        filterApplied = true;
                        _currentPage = 1;
                        isLoading = true;
                      });
                      _fetchP2PDataFuture = _fetchDWData(
                          _currentPage, filterApplied, false, selectedValue);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${Languages.of(context)?.labelApply}",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Theme.of(context).cardColor,
                      elevation: 3,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartDateInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 28;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: Card(
            color: status == text
                ? Theme.of(context).cardColor
                : isDarkMode
                ? AppColor.DARK_CARD_COLOR
                : AppColor.WHITE,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.1,
                    color: status == text
                        ? Theme.of(context).cardColor
                        : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Container(
              height: 40,
              width: cardWidth,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    hideKeyBoard();
                    _selectDateTime(context, text, setState, "");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color:
                          isDarkMode ? AppColor.WHITE : AppColor.TEXT_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedStartTime,
                          style: TextStyle(
                            color: selectedStartTime == text
                                ? Colors.grey
                                : AppColor.TEXT_COLOR,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    /*GestureDetector(

                        child: Icon(Icons.timer_outlined)),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDateInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 28;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: Card(
            color: status == text
                ? Theme.of(context).cardColor
                : isDarkMode
                ? AppColor.DARK_CARD_COLOR
                : AppColor.WHITE,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.1,
                    color: status == text
                        ? Theme.of(context).cardColor
                        : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Container(
              height: 40,
              width: cardWidth,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    hideKeyBoard();
                    if (selectedStartTime != "Start Date") {
                      _selectDateTime(
                          context, text, setState, selectedStartTime);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color:
                          isDarkMode ? AppColor.WHITE : AppColor.TEXT_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedEndTime,
                          style: TextStyle(
                            color: selectedEndTime == text
                                ? Colors.grey
                                : AppColor.TEXT_COLOR,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    /*GestureDetector(

                        child: Icon(Icons.timer_outlined)),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool checkListEmpty() {
    bool isListEmpty = false;
    if (!filterApplied) {
      isListEmpty = transactionList.isNotEmpty;
    } else {
      isListEmpty = filteredTransactionList.isNotEmpty;
    }
    return isListEmpty;
  }

  Future<void> _selectDateTime(BuildContext context, String date,
      StateSetter setState, String startDate) async {
    DateTime start = DateTime(1960);
    if (startDate != "") {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      start = dateFormat.parse(startDate);
    }
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: start,
      // DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
      helpText: "${Languages.of(context)?.labelSelectDob}",
      confirmText: "${Languages.of(context)?.labelConfirm}",
      errorFormatText: '${Languages.of(context)?.labelEnterValidDate}',
      errorInvalidText: '${Languages.of(context)?.labelEnterDateInValidRange}',
      builder: (context, child) {
        return Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        final formattedDate = convertDateFormat(
            "${DateTime(selectedDate.year, selectedDate.month, selectedDate.day)}");

        if (date == "Start Date") {
          //if (selectedEndTime.isEmpty || selectedDate.isBefore(DateTime.parse(selectedEndTime))) {
          _paymentStartDateController.text = formattedDate;
          selectedStartTime = formattedDate;
          _paymentEndController.text = "00:00";
          selectedEndTime = "End Date";
          // } else {
          // Show error: Start date must be before end date.
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Start date must be before end date."),));
          // }
        } else {
          //if (selectedStartTime.isEmpty || selectedDate.isAfter(DateTime.parse(selectedStartTime))) {
          _paymentEndController.text = formattedDate;
          selectedEndTime = formattedDate;
          //} else {
          // Show error: End date must be after start date.
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("End date must be after start date."),));
          //}
        }
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _paymentStartDateController.text =
        "${time.hour}:${time.minute} ${time.period.name}";
        selectedStartTime = "${time.hour}:${time.minute} ${time.period.name}";
      });
    }
  }
}

class TransactionItem extends StatelessWidget {
  final NotificationDetails notification;
  final String symbol;
  final int? userId;
  final int? index;
  bool isTablet = false;
  late double screenHeight;
  late double screenWidth;

  TransactionItem(
      {required this.notification,
        required this.symbol,
        required this.userId,
        required this.index});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isTablet = getIsTablet(context, screenWidth, screenHeight);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/TransactionOverviewScreen',
            arguments: notification);
        //TransactionDialog.showDialogBox(context: context,notification : notification, symbol: symbol);
        //_showModal(context: context, notification: notification);
      },
      child: Card(
        elevation: 0,
        color: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
        /*index! % 2 == 0
            ? isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR
            : Theme.of(context).dividerColor,*/
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Card(
                          margin: EdgeInsets.all(0),
                          child: Container(
                            height: isTablet ? 21 : 31,
                            width: isTablet ? 21 : 31,
                            margin: EdgeInsets.all(6),
                            child: Text(
                              "${convertDateMonthFormat("${notification.date}")}",
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
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
                            Row(
                              children: [
                                /*Icon(
                                    notification.transactionType ==
                                                "${Languages.of(context)?.statusWithdraw}" ||
                                            notification.transactionType ==
                                                "${Languages.of(context)?.statusTransfer}"
                                        ? notification.transactionType ==
                                                    "${Languages.of(context)?.statusTransfer}" &&
                                                !checkMoneyOut(
                                                    capitalizeFirstLetter(
                                                        "${notification.transactionType}"),
                                                    notification.senderId,
                                                    userId)
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 15,
                                    color: colorStatus(
                                        capitalizeFirstLetter(
                                            "${notification.status}"),
                                        context)),*/
                                Text(
                                  capitalizeFirstLetter(
                                      "${notification.heading}"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            Text(
                              capitalizeFirstLetter("${notification.status}"),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: colorStatus(
                                      capitalizeFirstLetter(
                                          "${notification.status}"),
                                      context)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${convertTime("${notification.date}")}",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.1,
                width: screenWidth,
                color: isDarkMode ? AppColor.WHITE : Colors.black,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 8),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class NotificationDetails {
  String? status;
  String? heading;
  String? detail;
  String? date;

  NotificationDetails({
    this.status,
    this.heading,
    this.detail,
    this.date,
  });
}




