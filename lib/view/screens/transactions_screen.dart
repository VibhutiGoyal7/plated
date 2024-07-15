import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  bool isLoadingMore = false;
  bool isLoadingPrevious = false;
  bool isFetching = false;
  String kycStatus = "";
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
  int currentPage = 1;
  int firstPage = 1;
  int totalPage = 1;
  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
  ];
  List<TransactionDetails> transactionList = [];
  late Map<String, List<TransactionDetails>> groupedTransactions;
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    groupedTransactions = groupTransactionsByDate(transactionList);
    _scrollController.addListener(_scrollListener);
    _fetchData(currentPage);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoadingMore) {
      if (currentPage < totalPage) {
        print("${currentPage}"  "${totalPage}");
        _fetchData(++currentPage);
      }
    }
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100 && !isLoadingPrevious) {
      if (firstPage > 1) {
        _fetchData(--firstPage);
      }
    }
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _isValidInput() {
    if (_amountController.text.isNotEmpty && _amountController.text.length >= 2) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  Future<Widget> getTransactionData(BuildContext context, ApiResponse apiResponse, int pageNo) async {
    TransactionListResponse? transactionListResponse = apiResponse.data as TransactionListResponse?;
    setState(() {
      if (pageNo > currentPage) {
        isLoadingMore = true;
      } else if (pageNo < firstPage) {
        isLoadingPrevious = true;
      }
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          int roundedResult = transactionListResponse?.pagy?.totalRow as int;
          totalPage = (roundedResult / 10).round();
            print("Total Page ${roundedResult}");
          transactionList.addAll(transactionListResponse?.data as List<TransactionDetails>);
          groupedTransactions = groupTransactionsByDate(transactionList);
          if (pageNo > currentPage) {
            isLoadingMore = false;
            currentPage = pageNo;
          } else if (pageNo < firstPage) {
            isLoadingPrevious = false;
            firstPage = pageNo;
          }
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return Center(child: Text('Please try again later!!!'));
      case Status.INITIAL:
      default:
        return Center(child: Text('Search for the song by Artist'));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                groupedTransactions.isNotEmpty
                    ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: groupedTransactions.keys.length + (isLoadingMore ? 1 : 0) + (isLoadingPrevious ? 1 : 0),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (BuildContext context, int index) {
                          if (isLoadingPrevious && index == 0) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (isLoadingMore && index == groupedTransactions.keys.length + (isLoadingPrevious ? 1 : 0)) {
                            return Center(child: CircularProgressIndicator());
                          }

                          int actualIndex = index - (isLoadingPrevious ? 1 : 0);
                          String dateKey = groupedTransactions.keys.elementAt(actualIndex);
                          List<TransactionDetails> transactionsForDate = groupedTransactions[dateKey]!;

                          return ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              dateKey,
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                            ),
                            children: transactionsForDate.map((transaction) {
                              return Container(
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
                                            shape: CircleBorder(side: BorderSide(width: 0, color: Colors.blue)),
                                            color: Colors.blue,
                                            child: Icon(
                                              Icons.wallet,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              capitalizeFirstLetter("${transaction.requestType}"),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            Text("${transaction.bankService}", style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${transaction.amount}",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertDateFormat("${transaction.createdAt}"),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    if (isLoadingMore || isLoadingPrevious)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                  ],
                )
                    : Text("No Data Found"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCard(BuildContext context, String title, String icon, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        child: isLoadingMore || isLoadingPrevious
            ? Shimmer.fromColors(
          baseColor: Colors.white38,
          highlightColor: Colors.grey,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Image(
                alignment: Alignment.topLeft,
                width: 25,
                image: AssetImage(icon),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.call_made_sharp,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<TransactionDetails>> groupTransactionsByDate(List<TransactionDetails> transactions) {
    Map<String, List<TransactionDetails>> groupedTransactions = {};

    for (var transaction in transactions) {
      String dateKey = convertDateFormat("${transaction.createdAt}");

      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }

      groupedTransactions[dateKey]!.add(transaction);
    }

    return groupedTransactions;
  }

  void _fetchData(int pageNo) async {
    if (isFetching) return;
    setState(() {
      isFetching = true;
    });
    TransactionListRequest request = TransactionListRequest(
      pageNo: pageNo,
      pageSize: 10,
      paymentRequestId: "",
      trxId: "",
      requestType: "",
      status: "",
    );
    await Provider.of<MainViewModel>(context, listen: false).transactionListData("/api/v1/app/payment_transactions/list", request);
    ApiResponse apiResponse = Provider.of<MainViewModel>(context, listen: false).response;
    await getTransactionData(context, apiResponse, pageNo);
    setState(() {
      isFetching = false;
    });
  }
}
