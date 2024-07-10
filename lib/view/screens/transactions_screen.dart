import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../utils/Util.dart';
import '../../view_model/main_view_model.dart';
import '../component/session_expired_dialog.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String kycStatus = "";
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
  final int _pageSize = 10;
  List<TransactionDetails> transactionList = [];
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _numberOfPostsPerRequest = 20;
  var screenHeight;

  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void>? _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    inputValid = false;
    _scrollController.addListener(_loadMore);
    _fetchDataFuture = _fetchData(_currentPage);
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
      await _fetchData(_currentPage);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _fetchData(int pageKey) async {
    print("Fetch Data");
    try {
      TransactionListRequest request = TransactionListRequest(
        pageNo: pageKey,
        pageSize: _numberOfPostsPerRequest,
        paymentRequestId: "",
        trxId: "",
        requestType: "",
        status: "",
      );
      await Provider.of<MainViewModel>(context, listen: false)
          .transactionListData("api/v1/app/payment_transactions/list", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      await getTransactionData(context, apiResponse, pageKey);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionData(
      BuildContext context, ApiResponse apiResponse, int pageKey) async {
    TransactionListResponse? transactionListResponse =
        apiResponse.data as TransactionListResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = transactionListResponse?.data ?? [];
        setState(() {
          transactionList.addAll(newItems);
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
    screenHeight = MediaQuery.of(context).size.height;

    // Group transactions by date
    Map<String, List<TransactionDetails>> groupedTransactions =
        groupTransactionsByDate(transactionList);
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _fetchDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else {
                      // Group transactions by date
                      Map<String, List<TransactionDetails>>
                          groupedTransactions =
                          groupTransactionsByDate(transactionList);
                      List<String> dates = groupedTransactions.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(child: CircularProgressIndicator());
                          }
                          String date = dates[index];
                          List<TransactionDetails> transactionsForDate =
                              groupedTransactions[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              ...transactionsForDate.map((transaction) {
                                return TransactionItem(
                                    transaction: transaction);
                              }).toList(),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionDetails transaction;

  TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                        side: BorderSide(width: 0, color: Colors.blue)),
                    color: Colors.blue,
                    child: Icon(Icons.wallet, color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirstLetter("${transaction.requestType}"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text("${transaction.bankService}",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(transaction.amount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(convertDateFormat("${transaction.createdAt}"),
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
