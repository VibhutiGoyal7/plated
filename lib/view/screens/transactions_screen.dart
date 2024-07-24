import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/component/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../utils/Helper.dart';
import '../../utils/Util.dart';
import '../../view_model/main_view_model.dart';
import '../component/ShimmerList.dart';
import '../component/connectivity_service.dart';
import '../component/session_expired_dialog.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String kycStatus = "";
  String amount = "";
  String status = "";
  String requestType = "";
  bool expanded = false;
  bool inputValid = false;
  bool filterApplied = false;
  final int _pageSize = 10;
  List<TransactionDetails> transactionList = [];
  List<TransactionDetails> filteredTransactionList = [];
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _numberOfPostsPerRequest = 20;
  var screenHeight;
  var screenWidth;
  var countryCurrencySymbol;
  var currentBalance;

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
      /*setState(() {
        isLoading = true;
      });*/

      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('No internet connection'),
              duration: maxDuration,
            ),
          );
        });
      }else {
        TransactionListRequest request = TransactionListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          paymentRequestId: "",
          trxId: "",
          requestType: nonCapitalizeString(requestType),
          status: nonCapitalizeString(status),
        );
        await Provider.of<MainViewModel>(context, listen: false)
            .transactionListData(
            "api/v1/app/payment_transactions/list", request);
        ApiResponse apiResponse =
            Provider
                .of<MainViewModel>(context, listen: false)
                .response;
        await getTransactionData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionData(BuildContext context, ApiResponse apiResponse,
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
          print("isScroll:: ${isScroll}  ${filterApplied}");
          if (!isScroll) {
            filteredTransactionList.clear();
          }
          filterApplied
              ? filteredTransactionList.addAll(newItems)
              : transactionList.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Group transactions by date
    Map<String, List<TransactionDetails>> groupedTransactions =
        groupTransactionsByDate(
            filterApplied ? filteredTransactionList : transactionList);
    List<String> dates = groupedTransactions.keys.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${Languages.of(context)!.labelTransaction}s",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showModal(context, apiResponse);
              },
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 28,
              )),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Stack(
        children: [
          isLoading?
          Center(
            child: CircularProgressIndicator(),
          ): SizedBox(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Total Balance",
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.normal),
                          ),

                          isInternetConnected && !isLoading?
                          Text(
                            "${countryCurrencySymbol}${currentBalance}",
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ) : ShimmerText(height: 32,width: 100,),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Card(
                      elevation: 20,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        child:isInternetConnected && !isLoading ? FutureBuilder(
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
                                controller: _scrollController,
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        ...transactionsForDate.map((transaction) {
                                          return TransactionItem(
                                              transaction: transaction);
                                        }).toList(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ) : Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                        child: ShimmerList(itemCount: 2),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                        "Filter Payments",
                        style: TextStyle(fontSize: 22),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        style: ButtonStyle(
                          iconSize: WidgetStateProperty.all(30)
                        ),
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
        color: status == text ? AppColor.PRIMARY : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              color: status == text ? AppColor.WHITE : AppColor.BLACK,
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
        color: requestType == text ? AppColor.PRIMARY : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              color: requestType == text ? AppColor.WHITE : AppColor.BLACK,
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
}

class TransactionItem extends StatelessWidget {
  final TransactionDetails transaction;

  TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(width: 0.2, color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            _showPicker(context: context, transaction: transaction);
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
                      height: 50,
                      width: 50,
                      child: Card(
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 0,
                                color: colorStatus(capitalizeFirstLetter(
                                    "${transaction.status}")))),
                        color: colorStatus(
                            capitalizeFirstLetter("${transaction.status}")),
                        child: Icon(Icons.call_made, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeFirstLetter(
                              "${transaction.paymentRequestId}"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(capitalizeFirstLetter("${transaction.status}"),
                            style: TextStyle(
                                fontSize: 12,
                                color: colorStatus(capitalizeFirstLetter(
                                    "${transaction.status}")))),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(transaction.amount.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    /*Text(convertDateFormat("${transaction.createdAt}"),
                        style: TextStyle(fontSize: 12)),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPicker(
      {required BuildContext context,
      required TransactionDetails transaction}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bank Service"),
                    Text("${transaction.bankService}")
                  ],
                ),
                transaction.amount != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount"),
                          Text("${transaction.amount}")
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Status"), Text("${transaction.status}")],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bank Type"),
                    Text("${transaction.bankType}")
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Currency"), Text("${transaction.currency}")],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Request Type"),
                    Text("${transaction.requestType}")
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payment Request Id"),
                    Text("${transaction.paymentRequestId}")
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
}
