import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/theme/AppColor.dart';

import '../../Strings/Languages.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool inputValid = false;
  final TextEditingController _inputController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "100 INR",
    "200 INR",
    "300 INR",
    "400 INR",
    "500 INR"
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Money Transfer",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Languages.of(context)!.labelEnterAmount,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 26.0,
                      ),
                      controller: _inputController,
                      onChanged: (value) {},
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {},
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                    ),
                  ),
                  Text(
                    Languages.of(context)!.labelINR,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Balance: 7,000 ${Languages.of(context)!.labelINR}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
              ),
              Container(
                height: screenHeight*0.065, // Set the desired height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _allLogList.length,
                  padding: const EdgeInsets.only(bottom: 10), // Adjust padding if needed
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width*0.16, // Adjust width as needed
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          _allLogList[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Spacer(),
              Card(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transfer to",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                "Name",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Change",
                            style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                //print(_amountController.text);
                if (inputValid) {
                  //Navigator.pushNamed(context, '/VerifyIdentityScreen');
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      inputValid ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }
}
