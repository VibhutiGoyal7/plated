import 'package:Payrio/model/request/supportListRequest.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../model/apis/api_response.dart';
import '../../../../../model/response/allSupportTicketResponse.dart';
import '../../../../../utils/Helper.dart';
import '../../../../../utils/Util.dart';
import '../../../../../view_model/main_view_model.dart';
import '../../../../component/ShimmerList.dart';
import '../../../../component/connectivity_service.dart';
import '../../../../component/session_expired_dialog.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String kycStatus = "";
  String amount = "";
  String status = "";
  String requestType = "";
  bool expanded = false;
  bool inputValid = false;
  bool filterApplied = false;
  final int _pageSize = 10;
  List<AllSupportTicketsDetails> supportDataList = [];
  List<AllSupportTicketsDetails> filteredSupportDataList = [];
  final tokenInputController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final _numberOfPostsPerRequest = 20;
  var screenHeight;
  var screenWidth;
  var countryCurrencySymbol;
  var currentBalance;
  late bool isDarkMode;

  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void>? _fetchDataFuture;
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
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
    _scrollController.addListener(_loadMore);
    _fetchDataFuture = _fetchData(_currentPage, filterApplied, false);
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (!_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchData(_currentPage, filterApplied, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _fetchData(
      int pageKey, bool filterApplied, bool isScroll) async {
    print("Fetch Data");
    try {
      setState(() {
        //_isLoadingMore = true;
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
        SupportListRequest request = SupportListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          customerNumber: "",
          trxId: "",
          agentNumber: "",
        );
        await Provider.of<MainViewModel>(context, listen: false)
            .supportListData(
                "api/v1/app/payorio_support_tickets/list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getSupportData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getSupportData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async {
    AllSupportTicketsResponse? supportDataListResponse =
        apiResponse.data as AllSupportTicketsResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = supportDataListResponse?.data ?? [];
        setState(() {
          print("isScroll:: ${isScroll}  ${filterApplied}");
          if (!isScroll) {
            filteredSupportDataList.clear();
          }
          supportDataList.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message ==
            "${Languages.of(context)?.labelInvalidAccessToken}") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }

  Future<void> getFilteredSupportTicketData(
      BuildContext context, ApiResponse apiResponse) async {
    AllSupportTicketsDetails? supportDataListResponse =
        apiResponse.data as AllSupportTicketsDetails?;
    setState(() {
      isLoading = false;
      filteredSupportDataList.clear();
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        AllSupportTicketsDetails? newItems = supportDataListResponse;
        setState(() {
          //filteredSupportDataList.clear();
          filteredSupportDataList.add(newItems!);
          // : supportDataList.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message ==
            "${Languages.of(context)?.labelInvalidAccessToken}") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }

  Map<String, List<AllSupportTicketsDetails>> groupSupportDataByDate(
      List<AllSupportTicketsDetails> supportData) {
    Map<String, List<AllSupportTicketsDetails>> groupedSupportData = {};

    for (var transaction in supportData) {
      String date = convertDateFormat("${transaction.createdAt}");
      if (!groupedSupportData.containsKey(date)) {
        groupedSupportData[date] = [];
      }
      groupedSupportData[date]!.add(transaction);
    }
    return groupedSupportData;
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Group transactions by date
    Map<String, List<AllSupportTicketsDetails>> groupedSupportData =
        groupSupportDataByDate(
            filterApplied ? filteredSupportDataList : supportDataList);
    List<String> dates = groupedSupportData.keys.toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        print("DashBoard $didPop");
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/ProfileScreen",
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/ProfileScreen",
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                "/ProfileScreen",
              );
            },
          ),
          title: Text(
            "Support List",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.WHITE,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: _filterController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.search_rounded,
                              color: isDarkMode ? AppColor.WHITE: AppColor.PRIMARY
                            ),
                            onPressed: () => FocusScope.of(context).unfocus(),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                  color: isDarkMode ? AppColor.WHITE: AppColor.PRIMARY
                              ),
                              onPressed: () {
                                setState(() {
                                  _filterController.text = "";
                                  filterApplied = false;
                                });
                                _filterController.text = "";

                                // filterAccToTicketId("");
                              }),
                          hintText: Languages.of(context)!.labelSearch,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) =>
                            filterAccToTicketId(_filterController.text),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          child: isInternetConnected && !isLoading
                              ? checkListEmpty()
                                  ? FutureBuilder(
                                      future: _fetchDataFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<void> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child:
                                                  Text('Error loading data'));
                                        } else {
                                          // Group transactions by date
                                          Map<
                                                  String,
                                                  List<
                                                      AllSupportTicketsDetails>>
                                              groupedSupportData =
                                              groupSupportDataByDate(
                                                  filterApplied
                                                      ? filteredSupportDataList
                                                      : supportDataList);
                                          List<String> dates =
                                              groupedSupportData.keys.toList();

                                          return ListView.builder(
                                            controller: _scrollController,
                                            itemCount: dates.length +
                                                (_isLoadingMore ? 1 : 0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index == dates.length) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              String date = dates[index];
                                              List<AllSupportTicketsDetails>
                                                  supportDataForDate =
                                                  groupedSupportData[date]!;

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        date,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    ...supportDataForDate
                                                        .map((transaction) {
                                                      return TransactionItem(
                                                        transaction:
                                                            transaction,
                                                        symbol:
                                                            countryCurrencySymbol,
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
                                        "No Data Found",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                    )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18),
                                  child: ShimmerList(itemCount: 2),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : SizedBox(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        "/CreateSupportTicketScreen",
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> filterAccToTicketId(String ticketId) async {
    try {
      setState(() {
        isLoading = true;
        filterApplied = true;
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
        await Provider.of<MainViewModel>(context, listen: false)
            .getFilteredSupportTicket(
                "api/v1/app/payorio_support_tickets/$ticketId");
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getFilteredSupportTicketData(context, apiResponse);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
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
                        "Filter Payments",
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
                    "Status",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      filterStatusCard("Success", setState),
                      filterStatusCard("Pending", setState),
                      filterStatusCard("Rejected", setState),
                    ],
                  ),
                  Text(
                    "Request Type",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      filterRequestTypeCard("Deposit", setState),
                      filterRequestTypeCard("Withdraw", setState),
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
                    setState(() {
                      status = "";
                      requestType = "";
                      filterApplied = false;
                      //Navigator.pop(context);
                      isLoading = true;
                      filteredSupportDataList.clear();
                      supportDataList.clear();
                    });
                    _fetchDataFuture =
                        _fetchData(_currentPage, filterApplied, false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Clear All",
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
                    setState(() {
                      filterApplied = true;
                      _currentPage = 1;
                      isLoading = true;
                    });
                    _fetchDataFuture =
                        _fetchData(_currentPage, filterApplied, false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Apply",
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
      isListEmpty = supportDataList.isNotEmpty;
    } else {
      isListEmpty = filteredSupportDataList.isNotEmpty;
    }
    return isListEmpty;
  }
}

class TransactionItem extends StatelessWidget {
  final AllSupportTicketsDetails transaction;
  final String symbol;

  TransactionItem({required this.transaction, required this.symbol});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              width: 0.2, color: isDarkMode ? AppColor.WHITE : Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/SupportListDetails",
                arguments: transaction);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      child: Card(
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 0,
                                color: isDarkMode
                                    ? AppColor.WHITE
                                    : AppColor.PRIMARY)),
                        child: Icon(Icons.airplane_ticket,
                            color:
                                isDarkMode ? transaction.ticketStatus == "resolved" ? Colors.green : Colors.white : transaction.ticketStatus == "resolved" ? Colors.green : AppColor.PRIMARY),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeFirstLetter("${transaction.trxId}"),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                            capitalizeFirstLetter(
                                "${transaction.transactionType}"),
                            style: TextStyle(
                              fontSize: 11,
                              /* color: colorStatus(capitalizeFirstLetter(
                                    "${transaction.status}"))*/
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: Text(
                            "Ticket id :${transaction.id}",
                            style: TextStyle(
                              fontSize: 10,
                              /* color: colorStatus(capitalizeFirstLetter(
                                      "${transaction.status}"))*/
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                "${transaction.transactionTypeId}")),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          /*color: colorPaymentType(capitalizeFirstLetter(
                                "${transaction.transactionType}"))*/
                        )),
                    Text(convertTime("${transaction.createdAt}"),
                        style: TextStyle(fontSize: 11)),
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
