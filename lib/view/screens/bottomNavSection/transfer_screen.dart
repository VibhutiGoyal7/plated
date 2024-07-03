import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool inputValid = false;
  String amount = "0.00";
  final TextEditingController _inputController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "100",
    "200",
    "300",
    "400",
    "500"
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Languages.of(context)!.labelMoneyTransfer,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),
              SizedBox(height: 20,),
              Text(
                Languages.of(context)!.labelEnterAmount,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 26.0,
                        ),
                        controller: _inputController,
                        onChanged: (value) {
                          amount = value;
                        },
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {},
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: Languages.of(context)?.labelZero,
                        ),
                      ),
                    ),
                  ),
                  /*Text(
                    Languages.of(context)!.labelINR,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),*/
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${Languages.of(context)!.labelBalance}: 7,000 ${Languages.of(context)!.labelINR}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
              ),
              Container(
                height: screenHeight * 0.065, // Set the desired height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _allLogList.length,
                  padding: const EdgeInsets.only(bottom: 10),
                  // Adjust padding if needed
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _inputController.text = _allLogList[index];
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.18, // Adjust width as needed
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Card(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                _allLogList[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Languages.of(context)!.labelTransferTo,
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                Languages.of(context)!.labelName,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            Languages.of(context)!.labelChange,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(context),
              SizedBox(height: 10)
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
