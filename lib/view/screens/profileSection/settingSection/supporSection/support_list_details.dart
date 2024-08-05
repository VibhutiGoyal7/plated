import 'package:Payrio/model/response/allSupportTicketResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../utils/Util.dart';

class SupportListDetailScreen extends StatefulWidget {
  final AllSupportTicketsDetails? data; // Define the 'data' parameter here

  SupportListDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  _SupportListDetailScreenState createState() => _SupportListDetailScreenState();
}

class _SupportListDetailScreenState extends State<SupportListDetailScreen> {
  bool isLoading = false;
  String amount = "";
  bool expanded = false;
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/SupportScreen');
            },
          ),
          title: Text(
            "Support ticket Details",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 8,
                ),
                _buildSection("Ticket Id :","${widget.data?.id}"),
                _buildSection("Amount :","${widget.data?.amount}"),
                _buildSection("Transaction Id :","${widget.data?.trxId}"),
                _buildSection("Payment time :",convertTime("${widget.data?.paymentTime}")),
                _buildSection("Customer number :","${widget.data?.customerMerchantNumber}"),
                _buildSection("Ticket created at :","${convertDateFormat("${widget.data?.createdAt}")} ${convertTime("${widget.data?.createdAt}")}"),
                _buildSection("Query type :","${widget.data?.queryType}"),
                _buildSection("Transaction type :","${widget.data?.transactionType}"),
                _buildSection("Transaction method :","${widget.data?.transactionMethod}"),
                _buildSection("Transaction provider :","${widget.data?.transactionProvider}"),
                _buildSection("Comment :","${widget.data?.comment}"),
               Spacer(),
               Align(
                 alignment: Alignment.bottomRight,
                 child: FloatingActionButton(onPressed:(){
                   Navigator.pushNamed(context, "/SupportChatScreen", arguments: widget.data?.id);
                 },
                   child: Icon(Icons.support_agent_outlined),
                 ),
               ),
                SizedBox(height: 20,)



              ]),
            )));
  }
  Widget _buildSection(String heading, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text("$heading"),
          Text(capitalizeFirstLetter(
              "${value}"))
        ],
      ),
    );
  }

}
