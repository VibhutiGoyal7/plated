import 'package:Payrio/model/request/P2PTransactionListRequest.dart';
import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/api_response.dart';
import '../../../../model/response/p2PTransactionListReponse.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/ShimmerList.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/session_expired_dialog.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String kycStatus = "";
  String amount = "";
  String status = "";
  String requestType = "";
  late int? userId;
  bool expanded = false;
  bool inputValid = false;
  bool filterApplied = false;
  List<TransactionDetails> transactionList = [];
  List<P2PTransactionDetails> p2PTransactionList = [];
  List<TransactionDetails> filteredTransactionList = [];
  List<P2PTransactionDetails> filteredP2PTransactionList = [];
  final tokenInputController = TextEditingController();
  final _numberOfPostsPerRequest = 20;
  var screenHeight;
  var screenWidth;
  var countryCurrencySymbol;
  var country;
  var currentBalance;
  late bool isDarkMode;
  bool isTransactional = false;

  String dwType = "dw";
  String p2pType = "p2p";
  String selectedNotificationType = "";

  ScrollController _firstTabController = ScrollController();
  ScrollController _secondTabController = ScrollController();

  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void>? _fetchDataFuture;
  Future<void>? _fetchP2PDataFuture;
  static const maxDuration = Duration(seconds: 2);

  bool isLoading = true;
  bool isInternetConnected = true;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    inputValid = false;
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
      _secondTabController.addListener(_transactionalLoadMore);
    _fetchP2PDataFuture = _fetchP2PData(_currentPage, filterApplied, false);

      _firstTabController.addListener(_generalLoadMore);
      _fetchDataFuture = _fetchDWData(_currentPage, filterApplied, false);

  }

  @override
  void dispose() {
    tokenInputController.dispose();
    _firstTabController.dispose();
    _secondTabController.dispose();
    super.dispose();
  }

 /* void _loadMore() async {
    if (!_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchDWData(_currentPage, filterApplied, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }*/

  Future<void> _fetchDWData(
      int pageKey, bool filterApplied, bool isScroll) async
  {
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
        TransactionListRequest request = TransactionListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          status: nonCapitalizeString(status),
          uniqueId: '',
          transactionType: nonCapitalizeString(requestType),
        );
        await Provider.of<MainViewModel>(context, listen: false)
            .transactionListData(
                "api/v1/app/wallet_transactions/list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getTransactionData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> _fetchP2PData(
      int pageKey, bool filterApplied, bool isScroll) async
  {
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
        P2PTransactionListRequest request = P2PTransactionListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          status: nonCapitalizeString(status),
          uniqueId: '',
        );
        await Provider.of<MainViewModel>(context, listen: false)
            .p2PTransactionListData(
                "api/v1/app/transfer_transactions/custom_list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getP2PTransactionData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async
  {
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
  Future<void> getP2PTransactionData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async
  {
    P2PTransactionListResponse? p2PTransactionListResponse =
        apiResponse.data as P2PTransactionListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = p2PTransactionListResponse?.data ?? [];
        setState(() {
          if (!isScroll) {
            filteredP2PTransactionList.clear();
          }
          filterApplied
              ? filteredP2PTransactionList.addAll(newItems)
              : p2PTransactionList.addAll(newItems);
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

  Map<String, List<TransactionDetails>> groupTransactionsByDate(
      List<TransactionDetails> transactions) {
    Map<String, List<TransactionDetails>> groupedTransactions = {};

    for (var transaction in transactions) {
      String date = convertDateFormat("${transaction.createdAt}");
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }

  Map<String, List<P2PTransactionDetails>> groupP2PTransactionsByDate(
      List<P2PTransactionDetails> transactions) {
    Map<String, List<P2PTransactionDetails>> groupedTransactions = {};
    for (var transaction in transactions) {
      String date = convertDateFormat("${transaction.createdAt}");
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }



  runApi(int? index){
    if(index == 0){
      setState(() {
        selectedNotificationType = dwType;
        isLoading =true;
        isTransactional = false;
        status = "";
      });
      _currentPage = 1;
      filteredTransactionList.clear();
      transactionList.clear();
      p2PTransactionList.clear();
      filteredP2PTransactionList.clear();
      _firstTabController.addListener(_generalLoadMore);
      //_fetchData(_currentPage, true);
      _fetchDataFuture = _fetchDWData(_currentPage, filterApplied, false);
      //_fetchPaginatedNotifications(selectedNotificationType, _currentPage);
      //
    }
    else{
      setState(() {
        selectedNotificationType = p2pType;
        isLoading =true;
        isTransactional = true;
        status = "";
      });
      _currentPage = 1;
      filteredTransactionList.clear();
      transactionList.clear();
      p2PTransactionList.clear();
      filteredP2PTransactionList.clear();
      _secondTabController.addListener(_transactionalLoadMore);
      _fetchP2PDataFuture = _fetchP2PData(_currentPage,  filterApplied, false);
      //_fetchPaginatedNotifications(selectedNotificationType, _currentPage);
      // _fetchDataFuture = _fetchData(_currentPage, false);

    }
  }

  void _generalLoadMore() async {
    if (!_isLoadingMore &&
        _firstTabController.position.pixels ==
            _firstTabController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchDWData(_currentPage,  filterApplied, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  void _transactionalLoadMore() async {
    if (!_isLoadingMore &&
        _secondTabController.position.pixels ==
            _secondTabController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchP2PData(_currentPage,   filterApplied, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Group transactions by date
    Map<String, List<TransactionDetails>> groupedTransactions =
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
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
        );
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            toolbarHeight: 65,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "${Languages.of(context)!.labelTransaction}s",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    _showModal(context, apiResponse);
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                    size: 28,
                  )),
              SizedBox(
                width: 5,
              )
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, /*left: 10, right: 10*/),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                    /*    Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Column(
                              children: [
                                Text(
                                  "${Languages.of(context)?.labelTotalBalance}",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  currencyFormat(countryCurrencySymbol,
                                      currentBalance, country),
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          ],
                        ),*/
                        TabBar(
                          dividerHeight: 0.5,
                          labelColor: AppColor.WHITE,
                          unselectedLabelColor: AppColor.PRIMARY,
                          indicatorPadding: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          labelPadding: EdgeInsets.zero,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          indicator: BoxDecoration(
                            color: AppColor.PRIMARY,
                          ),
                          onTap: (index) {
                            runApi(index);
                          },
                          dividerColor: Colors.transparent,
                          tabs: [
                            Container(
                              width: screenWidth * 0.5,
                              child: Tab(
                                  text:
                                      "D/W"),
                            ),
                            Container(
                              width: screenWidth * 0.5,
                              child: Tab(
                                  text:
                                      "P2P"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              generalNotification(),
                              transactionalNotification()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _isLoadingMore
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                          dismissible: false,
                        ),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
    );
  }

  Widget generalNotification() {

    return Container(
      width: screenWidth,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: isInternetConnected && !isLoading
            ? checkListEmpty()
                ? FutureBuilder(
                    future: _fetchDataFuture,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading data'));
                      } else {
                        // Group transactions by date
                        Map<String, List<TransactionDetails>>
                            groupedTransactions = groupTransactionsByDate(
                                filterApplied
                                    ? filteredTransactionList
                                    : transactionList);
                        List<String> dates =
                            groupedTransactions.keys.toList();

                        return ListView.builder(
                          controller: _firstTabController,
                          itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == dates.length) {
                              return Center(
                                  child: CircularProgressIndicator());
                            }
                            String date = dates[index];
                            List<TransactionDetails> transactionsForDate =
                                groupedTransactions[date]!;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                  ...transactionsForDate.map((transaction) {
                                    return TransactionItem(
                                      transaction: transaction,
                                      symbol: countryCurrencySymbol,
                                      userId: userId,
                                    );
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

  Widget transactionalNotification() {
    return Container(
      width: screenWidth,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: isInternetConnected && !isLoading
            ? checkP2PListEmpty()
                ? FutureBuilder(
                    future: _fetchP2PDataFuture,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading data'));
                      } else {
                        // Group transactions by date
                        Map<String, List<P2PTransactionDetails>>
                            groupedTransactions = groupP2PTransactionsByDate(
                                filterApplied
                                    ? filteredP2PTransactionList
                                    : p2PTransactionList);
                        List<String> dates =
                            groupedTransactions.keys.toList();

                        return ListView.builder(
                          controller: _secondTabController,
                          itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == dates.length) {
                              return Center(
                                  child: CircularProgressIndicator());
                            }
                            String date = dates[index];
                            List<P2PTransactionDetails> transactionsForDate =
                                groupedTransactions[date]!;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                  ...transactionsForDate.map((transaction) {
                                    return P2PTransactionItem(
                                      transaction: transaction,
                                      symbol: countryCurrencySymbol,
                                      userId: userId,
                                    );
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
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Languages.of(context)?.labelFilterPayment}",
                        style: TextStyle(fontSize: 22),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        style:
                            ButtonStyle(iconSize: WidgetStateProperty.all(30)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
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
                      !isTransactional ?
                      filterStatusCard(
                          "${Languages.of(context)?.labelRejected}", setState) : SizedBox(),
                    ],
                  ),
                  isTransactional ?
                      SizedBox():
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      Text(
                        "${Languages.of(context)?.labelRequestType}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          filterRequestTypeCard(
                              "${Languages.of(context)?.labelDeposit}", setState),
                          filterRequestTypeCard(
                              "${Languages.of(context)?.labelWithdraw}", setState),
                        ],
                      ),
                    ],
                  ),

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
    return GestureDetector(
      onTap: () {
        setState(() {
          status = text;
        });
      },
      child: Card(
        color: status == text
            ? AppColor.PRIMARY
            : isDarkMode
                ? AppColor.DARK_CARD_COLOR
                : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.5,
                color: status == text
                    ? AppColor.PRIMARY
                    : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            text,
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
    );
  }

  Widget filterRequestTypeCard(String text, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          requestType = text;
        });
      },
      child: Card(
        color: requestType == text
            ? AppColor.PRIMARY
            : isDarkMode
                ? AppColor.DARK_CARD_COLOR
                : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.5,
                color: requestType == text
                    ? AppColor.PRIMARY
                    : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.3,
                child: ElevatedButton(
                  onPressed: () async {
                    if(!isTransactional) {
                      setState(() {
                        status = "";
                        requestType = "";
                        filterApplied = false;
                        //Navigator.pop(context);
                        isLoading = true;
                        filteredTransactionList.clear();
                        transactionList.clear();
                      });
                      _fetchDataFuture =
                          _fetchDWData(_currentPage, filterApplied, false);
                    }else{
                      setState(() {
                        status = "";
                        requestType = "";
                        filterApplied = false;
                        //Navigator.pop(context);
                        isLoading = true;
                        filteredP2PTransactionList.clear();
                        p2PTransactionList.clear();
                      });
                      _fetchP2PDataFuture =
                          _fetchP2PData(_currentPage, filterApplied, false);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${Languages.of(context)?.labelClearAll}",
                    style: TextStyle(color: AppColor.PRIMARY),
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
              width: screenWidth * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if(!isTransactional) {
                      setState(() {
                        filterApplied = true;
                        _currentPage = 1;
                        isLoading = true;
                      });
                      _fetchDataFuture =
                          _fetchDWData(_currentPage, filterApplied, false);
                    }else{
                      setState(() {
                        filterApplied = true;
                        _currentPage = 1;
                        isLoading = true;
                      });
                      _fetchP2PDataFuture =
                          _fetchP2PData(_currentPage, filterApplied, false);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${Languages.of(context)?.labelApply}",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: AppColor.PRIMARY,
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

  bool checkListEmpty() {
    bool isListEmpty = false;
    if (!filterApplied) {
      isListEmpty = transactionList.isNotEmpty;
    } else {
      isListEmpty = filteredTransactionList.isNotEmpty;
    }
    return isListEmpty;
  }

  bool checkP2PListEmpty() {
    bool isListEmpty = false;
    if (!filterApplied) {
      isListEmpty = p2PTransactionList.isNotEmpty;
    } else {
      isListEmpty = filteredP2PTransactionList.isNotEmpty;
    }
    return isListEmpty;
  }


}


class TransactionItem extends StatelessWidget {
  final TransactionDetails transaction;
  final String symbol;
  final int? userId;

  TransactionItem(
      {required this.transaction, required this.symbol, required this.userId});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/TransactionOverviewScreen',
            arguments: transaction);
        //TransactionDialog.showDialogBox(context: context,transaction : transaction, symbol: symbol);
        //_showModal(context: context, transaction: transaction);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                width: 0.2, color: isDarkMode ? AppColor.WHITE : Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                        height: 31,
                        width: 31,
                        margin: EdgeInsets.all(6),
                        child: Text(
                          "${convertDateMonthFormat("${transaction.createdAt}")}",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    /*Container(
                                                height: 50,
                                                width: 50,
                                                child: Card(
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                          width: 0,
                                                          color: colorStatus(capitalizeFirstLetter(
                                                              "${transaction.status}")))),
                                                  color: colorStatus(capitalizeFirstLetter(
                                                      "${transaction.status}")),
                                                  child: Icon(
                                                    Icons.call_made,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),*/
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                                transaction.transactionType ==
                                            "${Languages.of(context)?.statusWithdraw}" ||
                                        transaction.transactionType ==
                                            "${Languages.of(context)?.statusTransfer}"
                                    ? Icons.call_made
                                    : Icons.call_received,
                                size: 15,
                                color: colorStatus(
                                    capitalizeFirstLetter(
                                        "${transaction.status}"),
                                    context)),
                            Text(
                              capitalizeFirstLetter("${transaction.uniqueId}"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          capitalizeFirstLetter("${transaction.status}"),
                          style: TextStyle(
                              fontSize: 11,
                              color: colorStatus(
                                  capitalizeFirstLetter(
                                      "${transaction.status}"),
                                  context)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      addCurrencySymbolTransaction(
                          symbol,
                          "${transaction.amount}",
                          capitalizeFirstLetter(
                              "${transaction.transactionType}"),
                          userId,
                          transaction.senderId),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: transaction.status ==
                                  "${Languages.of(context)?.statusInComplete}"
                              ? Colors.grey
                              : colorPaymentType(
                                  capitalizeFirstLetter(
                                      "${transaction.transactionType}"),
                                  userId,
                                  transaction.senderId)),
                    ),
                    Text(
                      "${convertTime("${transaction.createdAt}")}",
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
  }
}

class P2PTransactionItem extends StatelessWidget {
  final P2PTransactionDetails transaction;
  final String symbol;
  final int? userId;

  P2PTransactionItem(
      {required this.transaction, required this.symbol, required this.userId});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/P2PTransactionOverviewScreen',
            arguments: transaction);
        //TransactionDialog.showDialogBox(context: context,transaction : transaction, symbol: symbol);
        //_showModal(context: context, transaction: transaction);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                width: 0.2, color: isDarkMode ? AppColor.WHITE : Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                        height: 31,
                        width: 31,
                        margin: EdgeInsets.all(6),
                        child: Text(
                          "${convertDateMonthFormat("${transaction.createdAt}")}",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    /*Container(
                                                height: 50,
                                                width: 50,
                                                child: Card(
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                          width: 0,
                                                          color: colorStatus(capitalizeFirstLetter(
                                                              "${transaction.status}")))),
                                                  color: colorStatus(capitalizeFirstLetter(
                                                      "${transaction.status}")),
                                                  child: Icon(
                                                    Icons.call_made,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),*/
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                                transaction.transactionType ==
                                            "${Languages.of(context)?.statusWithdraw}" ||
                                        transaction.transactionType ==
                                            "${Languages.of(context)?.statusTransfer}"
                                    ? Icons.call_made
                                    : Icons.call_received,
                                size: 15,
                                color: colorStatus(
                                    capitalizeFirstLetter(
                                        "${transaction.status}"),
                                    context)),
                            Text(
                              capitalizeFirstLetter("${transaction.uniqueId}"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          capitalizeFirstLetter("${transaction.status}"),
                          style: TextStyle(
                              fontSize: 11,
                              color: colorStatus(
                                  capitalizeFirstLetter(
                                      "${transaction.status}"),
                                  context)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      addCurrencySymbolTransaction(
                          symbol,
                          "${transaction.amount}",
                          capitalizeFirstLetter(
                              "${transaction.transactionType}"),
                          userId,
                          transaction.senderId),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: transaction.status ==
                                  "${Languages.of(context)?.statusInComplete}"
                              ? Colors.grey
                              : colorPaymentType(
                                  capitalizeFirstLetter(
                                      "${transaction.transactionType}"),
                                  userId,
                                  transaction.senderId)),
                    ),
                    Text(
                      "${convertTime("${transaction.createdAt}")}",
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
  }
}
