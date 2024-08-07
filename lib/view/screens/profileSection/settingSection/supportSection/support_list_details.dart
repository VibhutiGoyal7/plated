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
  late bool isDarkMode;
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
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
        body: Stack(
          children: [
            SafeArea(
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                       /* SizedBox(
                          height: 4,
                        ),*/
                        Container(
                          child: Column(
                            children: [
                              _buildSection("Ticket Id :","${widget.data?.id}",isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                              _buildSection("Amount :","${widget.data?.amount}",isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey.shade200),
                              _buildSection("Transaction Id :","${widget.data?.trxId}", isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                              _buildSection("Payment time :",convertTime("${widget.data?.paymentTime}"), isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey.shade200),
                              _buildSection("Customer number :","${widget.data?.customerMerchantNumber}", isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                              _buildSection("Ticket created at :","${convertDateFormat("${widget.data?.createdAt}")} ${convertTime("${widget.data?.createdAt}")}", isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey.shade200),
                              _buildSection("Query type :","${widget.data?.queryType}", isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                              _buildSection("Transaction type :","${widget.data?.transactionType}", isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey.shade200),
                              _buildSection("Transaction method :","${widget.data?.transactionMethod}", isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                              _buildSection("Transaction provider :","${widget.data?.transactionProvider}", isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey.shade200),
                              _buildSection("Comment :","${widget.data?.comment}", isDarkMode ? AppColor.DARK_BG_COLOR : Colors.white54),
                            ],
                          ),
                        ),

                       //Spacer(),
                      /* Align(
                         alignment: Alignment.bottomRight,
                         child: FloatingActionButton(onPressed:(){
                           Navigator.pushNamed(context, "/SupportChatScreen", arguments: widget.data?.id);
                         },
                           child: Icon(Icons.support_agent_outlined),
                         ),
                       ),
                        SizedBox(height: 20,)*/



                      ]),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(onPressed:(){
                  Navigator.pushNamed(context, "/SupportChatScreen", arguments: widget.data?.id);
                },
                  child: Icon(Icons.support_agent_outlined),
                ),
              ),
            )
          ],
        ));
  }
  Widget _buildSection(String heading, String value, Color color){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color,
         border: Border.all(
             color:isDarkMode ? Colors.grey.shade800: Colors.grey, width: 0.1
         ),),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text("$heading")),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(capitalizeFirstLetter(
                "${value}")),
          )
        ],
      ),
    );
  }

}
