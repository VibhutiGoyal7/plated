
import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../view_model/main_view_model.dart';
import '../component/session_expired_dialog.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool isLoading = false;
  String kycStatus = "";
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
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
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    _fetchData();
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    super.dispose();
  }

  void _isValidInput() {
    //print(input);
    if (_amountController.text.isNotEmpty &&
        _amountController.text.length >= 2) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }


  Future<Widget> getTransactionData(
      BuildContext context, ApiResponse apiResponse) async {
    TransactionListResponse? transactionListResponse = apiResponse.data as TransactionListResponse?;
    print("apiResponse${apiResponse.status}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:

        print(transactionListResponse?.data);
        setState(() {
          transactionList = transactionListResponse?.data as List<TransactionDetails>;
        });
        //});
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Message : ${apiResponse.message}") ;
        if(apiResponse.message== "Invalid access token")
        {SessionExpiredDialog.showDialogBox(context: context);}
        print(apiResponse.message) ;
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
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
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
                      //height: screenSize.height/2,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: transactionList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
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
                                            "${transactionList[index].requestType}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text("${transactionList[index].bankService}",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${transactionList[index].amount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("${transactionList[index].paymentRequestId}",
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
                  ]
              ),
            )
        )
    );
  }

  _buildCard(BuildContext context,  String title,
      String icon,
      bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        child: isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.white38,
          highlightColor: Colors.grey,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(
                  8.0), // Adjust the radius as needed
            ),
          ),
        )
            :Row(
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
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.call_made_sharp,color: isDarkMode ? Colors.white :Colors.black,size: 18,),
            )
          ],
        ),
      ),
    );
  }

  void _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    TransactionListRequest request = TransactionListRequest(pageNo: 1, pageSize: 10, paymentRequestId: "", trxId: "", requestType: "", status: "");
    await Provider.of<MainViewModel>(context, listen: false)
        .transactionListData("/api/v1/app/transactions/list",request);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getTransactionData(context, apiResponse);
  }

}